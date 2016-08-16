//
//  HXSShopViewController.m
//  store
//
//  Created by ArthurWang on 15/7/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSShopViewController.h"

// Controllers
#import "HXSWebViewController.h"
#import "HXSDormMainViewController.h"
#import "HXSMessageCenterViewController.h"
#import "HXSPrintMainViewController.h"

// Model
#import "HXSSite.h"
#import "HXSShopViewModel.h"
#import "HXSPersonal.h"
#import "HXSShop.h"

// Views
#import "HXSBannerLinkHeaderView.h"
#import "HXSShopNameTableViewCell.h"
#import "HXSShopNoticeTableViewCell.h"
#import "HXSShopActivityTableViewCell.h"
#import "HXSStoreAppEntryTableViewCell.h"
#import "HXSShopViewFootView.h"
#import "HXSLoadingView.h"
#import "HXSAdTableViewCell.h"
#import "HXSShopListSectionHeaderView.h"
#import "HXSAddressDecorationView.h"
#import "HXSLocationTitleView.h"
#import "HXSShopButton.h"
#import "HXSLocationTitleView.h"

// Others
#import "UINavigationBar+AlphaTransition.h"
#import "UIBarButtonItem+HXSRedPoint.h"

// cell height
static NSInteger const kTagNavigationTiemButton       = 10000;

static NSString * const kUserDefaultFirstLaunchKey    = @"firstLaunch";
static NSString * const kUserDefaultAppVersionKey     = @"appVersion";

static NSString * ShopNameTableViewCell               = @"HXSShopNameTableViewCell";
static NSString * ShopNameTableViewCellIdentifier     = @"HXSShopNameTableViewCell";
static NSString * ShopNoticeTableViewCell             = @"HXSShopNoticeTableViewCell";
static NSString * ShopNoticeTableViewCellIdentifier   = @"HXSShopNoticeTableViewCell";
static NSString * ShopActivityTableViewCell           = @"HXSShopActivityTableViewCell";
static NSString * ShopActivityTableViewCellIdentifier = @"HXSShopActivityTableViewCell";
static NSString * AdTableViewCell                     = @"HXSAdTableViewCell";

@interface HXSShopViewController () <UITableViewDelegate,
                                     UITableViewDataSource,
                                     HXSStoreAppEntryTableViewCellDelegate,
                                     HXSLocationTitleViewDelegate,
                                     HXSAdTableViewCellDelegate,
                                     HXSBannerLinkHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *shopTableView;

@property (nonatomic, strong) HXSBannerLinkHeaderView *shopHeaderView;
@property (nonatomic, strong) HXSShopViewModel        *shopModel;
@property (nonatomic, strong) NSArray                 *shopsDataSource;
@property (nonatomic, assign) CGFloat                 lastPositionOfScrollView;
@property (nonatomic, assign) BOOL                    isFreshing;

@property (nonatomic, strong) HXSShopViewFootView     *footView;

@property (nonatomic, strong) NSArray *stopAppEntriesArr;
@property (nonatomic, strong) NSArray *adAppEntriesArr;
@property (nonatomic, strong) UIColor *navBarOriginalBarTintColor;
@property (nonatomic, strong) UIColor *navBarOriginalTintColor;

@end

@implementation HXSShopViewController

#pragma mark - Life Cycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}   

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];

    [self initialTableView];
    
    [self initialKVOMethods];
    
    [self initialLocalAddress];
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [self refreshSlideAndShop];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar at_reset];
    [self.navigationController.navigationBar at_setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar at_setBackgroundColor:self.navBarOriginalBarTintColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObserver:self
                                               forKeyPath:USER_DEFAULT_LOCATION_MANAGER
                                                  context:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLoginCompleted
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLogoutCompleted
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kUnreadMessagehasUpdated
                                                  object:nil];
}


#pragma mark - override

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


#pragma mark - Intial Methods

- (void)initialNavigationBar
{
    // title view
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSBuildingArea *buildingArea   = locationMgr.currentBuildingArea;
    HXSSite *site                   = locationMgr.currentSite;
    HXSBuildingEntry *buildingEntry = locationMgr.buildingEntry;
    NSString *locationStr           = nil;
    
    if ((nil != site.name)
        && (0 < [site.name length])
        && (nil != buildingArea)
        && (0 < [buildingArea.name length])
        && (nil != buildingEntry)
        && (0 < [buildingEntry.buildingNameStr length])) {
        locationStr = [NSString stringWithFormat:@"%@%@%@", site.name, buildingArea.name, buildingEntry.buildingNameStr];
    } else {
        locationStr = @"请选择地址";
    }
    
    self.navigationItem.leftBarButtonItem  = nil;
    
    self.navBarOriginalBarTintColor = self.navigationController.navigationBar.barTintColor;
    HXSLocationTitleView *locationTitleView = [[HXSLocationTitleView alloc] init];
    locationTitleView.delegate = self;
    locationTitleView.locationStr = locationStr;
    
    self.navigationItem.titleView = locationTitleView;
    
    HXSShopButton *shopButton = [[HXSShopButton alloc] init];
    [shopButton addTarget:self action:@selector(openShopButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shopButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)initialTableView
{
    WS(weakSelf);
    self.shopTableView.tableFooterView = [[UIView alloc] init];
    self.shopTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.shopTableView registerNib:[UINib nibWithNibName:ShopNameTableViewCell bundle:nil] forCellReuseIdentifier:ShopNameTableViewCellIdentifier];
    [self.shopTableView registerNib:[UINib nibWithNibName:ShopNoticeTableViewCell bundle:nil] forCellReuseIdentifier:ShopNoticeTableViewCellIdentifier];
    [self.shopTableView registerNib:[UINib nibWithNibName:ShopActivityTableViewCell bundle:nil] forCellReuseIdentifier:ShopActivityTableViewCellIdentifier];
    [self.shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSStoreAppEntryTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSStoreAppEntryTableViewCell class])];
    [self.shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSAdTableViewCell class]) bundle:nil] forCellReuseIdentifier:AdTableViewCell];
    
    [self.shopTableView addRefreshHeaderWithCallback:^{
        [weakSelf refreshSlideAndShop];
    }];
}

- (void)initialKVOMethods
{
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:USER_DEFAULT_LOCATION_MANAGER
                                               options:NSKeyValueObservingOptionNew
                                               context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeLoginStatus)
                                                 name:kLoginCompleted
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeLoginStatus)
                                                 name:kLogoutCompleted
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUnreadMessageNumber)
                                                 name:kUnreadMessagehasUpdated
                                               object:nil];
}

- (void)initialLocalAddress
{
    BOOL shouldDisplayAddressVC = NO;
    
    NSString *appVersionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultFirstLaunchKey];
    if (isFirstLaunch) {
        NSString *localVersionStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultAppVersionKey];
        
        if (![localVersionStr isEqualToString:appVersionStr]) {
            shouldDisplayAddressVC = YES;
            
            [[NSUserDefaults standardUserDefaults] setObject:appVersionStr forKey:kUserDefaultAppVersionKey];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } else {
        shouldDisplayAddressVC = YES;
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultFirstLaunchKey];
        
        [[NSUserDefaults standardUserDefaults] setObject:appVersionStr forKey:kUserDefaultAppVersionKey];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (shouldDisplayAddressVC) {
        HXSLocationManager *locationMgr = [HXSLocationManager manager];
        HXSBuildingEntry *building = locationMgr.buildingEntry;
        
        if (0 >= [building.dormentryIDNum integerValue]) {
            [self resetPosition];
        }
    }
}


#pragma mark - Target Methods

- (void)resetPosition
{
    WS(weakSelf);
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    [locationMgr resetPosition:PositionBuilding completion:^{
        [weakSelf locationChanged];
    }];
}

- (void)clickMessageBtn:(UIButton *)button
{
    NSString *title = (self.title.length > 0) ? self.title : @"";
    [HXSUsageManager trackEvent:kUsageEventMessageCenter parameter:@{@"title":title}];
    
    BOOL hasExistedMessageVC = NO;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[HXSMessageCenterViewController class]]) {
            hasExistedMessageVC = YES;
            break;
        }
    }
    
    if (hasExistedMessageVC) {
        NSArray *controllers = self.navigationController.viewControllers;
        NSArray *result = [controllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject isKindOfClass:NSClassFromString(@"HXSMessageCenterViewController")];
        }]];
        
        if (result.count > 0) {
            [self.navigationController popToViewController:result[0] animated:YES];
        }
    } else {
        HXSMessageCenterViewController *messageCenterVC = [HXSMessageCenterViewController sharedManager];
        messageCenterVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:messageCenterVC animated:YES];
    }
}

- (void)openShopButtonClicked
{
    NSString *baseURL = [[ApplicationSettings instance] registerStoreManagerBaseURL];
    NSString *urlStr = [NSString stringWithFormat:@"%@?site_id=%d", baseURL, [[HXSLocationManager manager].currentSite.site_id intValue]];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.shopModel loadWebViewControllerWith:url from:self];
}


#pragma mark - Notification Methods

- (void)updateUnreadMessageNumber
{
    NSNumber *unreadMessageNum = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_UNREAD_MESSGE_NUMBER];
    
    if ((nil != unreadMessageNum)
        && [unreadMessageNum isKindOfClass:[NSNumber class]]) {
        if ([self.navigationItem.rightBarButtonItem.customView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
            if (kTagNavigationTiemButton == button.tag) {
                self.navigationItem.rightBarButtonItem.redPointBadgeValue = [NSString stringWithFormat:@"%@", unreadMessageNum];
            }
        }
    }
}


#pragma mark - KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:USER_DEFAULT_LOCATION_MANAGER]) {
        [self initialNavigationBar];
    }
}


#pragma mark - Location Methods

- (void)changeLoginStatus
{
    [self initialNavigationBar];
    
    [self refreshSlideAndShop];
}

- (void)locationChanged
{
    [self initialNavigationBar];
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [self refreshSlideAndShop];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (0 == section) {
        return 1;
    }
    
    if (1 == section) {
        return self.adAppEntriesArr.count == 0 ? 0 : 1;
    }
    
    return [self.shopsDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0 == indexPath.section) {
        HXSStoreAppEntryTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSStoreAppEntryTableViewCell class])
                                                                               forIndexPath:indexPath];
        [cell setupCellWithStoreAppEntriesArr:self.stopAppEntriesArr delegate:self];
        return cell;
    } else if (1 == indexPath.section) {
        HXSAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSAdTableViewCell class])
                                                                   forIndexPath:indexPath];
        cell.delegate = self;
        [cell setupItemImages:self.adAppEntriesArr];
        return cell;
    } else{
        HXSShopEntity *entity = [self.shopsDataSource objectAtIndex:indexPath.row];
        HXSShopNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopNameTableViewCellIdentifier
                                                                         forIndexPath:indexPath];
        [cell setupCellWithEntity:entity];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        if (0 < [self.stopAppEntriesArr count]) {
            return kHeightEntryCell;
        } else {
            return 0;
        }
    } else if (1 == indexPath.section) {
        return [HXSAdTableViewCell getCellHeightWithObject:self.adAppEntriesArr.firstObject];
    } else {
        return 120;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.1f;
    } else {
        if (section == 2) {
            return 33.0f;
        } else {
            return 10.0f;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (1 == section) {
        return 10.0f;
    }
    
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (2 == section) {
        HXSShopListSectionHeaderView *shopListSectionHeaderView = [HXSShopListSectionHeaderView shopListSectionHeaderView];
        return shopListSectionHeaderView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Must have selected the address
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSBuildingEntry *building = locationMgr.buildingEntry;
    
    if (0 >= [building.dormentryIDNum integerValue]) {
        [self resetPosition];
        return;
    }
    
    // Entry
    if (0 == indexPath.section || 1 == indexPath.section) {
        return;
    }
    
    HXSShopEntity *entity = [self.shopsDataSource objectAtIndex:indexPath.row];
    
    switch ([entity.shopTypeIntNum integerValue]) {
        case kHXSShopTypeDorm:
        {
            [self.shopModel loadDromViewControllerWithShopEntity:entity from:self];
            
        }
            break;
            
        case kHXSShopTypeDrink:
        {
            // Do nothing
            [self.shopModel loadDrinkViewControllerWithShopEntity:entity from:self];
        }
            break;
            
        case kHXSShopTypePrint:
        {
            [self.shopModel loadPrintViewControllerWithShopEntity:entity from:self];
        }
            break;
            
        case kHXSShopTypeStore:
        {
            // Do nothing
        }
            break;
            
        default:
        {
            // Do nothing
        }
            break;
    }
}


#pragma mark - HXSLocationTitleViewDelegate

- (void)changeLocation
{
    [HXSUsageManager trackEvent:kChangeLocation parameter:@{}];
    [self resetPosition];
}


#pragma mark - HXSBannerLinkHeaderViewDelegate

- (void)didSelectedLink:(NSString *)linkStr
{
    [self pushToVCWithLink:linkStr];
}


#pragma mark - HXSAdTableViewCellDelegate

- (void)AdTableViewCellImageTaped:(NSString *)linkStr
{
    [self pushToVCWithLink:linkStr];
}


#pragma mark - HXSStoreAppEntryTableViewCellDelegate

- (void)storeAppEntryTableViewCell:(HXSStoreAppEntryTableViewCell *)cell didSelectedLink:(NSString *)linkStr
{
    [self pushToVCWithLink:linkStr];
}


#pragma mark - Private Methods
#pragma mark - Fetch Data

- (void)refreshSlideAndShop
{
    [self fetchDormentrySlide];
    
    [self fetchShopList];
    
    [self fetchStoreAppEntires];
    
    [self fetchShopAdEntires];
}

- (void)fetchDormentrySlide
{
    __weak typeof(self) weakSelf = self;
    
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSStoreInletBanner)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              if (0 < [entriesArr count]) {
                                                  HXSStoreAppEntryEntity *item = [entriesArr objectAtIndex:0];
                                                  CGSize size = CGSizeMake(item.imageWidthIntNum.floatValue, item.imageHeightIntNum.floatValue);
                                                  CGFloat scaleOfSize = size.height/size.width;
                                                  if (isnan(scaleOfSize)
                                                      || isinf(scaleOfSize)) {
                                                      scaleOfSize = 1.0;
                                                  }
                                                  weakSelf.shopHeaderView.frame = CGRectMake(0,
                                                                                             0,
                                                                                             weakSelf.shopTableView.width,
                                                                                             scaleOfSize * weakSelf.shopTableView.width);
                                                  
                                                  
                                                  weakSelf.shopTableView.tableHeaderView = weakSelf.shopHeaderView;
                                                  [weakSelf.shopHeaderView setSlideItemsArray:entriesArr];
                                              } else {
                                                  weakSelf.shopTableView.tableHeaderView = nil;
                                              }
                                          }];
    
}

- (void)fetchShopAdEntires
{
    WS(weakSelf);
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];

    [self.shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSStoreInletActivity)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              if (kHXSNoError != status) {
                                                  [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                     status:message
                                                                                 afterDelay:1.5f];
                                                  
                                                  return ;
                                              }
                                              weakSelf.adAppEntriesArr = entriesArr;
                                              [weakSelf.shopTableView reloadData];
                                          }];
}

- (void)fetchShopList
{
    __weak typeof(self) weakSelf = self;
    
    HXSLocationManager *manager = [HXSLocationManager manager];
    NSNumber *siteIdIntNum = (0 < [manager.currentSite.site_id integerValue]) ? manager.currentSite.site_id : [[ApplicationSettings instance] defaultSiteID];
    NSNumber *dormentiryIDNum = (0 < [manager.buildingEntry.dormentryIDNum integerValue]) ? manager.buildingEntry.dormentryIDNum : [[ApplicationSettings instance] defaultDormentryID];
    
    [self.shopModel fetchShopListWithSiteId:siteIdIntNum
                                  dormentry:dormentiryIDNum
                                       type:[NSNumber numberWithInteger:kHXSShopTypeAll]
                              crossBuilding:@(1)
                                   complete:^(HXSErrorCode status, NSString *message, NSArray *shopsArr) {
                                       [weakSelf.shopTableView endRefreshing];
                                       [HXSLoadingView closeInView:weakSelf.view];
                                       
                                       if (kHXSNoError != status) {
                                           if (weakSelf.isFirstLoading) {
                                               [HXSLoadingView showLoadFailInView:weakSelf.view
                                                                            block:^{
                                                                                [weakSelf locationChanged];
                                                                            }];
                                           } else {
                                               [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                  status:message
                                                                              afterDelay:2.0f];
                                           }
                                           
                                           return ;
                                       }
                                       
                                       weakSelf.firstLoading = NO;
                                       
                                       weakSelf.shopsDataSource = shopsArr;
                                       
                                       if(weakSelf.shopsDataSource.count <= 0) {
                                           [weakSelf.shopTableView setTableFooterView:weakSelf.footView];
                                       } else {
                                           [weakSelf.shopTableView setTableFooterView:nil];
                                       }
                                       
                                       [weakSelf.shopTableView reloadData];
                                   }
     ];

}

- (void)fetchStoreAppEntires
{
    __weak typeof(self) weakSelf = self;
    
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSStoreInletEntry)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                    if (kHXSNoError != status) {
                                        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                           status:message
                                                                       afterDelay:1.5f];
                                        
                                        return ;
                                    }
                                    
                                              weakSelf.stopAppEntriesArr = entriesArr;
                                              [weakSelf.shopTableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                                                          withRowAnimation:UITableViewRowAnimationAutomatic];
                                }];
    
}


#pragma mark Puch To LinkStr VCs

- (void)pushToVCWithLink:(NSString *)linkStr
{
    // Must have selected the address
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSBuildingEntry *building      = locationMgr.buildingEntry;
    
    if (0 >= [building.dormentryIDNum integerValue]) {
        [self resetPosition];
        
        return;
    }
    
    NSURL *url = [NSURL URLWithString:linkStr];
    if (nil == url) {
        url = [NSURL URLWithString:[linkStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    UIViewController *viewController = [[HXSMediator sharedInstance] performActionWithUrl:url
                                                                               completion:nil];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark - Get Set Methods

- (HXSShopViewModel *)shopModel
{
    if (nil == _shopModel) {
        _shopModel = [[HXSShopViewModel alloc] init];
    }
    
    return _shopModel;
}

- (HXSBannerLinkHeaderView *)shopHeaderView
{
    if (nil == _shopHeaderView) {
        _shopHeaderView = [[HXSBannerLinkHeaderView alloc] initHeaderViewWithDelegate:self];
    }
    
    return _shopHeaderView;
}

- (HXSShopViewFootView *)footView
{
    if(_footView)
        return _footView;
    _footView = [HXSShopViewFootView footerView];
    [_footView.openShopButton addTarget:self action:@selector(openShopButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    return _footView;
}

- (NSArray *)adAppEntriesArr
{
    if (!_adAppEntriesArr)
    {
        _adAppEntriesArr = [[NSArray alloc] init];
    }
    return _adAppEntriesArr;
}

@end

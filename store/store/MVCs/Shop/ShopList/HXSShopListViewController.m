//
//  HXSShopListViewController.m
//  store
//
//  Created by ArthurWang on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopListViewController.h"

// Controller
#import "HXSWebViewController.h"
#import "HXSDormMainViewController.h"
#import "HXSPrintMainViewController.h"

// Model
#import "HXSShopViewModel.h"

// Views
#import "HXSShopNameTableViewCell.h"
#import "HXSShopNoticeTableViewCell.h"
#import "HXSShopActivityTableViewCell.h"
#import "HXSLoadingView.h"
#import "UIRenderingButton.h"

// Others
#import "HXSShopManager.h"

static NSString * ShopNameTableViewCell               = @"HXSShopNameTableViewCell";
static NSString * ShopNameTableViewCellIdentifier     = @"HXSShopNameTableViewCell";
static NSString * ShopNoticeTableViewCell             = @"HXSShopNoticeTableViewCell";
static NSString * ShopNoticeTableViewCellIdentifier   = @"HXSShopNoticeTableViewCell";
static NSString * ShopActivityTableViewCell           = @"HXSShopActivityTableViewCell";
static NSString * ShopActivityTableViewCellIdentifier = @"HXSShopActivityTableViewCell";

// cell height
static NSInteger const kHeightShopNameCell     = 90;
static NSInteger const kHeightShopNoticeCell   = 36;
static NSInteger const kHeightShopActivityLine = 21;

@interface HXSShopListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView                 *promptView;
@property (weak, nonatomic) IBOutlet UITableView            *shopTableView;

@property (nonatomic, strong) NSNumber                      *typeIntNum;
@property (nonatomic, strong) NSString                      *shopTypeNameStr;

@property (nonatomic, strong) HXSShopViewModel                  *shopModel;
@property (nonatomic, strong) NSArray                       *shopsDataSource;

@property (nonatomic, strong) UIButton                      *footerViewOpenStoreBtn;

@property (nonatomic, copy)   void(^printReturnBlock)(HXSShopEntity *entity);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *topImageViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *bottomButtonTopConstraint;

@end

@implementation HXSShopListViewController

#pragma mark - Life Cycle

+ (instancetype)createDromVCWithType:(NSNumber *)typeIntNum name:(NSString *)shopTypeNameStr
{
    HXSShopListViewController *shopListVC = [HXSShopListViewController controllerFromXib];
    
    shopListVC.typeIntNum      = typeIntNum;
    shopListVC.shopTypeNameStr = shopTypeNameStr;
    
    return shopListVC;
}

+ (instancetype)createDromVCWithType:(NSNumber *)typeIntNum
                                name:(NSString *)shopTypeNameStr
                       andPrintBlock:(void (^)(HXSShopEntity *entity))printReturnBlock;
{
    HXSShopListViewController *shopListVC = [HXSShopListViewController controllerFromXib];
    
    shopListVC.typeIntNum               = typeIntNum;
    shopListVC.shopTypeNameStr          = shopTypeNameStr;
    shopListVC.printReturnBlock         = printReturnBlock;
    
    return shopListVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];

    [self initialTableView];
    
    [self initPromptView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.typeIntNum       = nil;
    self.shopTypeNameStr  = nil;
    self.printReturnBlock = nil;
    
    self.shopTableView.delegate = nil;
    self.shopTableView.dataSource = nil;
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = [self getShopTypeTitle];
}

- (void)initialTableView
{
    self.shopTableView.delegate   = self;
    self.shopTableView.dataSource = self;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [view addSubview:self.footerViewOpenStoreBtn];
    self.shopTableView.tableFooterView = (self.typeIntNum.integerValue == kHXSShopTypeStore) ? nil : view;
    
    [self.shopTableView registerNib:[UINib nibWithNibName:ShopNameTableViewCell bundle:nil] forCellReuseIdentifier:ShopNameTableViewCellIdentifier];
    [self.shopTableView registerNib:[UINib nibWithNibName:ShopNoticeTableViewCell bundle:nil] forCellReuseIdentifier:ShopNoticeTableViewCellIdentifier];
    [self.shopTableView registerNib:[UINib nibWithNibName:ShopActivityTableViewCell bundle:nil] forCellReuseIdentifier:ShopActivityTableViewCellIdentifier];
    
    __weak typeof(self) weakSelf = self;
    [self.shopTableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchShopList];
    }];
    
    [HXSLoadingView showLoadingInView:self.view];
    [self fetchShopList];
}

- (NSString *)getShopTypeTitle {
    // label
    NSString *titleStr = nil;
    switch ([self.typeIntNum integerValue]) {
        case kHXSShopTypeDorm:
        {
            titleStr = @"夜猫店";
        }
            break;
            
        case kHXSShopTypeDrink:
        {
            titleStr = @"饮品店";
        }
            break;
            
        case kHXSShopTypePrint:
        {
            titleStr = @"云印店";
        }
            break;
            
        case kHXSShopTypeStore:
        {
            titleStr = @"云超市";
        }
            break;
            
        case kHXSShopTypeFruit:
        {
            titleStr = @"水果店";
        }
            break;
        default:
            break;
    }
    
    return self.shopTypeNameStr.length > 0 ? self.shopTypeNameStr : titleStr;
}

- (void)initPromptView
{
    _topImageViewConstraint.constant = 75 * SCREEN_HEIGHT / 750;//750为ip6手机高度
    
    _bottomButtonTopConstraint.constant = 126 * SCREEN_HEIGHT / 750;//750为ip6手机高度
}


#pragma mark - Target Methods

- (IBAction)onClickOpenStoreBtn:(id)sender
{
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    NSString *baseURL = [[ApplicationSettings instance] registerStoreManagerBaseURL];
    NSString *url = [NSString stringWithFormat:@"%@?dormentry_id=%d", baseURL, [locationMgr.buildingEntry.dormentryIDNum intValue]];
    
    HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
    webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    RootViewController *tabRootCtrl = [AppDelegate sharedDelegate].rootViewController;
    UINavigationController *nav = tabRootCtrl.currentNavigationController;
    
    [nav pushViewController:webVc animated:YES];
}

- (void)onClickCellAtIndexPath:(NSIndexPath *)indexPath
{
    HXSShopEntity *entity = [self.shopsDataSource objectAtIndex:indexPath.section];
    entity.hasExtended = !entity.hasExtended;
    
    [self.shopTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Fetch Shop List

- (void)fetchShopList
{
    __weak typeof(self) weakSelf = self;
    
    HXSLocationManager *manager = [HXSLocationManager manager];
    
    [self.shopModel fetchShopListWithSiteId:manager.currentSite.site_id
                                  dormentry:manager.buildingEntry.dormentryIDNum
                                       type:self.typeIntNum
                              crossBuilding:@(1)
                                   complete:^(HXSErrorCode status, NSString *message, NSArray *shopsArr) {
                                       [HXSLoadingView closeInView:weakSelf.view];
                                       [weakSelf.shopTableView endRefreshing];
                                       
                                       if (kHXSNoError != status) {
                                           if (weakSelf.isFirstLoading) {
                                               [HXSLoadingView showLoadFailInView:weakSelf.view
                                                                            block:^{
                                                                                [weakSelf fetchShopList];
                                                                            }];
                                           } else {
                                               [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                  status:message
                                                                              afterDelay:1.5f];
                                           }

                                           return ;
                                       }
                                       
                                       weakSelf.firstLoading = NO;
                                       
                                       if (0 >= [shopsArr count]) {
                                           [self.view bringSubviewToFront:_promptView];
                                       } else {
                                           [self.view sendSubviewToBack:_promptView];
                                           
                                           weakSelf.shopsDataSource = shopsArr;
                                           
                                           [weakSelf.shopTableView reloadData];
                                       }
                                   }
     ];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.shopsDataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3; // 1 店铺信息 2 公告  3 优惠
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Shop List
    HXSShopEntity *entity = [self.shopsDataSource objectAtIndex:indexPath.section];
    
    switch (indexPath.row) {
        case 0:
            return kHeightShopNameCell; // fixed height
            break;
            
        case 1:
            if (0 < [entity.promotionsArr count]) {
                CGFloat lineHeight = [entity.promotionsArr count] * kHeightShopActivityLine;
                
                return lineHeight;
            } else{
                
                return 0.1;
            }
            
            break;
            
        case 2:
            if (entity.hasExtended) {
                int padding = 113;
                CGFloat noticeLabelHeight = [entity.noticeStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - padding, CGFLOAT_MAX)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}
                                                                           context:nil].size.height + 26; // 26 is padding
                
                NSInteger countOfBr = [entity.noticeStr numberOfNewLine];
                
                if (0 < countOfBr) {
                    noticeLabelHeight += countOfBr * 14; // 14 is height of one line
                }
                
                return (kHeightShopNoticeCell < noticeLabelHeight) ? noticeLabelHeight: kHeightShopNoticeCell;
            } else {
                return kHeightShopNoticeCell;
            }
            
            break;
            
        default:
            break;
    }
    
    return 125;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.1f;
    }
    
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:ShopNameTableViewCellIdentifier forIndexPath:indexPath];
            break;
            
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:ShopActivityTableViewCellIdentifier forIndexPath:indexPath];
            break;
            
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:ShopNoticeTableViewCellIdentifier forIndexPath:indexPath];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Shop list
    HXSShopEntity *entity = [self.shopsDataSource objectAtIndex:indexPath.section];
    
    switch (indexPath.row) {
        case 0:
        {
            HXSShopNameTableViewCell *nameCell = (HXSShopNameTableViewCell *)cell;
            
            [nameCell setupCellWithEntity:entity];
            
            [nameCell.shopTypeImageView setHidden:YES];
        }
            
            break;
            
        case 1:
        {
            HXSShopActivityTableViewCell *activityCell = (HXSShopActivityTableViewCell *)cell;
            
            [activityCell setupCellWithEntity:entity];
        }
            
            break;
            
        case 2:
        {
            HXSShopNoticeTableViewCell *noticeCell = (HXSShopNoticeTableViewCell *)cell;
            
            [noticeCell setupCellWithEntity:entity];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (2 == indexPath.row) { // 公告栏
        [self onClickCellAtIndexPath:indexPath];
        
        return;
    }
    
    HXSShopEntity *entity = [self.shopsDataSource objectAtIndex:indexPath.section];
    
    [self saveShopEntityToCurrentEntry:entity]; // save entity
    
    switch ([entity.shopTypeIntNum integerValue]) {
        case kHXSShopTypeDorm:
        {
            HXSDormMainViewController *mainVC = [HXSDormMainViewController createDromVCWithShopId:entity.shopIDIntNum];
            
            [self.navigationController pushViewController:mainVC animated:YES];
        }
            break;
            
        case kHXSShopTypeDrink:
        {
            // Do nothing
        }
            break;
            
        case kHXSShopTypePrint:
        {
            if(_printReturnBlock) {
                [self dismissViewControllerAnimated:YES completion:nil];
                _printReturnBlock(entity);
            } else {
                HXSPrintMainViewController *printVC = [HXSPrintMainViewController createPrintVCWithShopId:entity.shopIDIntNum];
                
                [self.navigationController pushViewController:printVC animated:YES];
                
            }
        }
            break;
            
        case kHXSShopTypeStore: // 云超市(便利店)
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

#pragma mark - Save Shop Entity

- (void)saveShopEntityToCurrentEntry:(HXSShopEntity *)shopEntity
{
    HXSShopManager *manager = [HXSShopManager shareManager];
    HXSDormEntry *dormEntry = [[HXSDormEntry alloc] init];
    dormEntry.shopEntity = shopEntity;
    
    [manager setCurrentEntry:dormEntry];
}


#pragma mark - Setter Getter Methods

- (HXSShopViewModel *)shopModel
{
    if (nil == _shopModel) {
        _shopModel = [[HXSShopViewModel alloc] init];
    }
    
    return _shopModel;
}

- (UIButton *)footerViewOpenStoreBtn
{
    if (nil == _footerViewOpenStoreBtn) {
        UIButton *button = [[UIButton alloc] init];
        [button setFrame:CGRectMake(15, 20, SCREEN_WIDTH - 30, 40)];
        [button setTitle:@"申请做店长" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRGBHex:0x07A9FA] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [button addTarget:self
                   action:@selector(onClickOpenStoreBtn:)
         forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [UIColor colorWithRGBHex:0x07A9FA].CGColor;
        button.layer.borderWidth = 1.0f;
        button.layer.cornerRadius = 4.0f;
        
        
        _footerViewOpenStoreBtn = button;
    }
    
    return _footerViewOpenStoreBtn;
}

@end

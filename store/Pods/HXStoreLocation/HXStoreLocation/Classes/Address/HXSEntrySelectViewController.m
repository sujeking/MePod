//
//  HXSEntrySelectViewController.m
//  store
//
//  Created by chsasaw on 15/2/3.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSEntrySelectViewController.h"

// Controllers
#import "HXSBuildingSelectViewController.h"

// Model
#import "HXSSite.h"
#import "HXSCity.h"
#import "HXSDormEntry.h"
#import "HXSBuildingEntry.h"
#import "HXSDormViewModel.h"

// Views
#import "HXSLoadingView.h"
#import "HXSEmptyTableBackgroundView.h"
#import "HXSAddressDecorationView.h"
#import "HXSEntryTableViewCell.h"

// Others
#import "HXStoreLocation.h"
#import "UIScrollView+HXSPullRefresh.h"
#import "UIView+Extension.h"
#import "HXMacrosUtils.h"
#import "HXSMediator+AccountModule.h"
#import "UIImageView+WebCache.h"
#import "HXMacrosEnum.h"
#import "HXSLocationManager.h"
#import "ApplicationSettings.h"
#import "HXSMediator+HXWebviewModule.h"
#import "MBProgressHUD+HXS.h"
#import "HXSUsageManager.h"


#define HEIGHT_FOOTER_VIEW    100
#define PADDING               16
#define HEIGHT_HEADER_VIEW    44

static NSString *EntryTableViewCell           = @"HXSEntryTableViewCell";
static NSString *EntryTableViewCellIdentifier = @"HXSEntryTableViewCell";

@interface HXSEntrySelectViewController ()<UITableViewDataSource,
                                           UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, strong) NSArray *shopsMArr;

@property (nonatomic) BOOL loading;
@property (nonatomic, assign) BOOL firstLoad;

@property (nonatomic, strong) HXSDormEntry *selectedDormEntity;
@property (nonatomic, strong) UIView *emptyShopBackGroundView;

@end

@implementation HXSEntrySelectViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        self.loading = NO;
    }
    
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.loading = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initialNav];
    [self initialPrama];
    [self initialTableView];
    
    self.loading = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([HXSLocationManager manager].buildingEntry == nil ||[HXSLocationManager manager].buildingEntry.dormentryIDNum.intValue < 0) {
        [self.titleButton setTitle:@"" forState:UIControlStateNormal];
    } else {
        NSString *str = [NSString stringWithFormat:@" %@%@%@",[HXSLocationManager manager].currentSite.name,[HXSLocationManager manager].currentBuildingArea.name,[HXSLocationManager manager].buildingEntry.buildingNameStr ];
        [self.titleButton setTitle:str forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!self.firstLoad) {
        self.firstLoad = YES;
        if([HXSLocationManager manager].buildingEntry == nil ||[HXSLocationManager manager].buildingEntry.dormentryIDNum.intValue < 0) {
            WS(weakSelf);
            [[HXSLocationManager manager] resetPosition:PositionBuilding completion:^{
                self.building = [HXSLocationManager manager].buildingEntry;
                [weakSelf tokenRefreshed];
            }];
    
        } else {
            self.building = [HXSLocationManager manager].buildingEntry;
            [self tokenRefreshed];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.selectedDormEntity = nil;
    self.completionBlock    = nil;
}


#pragma mark - Initial Methods

- (void)initialTableView
{
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf refresh];
    }];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreLocation" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:EntryTableViewCell bundle:bundle] forCellReuseIdentifier:EntryTableViewCellIdentifier];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsZero;

}

- (void) initialNav
{
    self.navigationItem.title = @"选择店长";
}

- (void)initialPrama
{
    self.titleButtonView.layer.borderColor = HXS_COLOR_SEPARATION_STRONG.CGColor;
    self.titleButtonView.layer.borderWidth = 1;
}


#pragma mark - Setter Getter Methods

- (UIView *)emptyShopBackGroundView
{
    if (nil == _emptyShopBackGroundView) {
        _emptyShopBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height)];
        [_emptyShopBackGroundView setBackgroundColor:[UIColor whiteColor]];
        
        // apply dorm manager
        CGFloat heightOfBtn = 44;
        UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [applyBtn setFrame:CGRectMake(0, self.tableView.height - heightOfBtn, self.tableView.width, heightOfBtn)];
        [applyBtn setBackgroundColor:UIColorFromRGB(0xDAF5FF)];
        [applyBtn setTitle:@"申请做店长" forState:UIControlStateNormal];
        [applyBtn setTitleColor:UIColorFromRGB(0x32B0FB) forState:UIControlStateNormal];
        [applyBtn addTarget:self
                     action:@selector(onClickApplyBtn:)
           forControlEvents:UIControlEventTouchUpInside];
        
        [_emptyShopBackGroundView addSubview:applyBtn];
        
    }
    
    return _emptyShopBackGroundView;
}


#pragma mark - Target Methods

- (void)tokenRefreshed
{
    [HXSLoadingView showLoadingInView:self.view];
    
    [self refresh];
}

- (void)loadEntryShopList:(NSArray *)shopListArr
{    
    self.shopsMArr = shopListArr;
    
    [self.tableView reloadData];
    
    if (0 >= [self.shopsMArr count]) {
        self.tableView.tableFooterView.hidden = YES;
        
        self.tableView.backgroundView = self.emptyShopBackGroundView;
        self.emptyShopBackGroundView.hidden = NO;
    } else {
        self.tableView.tableFooterView.hidden = NO;
        
        self.emptyShopBackGroundView.hidden = YES;
    }
}

- (void)refresh
{
    NSString * token = [[HXSMediator sharedInstance] HXSMediator_token];
    if(token) {
        if(!self.loading) {
            self.loading = YES;
            __weak typeof(self) weakSelf = self;
            
            HXSLocationManager *locationManager = [HXSLocationManager manager];
            /*
             4表示能够经营盒子的店长
             */
            [HXSDormViewModel fetchDormListWithDormentryId:self.building.dormentryIDNum role:@(4) complete:^(HXSErrorCode code, NSString *message, NSArray *dormList) {
                [weakSelf.tableView endRefreshing];
                [HXSLoadingView closeInView:weakSelf.view];
                
                if(code == kHXSNoError && dormList != nil) {
                    weakSelf.firstLoading = NO;
                    
                    BEGIN_MAIN_THREAD
                    [weakSelf loadEntryShopList:dormList];
                    END_MAIN_THREAD
                } else {
                    if (weakSelf.isFirstLoading) {
                        [HXSLoadingView showLoadFailInView:weakSelf.view
                                                     block:^{
                                                         [weakSelf refresh];
                                                     }];
                    } else {
                        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                           status:message
                                                       afterDelay:1.5f];
                    }
                }
                
                weakSelf.loading = NO;
            }];
        }
    } else {
        [[HXSMediator sharedInstance] HXSMediator_updateToken];
    }
}

- (void)onClickApplyBtn:(UIButton *)button
{
    NSString *baseURL = [[ApplicationSettings instance] registerStoreManagerBaseURL];
    NSString *url = [NSString stringWithFormat:@"%@?dormentry_id=%d", baseURL, [self.building.dormentryIDNum intValue]];
    NSString *percentUrlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    UIViewController *webviewVC = [[HXSMediator sharedInstance] HXSMediator_webviewViewController:@{@"url":percentUrlStr}];
    
    [self.navigationController pushViewController:webviewVC animated:YES];
}

- (IBAction)titleButtonClicked:(id)sender{
    WS(weakSelf);
    [[HXSLocationManager manager] resetPosition:PositionBuilding completion:^{
        self.building = [HXSLocationManager manager].buildingEntry;
        [weakSelf tokenRefreshed];
    }];
}


#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.shopsMArr != nil) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.shopsMArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.shopsMArr.count > 0)
        return 0.1;
    return HEIGHT_HEADER_VIEW;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.shopsMArr.count > 0)
        return nil;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, HEIGHT_HEADER_VIEW)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, HEIGHT_HEADER_VIEW)];
    
    label.textColor = UIColorFromRGB(0x999999);
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"您所在的楼栋还没有店长呢，暂时无法申请零食盒";
    label.adjustsFontSizeToFitWidth = YES;
    
    [headerView addSubview:label];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSEntryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:EntryTableViewCellIdentifier forIndexPath:indexPath];
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSEntryTableViewCell *entryCell = (HXSEntryTableViewCell *)cell;
    HXSDormNegoziante *entity = [self.shopsMArr objectAtIndex:indexPath.row];
    
    // shop image
    [entryCell.shopImageView sd_setImageWithURL:[NSURL URLWithString:entity.portraitStr]
                          placeholderImage:[UIImage imageNamed:@"ic_shop_logo"]];
    entryCell.shopImageView.layer.cornerRadius = 30;
    entryCell.shopImageView.layer.masksToBounds = YES;
    // name
    entryCell.shopNameLabel.text = entity.dormNameStr;
    
    // address
    entryCell.shopAddressLabel.text = [NSString stringWithFormat:@"%d层",entity.floorNum.intValue];
    
    // sku amount
    entryCell.shopSKUAmountLabel.text = [NSString stringWithFormat:@"共%ld种商品", (long)[entity.itemNum intValue]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [HXSUsageManager trackEvent:HXS_ADDRESS_SELECT_DORM parameter:nil];
    HXSDormNegoziante *dormNegoziante = [self.shopsMArr objectAtIndex:indexPath.row];
    
    [[HXSLocationManager manager] setCurrentDorm:dormNegoziante];
    if(self.completionBlock)
        self.completionBlock();
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = HEIGHT_HEADER_VIEW;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark - public method

- (void)updateAddressList
{
    [HXSLoadingView closeInView:self.view];
    [self refresh];
}

@end

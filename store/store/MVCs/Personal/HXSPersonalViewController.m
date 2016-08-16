//
//  HXSPersonalViewController.m
//  store
//
//  Created by chsasaw on 14-10-14.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSPersonalViewController.h"
#import "HXSPersonal.h"

// Controllers
#import "HXSSettingsViewController.h"
#import "HXSCouponViewController.h"
#import "HXSMyOrdersViewController.h"
#import "HXSMyCommissionViewController.h"
#import "HXSRobTaskViewController.h"
#import "HXSMyFilesPrintViewController.h"
#import "HXSCreditWalletViewController.h"
#import "HXSMessageCenterViewController.h"
#import "HXSLoginViewController.h"
#import "HXSBoxViewController.h"
#import "HXSShopViewController.h"
#import "HXSWebViewController.h"
#import "HXSRecommendViewController.h"
#import "HXSComplaintViewController.h"

// Views
#import "UIBarButtonItem+HXSRedPoint.h"
#import "HXSPersonalCenterHeaderView.h"
#import "HXSPersonalMenuButton.h"
#import "HXSegmentControl.h"
#import "UINavigationBar+AlphaTransition.h"
#import "UIBarButtonItem+HXSRedPoint.h"

// Models
#import "HXSUserAccountModel.h"
#import "HXSShopManager.h"
#import "HXSWXApiManager.h"

static const CGFloat knavbarChangePoint       = 20.0f;
static const CGFloat knavbarTransparentHeight = 40.0f;

// section separated by new line
typedef NS_ENUM(NSInteger, AccountInfoType) {
    AccountMyOrder = 0,
    AccountMyBill,
    AccountMyBox,
    
    AccountSesameCredit,
    
    AccountShare,
    AccountFeedback,
    AccountAppRecommend,
    
    AccountSettings,
    
    AccountRobTask,
    AccountOpenShop,
    AccountMyFile
    
};

// ================================================================================

@interface HXSPersonalIndentationCell : UITableViewCell

@end

@implementation HXSPersonalIndentationCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.imageView.frame;
    rect.origin.x = 15;
    self.imageView.frame = rect;
    
    rect = self.textLabel.frame;
    rect.origin.x = self.imageView.right + 13.0;
    self.textLabel.frame = rect;
}

@end

// ================================================================================


#define TAG_NAVIGATION_TIEM_BUTTON           10000


@interface HXSPersonalViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) HXSPersonalCenterHeaderView * headView;

@property (nonatomic, weak) IBOutlet UITableView * tableView;

@end

@implementation HXSPersonalViewController


#pragma mark - UIViewController Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        self.title = @"我的";
        self.navigationItem.title = @"我的";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.separatorColor = [UIColor colorWithRGBHex:0xE1E2E3];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.navigationItem.leftBarButtonItem = nil;
    
    [self initNavigationBarButtonItems];
    
    self.view.layer.masksToBounds = NO;
    self.view.clipsToBounds = NO;
    [self initialTableViewHeaderView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePersonalCenterView:) name:kLoginCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePersonalCenterView:) name:kLogoutCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUnreadMessageNumber)
                                                 name:kUnreadMessagehasUpdated
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(knightHaveNewTask:) name:KnightHaveNewTask object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reload];
    // update head view
    [self.headView refreshInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (0 == self.tableView.contentOffset.y) { // Just at the top
        [self.navigationController.navigationBar at_setBackgroundColor:[UIColor clearColor]];
    }
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xF5F6FB];
    
    // 点击积分/优惠券按钮的时候同时按住一个Cell,之前的[tableView deselectRowAtIndexPath:indexPath animated:NO];没起作用
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tableView endRefreshing];
    [self.navigationController.navigationBar at_reset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Initial Methods

- (void)initNavigationBarButtonItems
{
    // Add right bar button
    UIImage *messageImage = [UIImage imageNamed:@"message"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, messageImage.size.width, messageImage.size.height)];
    [rightBtn setImage:messageImage forState:UIControlStateNormal];
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBtn addTarget:self
                 action:@selector(clickMessageBtn:)
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTag:TAG_NAVIGATION_TIEM_BUTTON];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    NSNumber *unreadMessageNum = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_UNREAD_MESSGE_NUMBER];
    NSString *unreadMessageStr = [NSString stringWithFormat:@"%@", unreadMessageNum ? unreadMessageNum : @0];
    
    rightBarButton.redPointBadgeValue     = unreadMessageStr;
    
    // Right two buttons
    UIBarButtonItem *messageItem = rightBarButton;
    
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [settingBtn setImage:[UIImage imageNamed:@"ic_personal_setting"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
    if (messageItem != nil) {
        UIBarButtonItem* fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpaceItem.width = 20;
        
        self.navigationItem.rightBarButtonItems = @[messageItem,fixedSpaceItem, settingItem];
    }
    else {
        self.navigationItem.rightBarButtonItems = @[settingItem];
    }
}

- (void)settingButtonPressed:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventPersonalSetting parameter:nil];
    
    HXSSettingsViewController *controller = [[HXSSettingsViewController alloc] initWithNibName:@"HXSSettingsViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initialTableViewHeaderView
{
    __weak typeof (self) weakSelf = self;
    
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf reload];
    }];
    
    _headView = [HXSPersonalCenterHeaderView headerView];
    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 234);
    self.tableView.tableHeaderView = _headView;
    
    _headView.backgroundColor = [UIColor colorWithRGBHex:0x68B7FC];
    self.view.backgroundColor = [UIColor colorWithRGBHex:0x68B7FC];
    _tableView.backgroundColor = [UIColor colorWithRGBHex:0xF5F6FB];
    
    [self.headView.centsBtn addTarget:self
                               action:@selector(onClickCentsBtn:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.headView.couponsBtn addTarget:self
                                 action:@selector(onClickCouponsBtn:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.headView.creditBtn addTarget:self
                                action:@selector(onClickCreditBtn:)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.headView.personInfoBtn addTarget:self
                                    action:@selector(onClickPersonInfoBtn:)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.headView.commissionBtn addTarget:self
                                    action:@selector(onClickCommissionBtn:)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.headView.signButton addTarget:self
                                 action:@selector(signButtonClicked:)
                       forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Target Methods

- (void)updatePersonalCenterView:(NSNotification *)noti
{
    if(self.headView) {
        [self.headView refreshInfo];
    }
    
    [self.tableView reloadData];
}

- (void)knightHaveNewTask:(NSNotification *)noti{
    
    [self reload];
    
}

- (IBAction)onClickSettingsButton:(id)sender {
    HXSSettingsViewController * controller = [[HXSSettingsViewController alloc] initWithNibName:@"HXSSettingsViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickCentsBtn:(HXSPersonalMenuButton *)button
{
    [HXSUsageManager trackEvent:kUsageEventPersonalMyPoint parameter:nil];
    
    [HXSLoginViewController showLoginController:self loginCompletion:^{
        HXSWebViewController *webViewController = [HXSWebViewController controllerFromXib];
        NSString *url = [[ApplicationSettings instance] creditCentsURL];
        [webViewController setUrl:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        webViewController.title = @"积分商城";
        [self.navigationController pushViewController:webViewController animated:YES];
    }];
}

- (void)onClickCouponsBtn:(HXSPersonalMenuButton *)button
{
    [HXSUsageManager trackEvent:kUsageEventPersonalMyCoupon parameter:nil];
    
    if ([[AppDelegate sharedDelegate].rootViewController checkIsLoggedin]) {
        HXSCouponViewController * couponViewController = [HXSCouponViewController controllerFromXib];
        couponViewController.isFromPersonalCenter = YES;
        couponViewController.couponScope = kHXSCouponScopeNone;
        [self.navigationController pushViewController:couponViewController animated:YES];
    }
}

- (void)onClickCreditBtn:(HXSPersonalMenuButton *)button
{
    [HXSUsageManager trackEvent:kUsageEventPersonalCreditPurse parameter:nil];
    
    if ([[AppDelegate sharedDelegate].rootViewController checkIsLoggedin]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
        HXSCreditWalletViewController *creditWalletVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSCreditWalletViewController"];
        
        [self.navigationController pushViewController:creditWalletVC animated:YES];
    }
}

- (void)onClickPersonInfoBtn:(HXSPersonalMenuButton *)button
{
    [HXSUsageManager trackEvent:kUsageEventPersonalClickPortrait parameter:nil];
    
    if (![HXSUserAccount currentAccount].isLogin) {
        [[AppDelegate sharedDelegate].rootViewController checkIsLoggedin];
    } else {
        [self pushPersonalInfoVC];
    }
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

// 点击我的佣金
- (void)onClickCommissionBtn:(UIButton *)button{
    
    __weak typeof(self) weakSelf = self;
    if (![HXSUserAccount currentAccount].isLogin){
        
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            [weakSelf pushCommissionVC];
        }];
        
    }else{
        [weakSelf pushCommissionVC];
    }
}


- (void)signButtonClicked:(UIButton *)sender{
    if (![HXSUserAccount currentAccount].isLogin){
        
        [HXSLoginViewController showLoginController:self loginCompletion:nil];
        
    }else{
        
        [MBProgressHUD showInView:self.view];
        __weak typeof(self) weakSelf = self;
        [HXSUserAccountModel userSignIn:^(HXSErrorCode code, NSString *message, NSDictionary *info) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(kHXSNoError == code){
                UIImageView *imageView  =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_collarintegral"]];
                HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;

                [MBProgressHUD showInView:weakSelf.view customView:imageView status:[NSString stringWithFormat:@"签到成功\n恭喜获得%d积分",basicInfo.signInCreditIntNum.intValue] afterDelay:1.5];
                
                [weakSelf reload];
                }
            else{
                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
            }
            
        }];
    }
}

#pragma mark - private method

- (void)setupNavigationBar
{
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)reload
{
    // If didn't login, don't refresh
    if (![HXSUserAccount currentAccount].isLogin) {
        [self.tableView endRefreshing];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInfo)
                                                 name:kUserInfoUpdated
                                               object:nil];
    
    // update user info in basic info class.
    [[[HXSUserAccount currentAccount] userInfo] updateUserInfo];
    
}

- (void)updateUserInfo
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kUserInfoUpdated
                                                  object:nil];
    
    [self.tableView endRefreshing];
    
    [self.headView refreshInfo];
}

#pragma mark - Notification Methods

- (void)updateUnreadMessageNumber
{
    NSNumber *unreadMessageNum = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_UNREAD_MESSGE_NUMBER];
    
    if ((nil != unreadMessageNum)
        && [unreadMessageNum isKindOfClass:[NSNumber class]]) {
        if ([self.navigationItem.rightBarButtonItem.customView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
            if (TAG_NAVIGATION_TIEM_BUTTON == button.tag) {
                self.navigationItem.rightBarButtonItem.redPointBadgeValue = [NSString stringWithFormat:@"%@", unreadMessageNum];
            }
        }
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1) {
        return 4;
    }
    else if(section == 2) {
        return 1;
    }
    else if (section == 3) {
        if([HXSWXApiManager sharedManager].isWechatInstalled)
            return 3;
        else
            return 2;
    }
    else if(section == 4) {
            return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier     =  @"HXSPersonalCell";
    static NSString *ShareIdentifier    =  @"ShareIdentifier";
    static NSString *RobTaskIdentifier  =  @"RobTaskIdentifier";
    
    AccountInfoType cellType = [self infoTypeForIndexPath:indexPath];
    UITableViewCell *cell;

    if (cellType == AccountShare) {
        cell = [tableView dequeueReusableCellWithIdentifier:ShareIdentifier];
        
        if(cell == nil) {
            cell = [[HXSPersonalIndentationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ShareIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if(cellType == AccountRobTask){
        cell = [tableView dequeueReusableCellWithIdentifier:RobTaskIdentifier];
        
        if(cell == nil) {
            cell = [[HXSPersonalIndentationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RobTaskIdentifier];
            
        }
        
        /*
         登录：
         非骑士，右边无标签无文字
         是骑士，有单显示有待抢订单的文字提示，无单右边无标签无文字
         未登录：
         右边无标签无文字
         */
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.hidden = NO;
        
        if (![HXSUserAccount currentAccount].isLogin){
            cell.detailTextLabel.text = @"";
        }else{
            HXSUserKnightInfo *knightInfo = [HXSUserAccount currentAccount].userInfo.knightInfo;
            
            if(kHXPersonIfKnightStatusNo == knightInfo.statusIntNum.intValue){ // 非骑士
                cell.detailTextLabel.text = @"";
            }else if(kHXPersonIfKnightStatusYes == knightInfo.statusIntNum.intValue){ // 骑士
                if(knightInfo.knightNewTaskIntNum.intValue > 0){
                    cell.detailTextLabel.text = @"有任务可抢";
                    cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0xf54642];
                    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
                }else{
                    cell.detailTextLabel.hidden = YES;
                }
            }else { // 被锁定 退出 和 未知
                cell.detailTextLabel.hidden = YES;
            }
        }
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil) {
            cell = [[HXSPersonalIndentationCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    
    if (cellType == AccountMyBill) {
        if (0 < [creditCardInfo.recentBillAmountDoubleNum doubleValue]) {
            NSString *recentBillAmountStr = [NSString stringWithFormat:@"¥%@", creditCardInfo.recentBillAmountDoubleNum];
            NSString *foreBodyStr = @"近期有";
            NSString *wholeStr = [NSString stringWithFormat:@"%@%@待还", foreBodyStr, recentBillAmountStr];
            NSMutableAttributedString *AttributeMStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
            [AttributeMStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:0xF9A502] range:NSMakeRange(foreBodyStr.length, recentBillAmountStr.length)];
            cell.detailTextLabel.attributedText = AttributeMStr;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        } else {
            cell.detailTextLabel.text = nil;
        }
    }
    
    cell.textLabel.text = [self titleForAccountInfoType:cellType];
    cell.imageView.image = [UIImage imageNamed:[self imageForAccountInfoType:cellType]];
    cell.textLabel.textColor = [UIColor colorWithRGBHex:0x666666];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AccountInfoType cellType = [self infoTypeForIndexPath:indexPath];
    
    switch (cellType) {
        case AccountMyOrder:
        {
            [HXSUsageManager trackEvent:kUsageEventPersonalMyOrder parameter:nil];
            
            [HXSLoginViewController showLoginController:self loginCompletion:^{
                HXSMyOrdersViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HXSMyOrdersViewController"];
                controller.isFromPersonalCenter = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }];

            break;
        }

        case AccountSettings:
        {
            [HXSUsageManager trackEvent:kUsageEventPersonalSetting parameter:nil];
            
            HXSSettingsViewController *controller = [[HXSSettingsViewController alloc] initWithNibName:@"HXSSettingsViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case AccountFeedback:
        {
            HXSComplaintViewController *feedbackVC = [[HXSComplaintViewController alloc] initWithNibName:@"HXSComplaintViewController" bundle:nil];
            
            [self.navigationController pushViewController:feedbackVC animated:YES];
            
            break;
        }
        case AccountShare:
        {
            [HXSUsageManager trackEvent:kUsageEventPersonalInviteFriends parameter:nil];
            
            HXSWebViewController *webViewController = [HXSWebViewController controllerFromXib];
            [webViewController setUrl:[NSURL URLWithString:[ApplicationSettings instance].currentInvitationURL]];
            webViewController.title = @"邀请好友";
            [self.navigationController pushViewController:webViewController animated:YES];
            
            break;
        }
        case AccountAppRecommend:
        {
            [HXSUsageManager trackEvent:kUsageEventPersonalRecommendApp parameter:nil];
            
            HXSRecommendViewController *recommendViewController = [HXSRecommendViewController controllerFromXibWithModuleName:@"HXStoreLocation"];
            [self.navigationController pushViewController:recommendViewController animated:YES];
            break;
        }
        case AccountSesameCredit:
        {
            [HXSUsageManager trackEvent:kUsageEventPersonalCreditSesame parameter:nil];
            WS(weakSelf);
            if ([[AppDelegate sharedDelegate].rootViewController checkIsLoggedin]) {
                HXSWebViewController * controller = [HXSWebViewController controllerFromXib];
                [controller setUrl:[NSURL URLWithString:[ApplicationSettings instance].currentZmCreditURL]];
                controller.title = @"芝麻信用";
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
        case AccountMyBox:
        {
            WS(weakSelf);
            [HXSLoginViewController showLoginController:self loginCompletion:^{
                [weakSelf jumpToMyBoxController];
            }];
        }
            break;

        case AccountMyBill:
        {
            [HXSUsageManager trackEvent:kUsageEventWalletMyBill parameter:nil];
            WS(weakSelf);
            [HXSLoginViewController showLoginController:self loginCompletion:^{
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:[NSBundle mainBundle]];
                UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"HXSMyBillViewController"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case AccountRobTask:
        {
            __weak typeof(self) weakSelf = self;
            if (![HXSUserAccount currentAccount].isLogin){
                [HXSLoginViewController showLoginController:self loginCompletion:^{
                    [weakSelf pushTaskVC];
                }];
            }else{
                [weakSelf pushTaskVC];
            }
        }
            break;
        case AccountOpenShop:
        {
            __weak typeof(self) weakSelf = self;
            if (![HXSUserAccount currentAccount].isLogin){
                [HXSLoginViewController showLoginController:self loginCompletion:^{
                    [weakSelf openShop];
                }];
            }else{
                [weakSelf openShop];
            }
        }
            break;
        case AccountMyFile://我的文件
        {
            __weak typeof(self) weakSelf = self;
            if (![HXSUserAccount currentAccount].isLogin){
                [HXSLoginViewController showLoginController:self loginCompletion:^{
                    [weakSelf jumpToMyFilesViewController];
                }];
            }else{
                [weakSelf jumpToMyFilesViewController];
            }
        }
            break;
            
            
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // This Line Fix a Bug
    if (self.navigationController.topViewController != self) {
        return;
    }
    
    [self checkTheScrollViewOffsetAndSetTheNavigationBarWithScrollView:scrollView];
}


#pragma mark - Privater Methods

- (void)checkTheScrollViewOffsetAndSetTheNavigationBarWithScrollView:(UIScrollView *)scrollView
{
    UIColor * color = HXS_MAIN_COLOR;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > knavbarChangePoint) {
        CGFloat alpha = MIN(1, 1 - ((knavbarChangePoint + 64 - offsetY) / 64));
        [self.navigationController.navigationBar at_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar at_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
    
    if (scrollView.contentOffset.y < 0) {
        if (scrollView.contentOffset.y < -knavbarTransparentHeight) {
            [self.navigationController.navigationBar at_setElementsAlpha:0];
        }
        else {
            CGFloat alpha = -scrollView.contentOffset.y/knavbarTransparentHeight;
            [self.navigationController.navigationBar at_setElementsAlpha:1 - alpha];
        }
    }
    else {
        [self.navigationController.navigationBar at_setElementsAlpha:1];
    }
}

#pragma mark - Go to my box

- (void)jumpToMyBoxController
{
    HXSBoxViewController *boxVC = [HXSBoxViewController controllerFromXib];
    
    [self.navigationController pushViewController:boxVC animated:YES];
}


- (void)updateMyBoxInfoToLocationInfo
{
    HXSLocationManager *boxLoMgr = [HXSLocationManager manager];
    HXSUserMyBoxInfo *myBoxInfo  = [HXSUserAccount currentAccount].userInfo.myBoxInfo;
    
    boxLoMgr.currentCity     = myBoxInfo.cityEntry;
    boxLoMgr.currentSite     = myBoxInfo.siteEntry;
    boxLoMgr.buildingEntry   = myBoxInfo.buildingEntry;
    
    HXSShopManager *shopManager = [HXSShopManager shareManager];
    shopManager.currentEntry    = myBoxInfo.dormEntry;
}

#pragma mark - Push Methods

- (void)pushPersonalInfoVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalInfo" bundle:nil];
    UIViewController *personalInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSPersonalInfoTableViewController"];
    [self.navigationController pushViewController:personalInfoVC animated:YES];
}

- (void)pushTaskVC{
    // 抢任务模块只有在是骑士或者骑士被锁定的状态下课进
    HXSUserKnightInfo *knightInfo = [HXSUserAccount currentAccount].userInfo.knightInfo;
    if(kHXPersonIfKnightStatusNo == knightInfo.statusIntNum.intValue){
        NSString *baseURL = [[ApplicationSettings instance] knightRegisterURL];
        NSString *url = baseURL;
        
        HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
        webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.navigationController pushViewController:webVc animated:YES];
    }else{
        if(kHXPersonIfKnightStatusYes == knightInfo.statusIntNum.intValue||kHXPersonIfKnightStatusLocked == knightInfo.statusIntNum.intValue){
            HXSRobTaskViewController *robTaskViewController = [[HXSRobTaskViewController alloc]initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:robTaskViewController animated:YES];
        }
    }
}

- (void)pushCommissionVC{
    // 佣金模块只有在是骑士或者骑士被锁定的状态下课进
    HXSUserKnightInfo *knightInfo = [HXSUserAccount currentAccount].userInfo.knightInfo;
    if(kHXPersonIfKnightStatusNo == knightInfo.statusIntNum.intValue){
        NSString *baseURL = [[ApplicationSettings instance] knightRegisterURL];
        NSString *url = baseURL;
        
        HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
        webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.navigationController pushViewController:webVc animated:YES];
    }else{
        if(kHXPersonIfKnightStatusYes == knightInfo.statusIntNum.intValue||kHXPersonIfKnightStatusLocked == knightInfo.statusIntNum.intValue){
            HXSMyCommissionViewController *myCommissionViewController = [[HXSMyCommissionViewController alloc]initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:myCommissionViewController animated:YES];
        }
    }
}

- (void)openShop{
    NSString *baseURL = [[ApplicationSettings instance] registerStoreManagerBaseURL];
    NSString *url = [NSString stringWithFormat:@"%@?site_id=%d", baseURL, [[HXSLocationManager manager].currentSite.site_id intValue]];
    
    HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
    webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)jumpToMyFilesViewController
{
    HXSMyFilesPrintViewController *myFilesPrintVC = [HXSMyFilesPrintViewController createFilesPrintVCWithEntity:nil];
    
    [self.navigationController pushViewController:myFilesPrintVC animated:YES];
}


#pragma mark - Get Set Methods

- (AccountInfoType)infoTypeForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:     return AccountMyOrder;
            case 1:     return AccountMyBill;
            case 2:     return AccountMyFile;
            case 3:     return AccountMyBox;
        }
    }
    else if (indexPath.section == 2 ) {
        return AccountSesameCredit;
    }
    else if (indexPath.section == 3) {
        if([HXSWXApiManager sharedManager].isWechatInstalled) {
            switch (indexPath.row) {
                case 0:     return AccountRobTask;
                case 1:     return AccountShare;
                case 2:     return AccountOpenShop;
            }
        } else {
            switch (indexPath.row) {
                case 0:     return AccountRobTask;
                case 1:     return AccountOpenShop;
            }
        }
    }
    else if (indexPath.section == 4) {
        return AccountFeedback;
    }
    
    return AccountMyOrder;
}

- (NSString *)titleForAccountInfoType:(AccountInfoType)type
{
    switch (type) {
        case AccountMyOrder:        return @"我的订单";
        case AccountMyBill:         return @"我的账单";
        case AccountMyFile:         return @"我的文件";
        case AccountMyBox:          return @"我的盒子";
        case AccountSettings:       return @"系统设置";
        case AccountSesameCredit:   return @"芝麻信用";
        case AccountFeedback:       return @"反馈帮助";
        case AccountShare:          return @"邀请好友，立刻赚钱";
        case AccountAppRecommend:   return @"应用推荐";
        case AccountRobTask:        return @"抢任务赚钱";
        case AccountOpenShop:       return @"开店挣钱";
        default:
            return @"";
    }
}

- (NSString *)imageForAccountInfoType:(AccountInfoType)type
{
    switch (type) {
        case AccountMyOrder:        return @"ic_personal_order";
        case AccountMyBill:         return @"ic_personal_bill";
        case AccountMyFile:         return @"ic_woddewenjian";
        case AccountMyBox:          return @"ic_personal_box";
        case AccountSettings:       return @"ic_personal_setting";
        case AccountSesameCredit:   return @"ic_zhima";
        case AccountFeedback:       return @"ic_personal_help";
        case AccountShare:          return @"ic_recommend";
        case AccountAppRecommend:   return @"ic_personal_application";
        case AccountRobTask:        return @"ic_robtask";
        case AccountOpenShop:       return @"ic_openshop";
        default:
            return @"";
    }
}


@end

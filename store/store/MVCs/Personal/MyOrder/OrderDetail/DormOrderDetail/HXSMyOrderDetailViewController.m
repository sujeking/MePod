//
//  HXSMyOrderDetailViewController.m
//  store
//
//  Created by ranliang on 15/4/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSMyOrderDetailViewController.h"
#import "HXSPersonal.h"
// Controller
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"

// Model
#import "HXSAlipayManager.h"
#import "HXSOrderRequest.h"
#import "HXSBaiHuaHuaPayModel.h"
#import "HXSCreditPayManager.h"
#import "HXSBestPayApiManager.h"
#import "HXSWXApiManager.h"

// Views
#import "HXSOrderItemCell.h"
#import "HXSOrderDetailHeaderView.h"
#import "HXSOrderDetailFooterView.h"
#import "HXSOrderDetailSectionHeaderView.h"
#import "HXSOrderDetailTotalAmountCell.h"
#import "HXSPayPasswordAlertView.h"
#import "HXSOrderActivityInfoView.h"
#import "HXSActionSheet.h"

// Common
#import "UDManager.h"
#import "UDAgentNavigationMenu.h"
#import "UINavigationBar+AlphaTransition.h"


@interface HXSMyOrderDetailViewController ()<HXSAlipayDelegate,
                                             UITableViewDelegate,
                                             UITableViewDataSource,
                                             HXSWechatPayDelegate,
                                             HXSBestPayApiManagerDelegate>

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *feedbackButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HXSOrderRequest * request;

@property (nonatomic, strong) HXSOrderDetailHeaderView * tableHeaderView;
@property (nonatomic, strong) HXSOrderDetailFooterView * tableFooterView;
@property (nonatomic, strong) HXSOrderActivityInfoView *activityInfoView;

@property (nonatomic, assign, getter=isFirstFetching) BOOL firstFetching;

@end

@implementation HXSMyOrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initialNavigationBar];
    
    [self initialTableView];
    
    [self initialNewConfigUdesk];
    
    self.firstFetching = YES;
    
    // update order info
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // For fixing the navigation bar disappear after pushing to UDManager
    [self.navigationController.navigationBar at_reset];
    [self.navigationController.navigationBar at_setBackgroundColor:HXS_MAIN_COLOR];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar at_setBackgroundColor:HXS_MAIN_COLOR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    //设置页面标题和返回按钮
    self.navigationItem.title = @"订单详情";
}

- (void)initialTableView
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.backgroundColor = UIColorFromRGB(0xf4f3f2);
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.separatorColor = [UIColor colorWithRGBHex:0xE5E6E7];
    self.tableView.backgroundColor = [UIColor colorWithRGBHex:0xF6F6F7];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HXSOrderDetailHeaderView" bundle:nil] forCellReuseIdentifier:@"HXSOrderDetailHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HXSOrderDetailSectionHeaderView" bundle:nil] forCellReuseIdentifier:@"HXSOrderDetailSectionHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HXSOrderItemCell" bundle:nil] forCellReuseIdentifier:@"HXSOrderItemCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HXSOrderDetailFooterView" bundle:nil] forCellReuseIdentifier:@"HXSOrderDetailFooterView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HXSOrderDetailTotalAmountCell" bundle:nil] forCellReuseIdentifier:@"HXSOrderDetailTotalAmountCell"];
}

- (void)initialNewConfigUdesk
{
    // 构造参数
    HXSUserInfo *userInfo = [HXSUserAccount currentAccount].userInfo;

    NSString *nick_name = userInfo.basicInfo.uName;
    NSString *sdk_token = [[HXSUserAccount currentAccount] strToken];
    NSString *uid = [NSString stringWithFormat:@"%@", userInfo.basicInfo.uid];
    
    //获取用户自定义字段
    [UDManager getCustomerFields:^(id responseObject, NSError *error) {
        
        NSDictionary *customerFieldValueDic = @{};
        for (NSDictionary *dict in responseObject[@"user_fields"]) {
            if ([dict[@"field_label"] isEqualToString:@"用户id"]) {
                NSString *keyStr = dict[@"field_name"];
                
                customerFieldValueDic = @{keyStr: uid};
            }
        }
        
        NSDictionary *userDic = @{
                                  @"sdk_token":              [NSString md5:sdk_token],
                                  @"nick_name":              nick_name,
                                  @"customer_field":         customerFieldValueDic,
                                  };
        
        NSDictionary *parameters = @{@"user":userDic};
        // 创建用户
        [UDManager createCustomerWithCustomerInfo:parameters];
    }];
    
}


#pragma mark - Fetch Data Methods

- (void)refresh
{
    if(self.order) {
        [MBProgressHUD showInView:self.view];
        self.request = [[HXSOrderRequest alloc] init];
        __weak typeof(self) weakSelf = self;
        [self.request getOrderInfoWithToken:[HXSUserAccount currentAccount].strToken orderSn:self.order.order_sn complete:^(HXSErrorCode code, NSString *message, HXSOrderInfo *orderInfo) {
            
            if(code == kHXSNoError && orderInfo) {
                weakSelf.order = orderInfo;
                
                if (weakSelf.isFirstFetching
                    && (kHXSOrderStautsCommitted == orderInfo.status)) {
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                        [weakSelf refresh];
                    });
                    
                    weakSelf.firstFetching = NO;
                    return ;
                }
                
                [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                
                [weakSelf.tableFooterView configWithOrderInfo:weakSelf.order];
                [weakSelf.tableHeaderView configWithOrderInfo:weakSelf.order];
                
                [weakSelf updateBottomButtonStatus];
                
                [weakSelf.tableView reloadData];
                
                [weakSelf showShareInfos];
            } else {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                
                if ((nil == message)
                    || (0 >= [message length])) {
                    message = @"订单不存在";
                }
                
                HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                                                  message:message
                                                                          leftButtonTitle:@"确认"
                                                                        rightButtonTitles:nil];
                
                alertView.leftBtnBlock = ^(){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                };
                
                [alertView show];
            }
        }];
    }
}

- (void)updateBottomButtonStatus
{
    [self.cancelButton removeFromSuperview];
    [self.payButton removeFromSuperview];
    [self.feedbackButton removeFromSuperview];
    
    _bottomConstraint.constant = 0;
    if (_order && (_order.status == 0)) {
        if(_order.paytype != 0 && _order.paystatus == 0) {
            [_bottomContainerView addSubview:self.cancelButton];
            [_bottomContainerView addSubview:self.payButton];
            
            CGFloat width = _bottomContainerView.width/3.0;
            self.payButton.frame = CGRectMake(_bottomContainerView.width - width, 0, width, _bottomContainerView.height);
            
            self.cancelButton.frame = CGRectMake(width, -1, width, _bottomContainerView.height + 2);
            self.cancelButton.layer.borderColor = [UIColor colorWithRGBHex:0xE5E6E7].CGColor;
        }
        else {
            [_bottomContainerView addSubview:self.cancelButton];
            self.cancelButton.frame = _bottomContainerView.bounds;
            self.cancelButton.layer.borderColor = [UIColor clearColor].CGColor;
        }
    } else if (kHXSOrderStautsConfirmed == _order.status) {
        NSDate *date = [NSDate date];
        NSInteger interval = [date timeIntervalSince1970] - [_order.confirm_time integerValue];
        NSInteger thirtyMinute = 30 * 60;
        
        if (thirtyMinute < interval) {
            [_bottomContainerView addSubview:self.cancelButton];
            self.cancelButton.frame = _bottomContainerView.bounds;
            self.cancelButton.layer.borderColor = [UIColor clearColor].CGColor;
        } else {
            _bottomConstraint.constant = -50;
        }
    } else if ((kHXSOrderStautsDone == _order.status)
               || (kHXSOrderStautsCaneled == _order.status)) {
                   [_bottomContainerView addSubview:self.feedbackButton];
                   self.feedbackButton.frame = _bottomContainerView.bounds;
                   self.feedbackButton.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        _bottomConstraint.constant = -50;
    }
}

- (void)showShareInfos
{
    [_activityInfoView showActivityInfos:_order.activityInfos inView:self.view bottomSpace: (_bottomConstraint.constant < 0) ? 0.0 : 45];
}


#pragma mark - Target Methods

- (void)onClickCancel:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventCancelOrder parameter:nil];
    
    __weak HXSMyOrderDetailViewController *weakSelf = self;
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                                      message:@"您确定要取消该订单吗?"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"确定"];
    alertView.rightBtnBlock = ^{
        [MBProgressHUD showInView:weakSelf.view];
        weakSelf.request = [[HXSOrderRequest alloc] init];
        [weakSelf.request cancelOrderWithToken:[HXSUserAccount currentAccount].strToken order_sn:self.order.order_sn compelte:^( HXSErrorCode code, NSString *message, HXSOrderInfo *orderInfo) {
            weakSelf.firstFetching = YES;
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:2.0 andWithCompleteBlock:^{
                [weakSelf refresh];
            }];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
            [[HXSUserAccount currentAccount].userInfo updateUserInfo];
        }];
    };
    [alertView show];
}

- (void)onClickCashPay:(id)sender
{
    __weak typeof(self) weakSelf = self;
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                                      message:@"您确定要将该订单转为货到付款吗?"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"货到付款"];
    alertView.rightBtnBlock = ^{
        [MBProgressHUD showInView:weakSelf.view];
        weakSelf.request = [[HXSOrderRequest alloc] init];
        [weakSelf.request changeOrderPayTypeWithToken:[HXSUserAccount currentAccount].strToken order_sn:self.order.order_sn payType:0 compelte:^(HXSErrorCode code, NSString *message, HXSOrderInfo *orderInfo) {
            weakSelf.firstFetching = YES;
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:2.0 andWithCompleteBlock:^{
                [weakSelf refresh];
            }];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
        }];
    };
    
    [alertView show];
}

- (void)onClickPay:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventPayNow parameter:nil];
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showInView:self.view];
    [HXSActionSheetModel fetchPayMethodsWith:[NSNumber numberWithInt:kHXSOrderTypeDorm]
                                   payAmount:self.order.order_amount
                                 installment:[NSNumber numberWithInteger:0]
                                    complete:^(HXSErrorCode code, NSString *message, NSArray *payArr) {
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        
                                        if (kHXSNoError != code) {
                                            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                               status:message
                                                                           afterDelay:1.5f];
                                            
                                            return ;
                                        }
                                        
                                        [weakSelf displaySelectPayTypeView:payArr];
                                    }];
}

- (void)onClickFeedbackBtn:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    [UDManager getAgentNavigationMenu:^(id responseObject, NSError *error) {
        
        UDAgentNavigationMenu *agentMenuVC = [[UDAgentNavigationMenu alloc] init];
        [weakSelf.navigationController pushViewController:agentMenuVC animated:YES];
        
    }];
}


- (void)displaySelectPayTypeView:(NSArray *)payMethodsArr
{
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:@"请选择支付方式" cancelButtonTitle:@"取消"];
    
    __weak typeof(self) weakSelf = self;
    
    for (int i = 0; i < [payMethodsArr count]; i++) {
        HXSActionSheetEntity *sheetEntity = [payMethodsArr objectAtIndex:i];
        
        switch ([sheetEntity.payTypeIntNum integerValue]) {
            case kHXSOrderPayTypeCash:
            {
                HXSAction *action = [HXSAction actionWithMethods:sheetEntity
                                                         handler:^(HXSAction *action) {
                                                             [weakSelf onClickCashPay:nil];
                                                         }];
                [sheet addAction:action];
            }
                break;
                
            case kHXSOrderPayTypeZhifu:
            {
                HXSAction *payAction = [HXSAction actionWithMethods:sheetEntity
                                                            handler:^(HXSAction *action) {
                                                                [[HXSAlipayManager sharedManager] pay:weakSelf.order delegate:weakSelf];
                                                            }];
                
                [sheet addAction:payAction];
            }
                break;
                
            case kHXSOrderPayTypeWechatApp:
            {
                HXSAction *wechatPayAction = [HXSAction actionWithMethods:sheetEntity
                                                                  handler:^(HXSAction *action) {
                                                                      [[HXSWXApiManager sharedManager] wechatPay:weakSelf.order delegate:weakSelf];
                                                                  }];
                [sheet addAction:wechatPayAction];
            }
                break;
                
            case kHXSOrderPayTypeCreditCard:
            {
                HXSAction *baiHuahuaAction = [HXSAction actionWithMethods:sheetEntity
                                                                  handler:^(HXSAction *action) {
                                                                      [[HXSCreditPayManager instance] checkCreditPay:^(HXSCreditCheckResultType operation) {
                                                                          if (operation == HXSCreditCheckSuccess) {
                                                                              [weakSelf payOrderWith:kHXSOrderPayTypeCreditCard withErrorMessage:nil];
                                                                          }
                                                                      }];
                                                                  }];
                
                [sheet addAction:baiHuahuaAction];
            }
                break;
                
            case kHXSOrderPayTypeAlipayScan:
            {
                // Do nothing
            }
                break;
                
            case kHXSOrderPayTypeBestPay:
            {
                HXSAction *bestPayAction = [HXSAction actionWithMethods:sheetEntity
                                                                handler:^(HXSAction *action) {
                                                                    [[HXSBestPayApiManager sharedManager] bestPayWithOrderInfo:weakSelf.order
                                                                                                                          from:weakSelf
                                                                                                                      delegate:weakSelf];

                                                                }];
                
                [sheet addAction:bestPayAction];
            }
                break;
                

                
            default:
                break;
        }
    }
    
    [sheet show];
}


#pragma mark - Baihuahua Methods

- (void)payOrderWith:(HXSOrderPayType)payType withErrorMessage:(NSString *)errorMessageStr
{
    switch (payType) {
        case kHXSOrderPayTypeCreditCard:
        {
            HXSOrderItem *itemEntity = [[self.order items] firstObject];
            NSString *titleStr                = itemEntity.name;
            
            HXSCreditPayOrderInfo *order = [[HXSCreditPayOrderInfo alloc] init];
            order.tradeTypeIntNum = [NSNumber numberWithInteger:kHXStradeTypeNormal];
            order.orderSnStr = self.order.order_sn;
            order.orderTypeIntNum = [NSNumber numberWithInteger:kHXSOrderTypeDorm];
            order.amountFloatNum = self.order.order_amount;
            order.discountFloatNum = self.order.discount;
            order.orderDescriptionStr = titleStr;
            order.periodsIntNum = [NSNumber numberWithInteger:1];
            
            __weak typeof(self) weakSelf = self;
            [[HXSCreditPayManager instance] payOrder:order completion:^(HXSCreditPayResulType operation, NSString *message, NSDictionary *info) {
                switch (operation) {
                    case HXSCreditPaySuccess:
                    {
                        [weakSelf dealWithBaiHuaHuaResult:YES];
                    }
                        break;
                    case HXSCreditPayCanceled:
                    {
                        [weakSelf dealWithBaiHuaHuaResult:NO];
                    }
                        break;
                    case HXSCreditPayGetPasswdBack:
                    {
                        //[self dealWithBaiHuaHuaResult:NO];
                    }
                        break;
                    case HXSCreditPayFailed:
                    {
                        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                           status:message
                                                       afterDelay:1.5f];
                        [weakSelf dealWithBaiHuaHuaResult:NO];
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)dealWithBaiHuaHuaResult:(BOOL)hasPaid
{
    HXSCustomAlertView *alertView = nil;
    
    if (hasPaid) {
        alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                      message:@"支付成功"
                                              leftButtonTitle:@"确定"
                                            rightButtonTitles:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
        self.firstFetching = YES;
        [self refresh];
        
    } else {
        alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                      message:@"支付失败"
                                              leftButtonTitle:@"确定"
                                            rightButtonTitles:nil];
    }
    
    [alertView show];
}



#pragma mark - pay call back

- (void)payCallBack:(NSString *)status message:(NSString *)message result:(NSDictionary *)result
{    
    NSString *messageStr = nil;
    if(status.intValue == 9000) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
        self.firstFetching = YES;
        [self refresh];
        messageStr = @"支付成功";
    }else if(status.intValue == 6001){
        messageStr = (message && message.length > 0)?message:@"用户取消";
    }else if(status.intValue == 4000) {
        messageStr = @"支付失败";
    }else if (message.length > 0) {
        messageStr = message;
    }
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                                      message:messageStr
                                                              leftButtonTitle:@"确定"
                                                            rightButtonTitles:nil];
    [alertView show];
    
}

#pragma mark - HXSWechatPayDelegate

- (void)wechatPayCallBack:(HXSWechatPayStatus)status message:(NSString *)message result:(NSDictionary *)result
{
    NSString *messageStr = nil;
    
    if (HXSWechatPayStatusSuccess == status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
        self.firstFetching = YES;
        [self refresh];
        messageStr = @"支付成功";
    } else {
        messageStr = @"支付失败";
    }
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                                      message:messageStr
                                                              leftButtonTitle:@"确定"
                                                            rightButtonTitles:nil];
    [alertView show];
}

#pragma mark - HXSBestPayApiManagerDelegate

- (void)bestPayCallBack:(HXSBestPayStatus)status message:(NSString *)message result:(NSDictionary *)result
{
    NSString *messageStr = nil;
    
    if (kHXSBestPayStatusSuccess == status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
        self.firstFetching = YES;
        [self refresh];
        messageStr = @"支付成功";
    } else {
        messageStr = @"支付失败";
    }
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                                      message:messageStr
                                                              leftButtonTitle:@"确定"
                                                            rightButtonTitles:nil];
    [alertView show];
}



#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == ORDERINFO_SECTION_REWARD){
        
        if (self.order.promotion_items.count != 0) {

            return 25;
        }
        
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if(section == ORDERINFO_SECTION_GOODS){
    
        return 0.1;
    }
    
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == ORDERINFO_SECTION_REWARD) {
        
        if(self.order.promotion_items.count != 0){
            
            UIView *rewardTitleView = [[NSBundle mainBundle] loadNibNamed:@"rewardTitleView" owner:nil options:nil][0];
            
            return rewardTitleView;
        }
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == ORDERINFO_SECTION_ADDRESS) {
        
        return [HXSOrderDetailHeaderView heightForOrder:self.order];

    } else if(indexPath.section == ORDERINFO_SECTION_GOODS){
    
        if(indexPath.row == 0) {
        
            return 30;

        } else if (indexPath.row <= self.order.items.count) {

            return 66;
        }
        
        return 40.0;

    } else if(indexPath.section == ORDERINFO_SECTION_REWARD){

        if (indexPath.row + 1 <= self.order.promotion_items.count) {
            
            return 66;
        }
        
        return 40;
        
    } else {
      
        if ((_order.status == 0) && (_order.paytype != 0) && (_order.paystatus == 0)) {

            return 60;
        }
        
        return 84;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == ORDERINFO_SECTION_GOODS) {
        
        return self.order.items.count + 1;
    }
    
    if(section == ORDERINFO_SECTION_REWARD){
        
        return self.order.promotion_items.count + 1;
        
    } else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == ORDERINFO_SECTION_ADDRESS) {
        
        HXSOrderDetailHeaderView * cell = [tableView dequeueReusableCellWithIdentifier:@"HXSOrderDetailHeaderView"];
        
        [cell configWithOrderInfo:self.order];
        
        return cell;
        
    }else if(indexPath.section == ORDERINFO_SECTION_GOODS) {

        if(indexPath.row == 0) {
        
            HXSOrderDetailSectionHeaderView *cell = [tableView dequeueReusableCellWithIdentifier:@"HXSOrderDetailSectionHeaderView"];
            
            [cell setNumberOfItems:[self.order.food_num integerValue]];
            
            cell.separatorInset = UIEdgeInsetsZero;
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            return cell;
            
        } else {//if (indexPath.row <= self.order.items.count ) {
            
            HXSOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXSOrderItemCell"];
            
            [cell configWithOrderItem:self.order.items[indexPath.row - 1]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            if (indexPath.row == self.order.items.count) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
            else {
                cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
            }
            
            return cell;
        }
    } else if(indexPath.section == ORDERINFO_SECTION_REWARD){
        
        if (indexPath.row < self.order.promotion_items.count) {
            HXSOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXSOrderItemCell"];
            
            [cell configWithOrderRewardItem:self.order.promotion_items[indexPath.row]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            if (indexPath.row == self.order.items.count) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
            else {
                cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
            }
            
            return cell;
         
        } else {
                
            HXSOrderDetailTotalAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXSOrderDetailTotalAmountCell"];
            
            cell.amountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [self.order.order_amount doubleValue]];
            
            return cell;
        }
    } else {
        HXSOrderDetailFooterView * cell = [tableView dequeueReusableCellWithIdentifier:@"HXSOrderDetailFooterView"];
        
        [cell configWithOrderInfo:self.order];
        
        return cell;
    }
}


#pragma mark - Setter Getter Methods

- (UIButton *)cancelButton
{
    if (nil == _cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.borderColor = [UIColor colorWithRGBHex:0xE5E6E7].CGColor;
        _cancelButton.layer.borderWidth = 0.5;
        [_cancelButton setTitleColor:[UIColor colorWithRGBHex:0x666666] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor highlightedColor:0x666666] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(onClickCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

- (UIButton *)payButton
{
    if (nil == _payButton) {
        _payButton = [[UIButton alloc] init];
        _payButton.backgroundColor = [UIColor colorWithRGBHex:0xF9A502];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor colorWithRGBHex:0xFFFFFF] forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor highlightedColor:0xFFFFFF] forState:UIControlStateHighlighted];
        [_payButton addTarget:self action:@selector(onClickPay:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _payButton;
}

- (UIButton *)feedbackButton
{
    if (nil == _feedbackButton) {
        // cancel button
        _feedbackButton = [[UIButton alloc] init];
        _feedbackButton.backgroundColor = [UIColor whiteColor];
        _feedbackButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_feedbackButton setTitle:@"我要反馈" forState:UIControlStateNormal];
        _feedbackButton.layer.masksToBounds = YES;
        _feedbackButton.layer.borderColor = [UIColor colorWithRGBHex:0xE5E6E7].CGColor;
        _feedbackButton.layer.borderWidth = 0.5;
        [_feedbackButton setTitleColor:[UIColor colorWithRGBHex:0x666666] forState:UIControlStateNormal];
        [_feedbackButton setTitleColor:[UIColor highlightedColor:0x666666] forState:UIControlStateHighlighted];
        [_feedbackButton addTarget:self action:@selector(onClickFeedbackBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _feedbackButton;
}

- (HXSOrderActivityInfoView *)activityInfoView
{
    if (nil == _activityInfoView) {
        _activityInfoView = [[HXSOrderActivityInfoView alloc] init];
        _activityInfoView.backgroundColor = [UIColor clearColor];
    }
    
    return _activityInfoView;
}

@end

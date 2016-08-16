//
//  HXSPrintOrderDetailViewController.m
//  store
//
//  Created by 格格 on 16/3/22.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintOrderDetailViewController.h"
#import "HXSPersonal.h"
#import "HXSOrderActivityInfoView.h"
#import "HXSMyPrintOrderItem.h"
#import "HXSPrintModel.h"
#import "HXSMyOrdersViewController.h"
#import "HXSPrintOrderDetailStatusCell.h"
#import "HXSMyOderTableViewCell.h"
#import "HXSOrderDetailSectionHeaderView.h"
#import "HXSOrderDetailTotalAmountCell.h"
#import "HXSPrintOrderDetailFooterView.h"
#import "HXSActionSheet.h"
#import "HXSAlipayManager.h"
#import "HXSCreditPayManager.h"
#import "HXSWXApiManager.h"
#import "HXSPrintOrderFeeTableViewCell.h"
#import "HXSPrintOrderDetaiNoPaylFooterView.h"

static NSString *HXSPrintOrderDetailStatusCellIdentify = @"HXSPrintOrderDetailStatusCell";
static NSString *HXSPrintOrderItemCellIdentify = @"HXSMyOderTableViewCell";
static NSString *HXSOrderDetailSectionHeaderViewIdentify = @"HXSOrderDetailSectionHeaderView";
static NSString *HXSOrderDetailTotalAmountCellIdentify = @"HXSOrderDetailTotalAmountCell";
static NSString *HXSPrintOrderDetailFooterViewIdentify = @"HXSPrintOrderDetailFooterView";
static NSString *HXSPrintOrderFeeTableViewCellIdentify = @"HXSPrintOrderFeeTableViewCell";
static NSString *HXSPrintOrderDetaiNoPaylFooterViewIdentify = @"HXSPrintOrderDetaiNoPaylFooterView";



@interface HXSPrintOrderDetailViewController ()<UITableViewDataSource,
                                                UITableViewDelegate,
                                                HXSAlipayDelegate,
                                                HXSWechatPayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIView *bottomContainer;

@property (nonatomic, strong) HXSPrintOrderInfo *orderInfo;

@property (nonatomic, strong) NSArray *couponArr;
@property (nonatomic, assign) BOOL ifShowDeliveryAmount;
@property (nonatomic, assign, getter=isFirstFetching) BOOL firstFetching;

@end

@implementation HXSPrintOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialNavigation];
    [self initialTableView];
    [self initialBottomButtons];
    
    [self updateBottomButtonStatus];
    
    self.firstFetching = YES;
    [self requestOrderDetail:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - initial
-(void)initialNavigation
{
   self.navigationItem.title = @"订单详情";
   self.navigationItem.rightBarButtonItem = nil;
}

-(void)initialTableView{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor colorWithRGBHex:0xE5E6E7];
    
    [_tableView registerNib:[UINib nibWithNibName:HXSPrintOrderDetailStatusCellIdentify bundle:nil] forCellReuseIdentifier:HXSPrintOrderDetailStatusCellIdentify];
    [_tableView registerNib:[UINib nibWithNibName:HXSPrintOrderItemCellIdentify bundle:nil] forCellReuseIdentifier:HXSPrintOrderItemCellIdentify];
    [_tableView registerNib:[UINib nibWithNibName:HXSOrderDetailSectionHeaderViewIdentify bundle:nil] forCellReuseIdentifier:HXSOrderDetailSectionHeaderViewIdentify];
    [_tableView registerNib:[UINib nibWithNibName:HXSOrderDetailTotalAmountCellIdentify bundle:nil] forCellReuseIdentifier:HXSOrderDetailTotalAmountCellIdentify];
    [_tableView registerNib:[UINib nibWithNibName:HXSPrintOrderDetailFooterViewIdentify bundle:nil] forCellReuseIdentifier:HXSPrintOrderDetailFooterViewIdentify];
    [_tableView registerNib:[UINib nibWithNibName:HXSPrintOrderFeeTableViewCellIdentify bundle:nil] forCellReuseIdentifier:HXSPrintOrderFeeTableViewCellIdentify];
    [_tableView registerNib:[UINib nibWithNibName:HXSPrintOrderDetaiNoPaylFooterViewIdentify bundle:nil] forCellReuseIdentifier:HXSPrintOrderDetaiNoPaylFooterViewIdentify];
}

-(void)initialBottomButtons{
    _bottomContainer.clipsToBounds = YES;
    
    _cancelButton = [[UIButton alloc] init];
    _cancelButton.backgroundColor = [UIColor whiteColor];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.borderColor = [UIColor colorWithRGBHex:0xE5E6E7].CGColor;
    _cancelButton.layer.borderWidth = 0.5;
    
    [_cancelButton setTitleColor:[UIColor colorWithRGBHex:0x666666] forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor highlightedColor:0x666666] forState:UIControlStateHighlighted];
    [_cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    _payButton = [[UIButton alloc] init];
    _payButton.backgroundColor = [UIColor colorWithRGBHex:0xF9A502];
    _payButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [_payButton setTitleColor:[UIColor colorWithRGBHex:0xFFFFFF] forState:UIControlStateNormal];
    [_payButton setTitleColor:[UIColor highlightedColor:0xFFFFFF] forState:UIControlStateHighlighted];
    [_payButton addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - webServies
- (void)requestOrderDetail:(BOOL)updateOrderList{
    
    [MBProgressHUD showInView:self.view];
    __weak __typeof(self)weakSelf = self;
    [HXSPrintModel getPrintOrderDetialWithOrderSn:self.orderSNNum complete:^(HXSErrorCode code, NSString *message, HXSPrintOrderInfo *printOrder) {
        
        if(kHXSNoError == code){
            
            if (weakSelf.isFirstFetching
                && (HXSPrintOrderStatusNotPay == [printOrder.statusIntNum integerValue])) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [weakSelf requestOrderDetail:updateOrderList];
                });
                
                weakSelf.firstFetching = NO;
                
                return ;
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            weakSelf.orderInfo = printOrder;
            [weakSelf updateBottomButtonStatus];
            [weakSelf.tableView reloadData];
            
            if(updateOrderList){
                [weakSelf updatePrintOrderList];
            }
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
    }];
}

#pragma mark - statusUpdate
- (void)updateBottomButtonStatus{
    [_cancelButton removeFromSuperview];
    [_payButton removeFromSuperview];

    if (_orderInfo && (_orderInfo.statusIntNum.intValue == HXSPrintOrderStatusNotPay)) { // 订单未支付
        _bottomConstraint.constant = 0;
        //  && _orderInfo.paystatus == kHXSOrderPayStatusWaiting
        if(_orderInfo.paytypeIntNum.intValue != kHXSOrderPayTypeCash) { // 非现金支付
            [_bottomContainer addSubview:_cancelButton];
            [_bottomContainer addSubview:_payButton];
            
            CGFloat width = _bottomContainer.width/3.0;
            _payButton.frame = CGRectMake(_bottomContainer.width - width, 0, width, _bottomContainer.height);
            
            _cancelButton.frame = CGRectMake(width, -1, width, _bottomContainer.height + 2);
            _cancelButton.layer.borderColor = [UIColor colorWithRGBHex:0xE5E6E7].CGColor;
        }
        else { // 现金支付
            [_bottomContainer addSubview:_cancelButton];
            _cancelButton.frame = _bottomContainer.bounds;
            _cancelButton.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }else if(_orderInfo&&(_orderInfo.statusIntNum.intValue == HXSPrintOrderStatusConfirmed)){ // 订单未打印
        _bottomConstraint.constant = 0;
        _cancelButton.frame = _bottomContainer.bounds;
        _cancelButton.layer.borderColor = [UIColor colorWithRGBHex:0xE5E6E7].CGColor;
        [_bottomContainer addSubview:_cancelButton];
    
    }else {
        _bottomConstraint.constant = -50;
    }
}

// 刷新我的订单中云印店订单列表
- (void)updatePrintOrderList{
     HXSMyOrdersViewController * vc = (HXSMyOrdersViewController *)[self.navigationController firstViewControllerOfClass:@"HXSMyOrdersViewController"];

    [vc replacePrintOrderInfo:_orderInfo];
}


#pragma mark - Target/action
// 联系店长
- (void)telephoneButtonPressed
{
    [HXSUsageManager trackEvent:kUsageEventCallShopManager parameter:nil];
    
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
    
    HXSActionSheetEntity *callEntity = [[HXSActionSheetEntity alloc] init];
    callEntity.nameStr = _orderInfo.dormContactStr;
    
    HXSAction *callAction = [HXSAction actionWithMethods:callEntity
                                                 handler:^(HXSAction *action) {
                                                     NSString *phoneNumber = [@"tel://" stringByAppendingString:_orderInfo.dormContactStr];
                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                                 }];
    
    [sheet addAction:callAction];
    
    [sheet show];
}

// 取消订单
- (void)cancelOrder:(id)sender{
    if (_orderInfo && (_orderInfo.statusIntNum.intValue == HXSPrintOrderStatusNotPay)){
            __weak __typeof(self) weakSelf = self;
        
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                                              message:@"您确定要取消该订单吗?"
                                                                      leftButtonTitle:@"取消"
                                                                    rightButtonTitles:@"确定"];
            alertView.rightBtnBlock = ^{
                [MBProgressHUD showInView:weakSelf.view];
                [HXSPrintModel cancelPrintOrderWithOrderSn:_orderInfo.orderSnLongNum complete:^(HXSErrorCode code, NSString *message, NSDictionary *info) {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    if (code == kHXSNoError) {
                        weakSelf.firstFetching = YES;
                        
                        [weakSelf requestOrderDetail:YES];
                    }
                    else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                    }
                }];
            };
            
            [alertView show];
    }else if(_orderInfo&&(_orderInfo.statusIntNum.intValue == HXSPrintOrderStatusConfirmed)){
        [HXSUsageManager trackEvent:kUsageEventCancelOrder parameter:nil];
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请联系店长取消订单哦~" afterDelay:1.5];
    }

}
// 立即支付
- (void)payOrder:(id)sender{
    [HXSUsageManager trackEvent:kUsageEventPayNow parameter:nil];
    
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showInView:self.view];
    [HXSActionSheetModel fetchPayMethodsWith:[NSNumber numberWithInt:kHXSOrderTypePrint]
                                   payAmount:[NSNumber numberWithFloat:self.orderInfo.payAmountDoubleNum.doubleValue]
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
                                                             [weakSelf changeOrderPayTypeToCash];
                                                         }];
                [sheet addAction:action];
            }
                break;
                
            case kHXSOrderPayTypeZhifu:
            {
                HXSAction *payAction = [HXSAction actionWithMethods:sheetEntity
                                                            handler:^(HXSAction *action) {
                                                                HXSOrderInfo *info= [[HXSOrderInfo alloc] init];
                                                                
                                                                info.order_sn = [NSString stringWithFormat:@"%@", _orderInfo.orderSnLongNum];
                                                                info.type = kHXSOrderTypePrint;
                                                                info.order_amount = @(_orderInfo.payAmountDoubleNum.doubleValue);
                                                                info.attach = _orderInfo.attachStr;
                                                                [[HXSAlipayManager sharedManager] pay:info delegate:weakSelf];
                                                            }];
                
                [sheet addAction:payAction];
            }
                break;
                
            case kHXSOrderPayTypeWechatApp:
            {
                HXSAction *wechatPayAction = [HXSAction actionWithMethods:sheetEntity
                                                                  handler:^(HXSAction *action) {
                                                                      HXSOrderInfo *info= [[HXSOrderInfo alloc] init];
                                                                      
                                                                      info.order_sn = [NSString stringWithFormat:@"%@", _orderInfo.orderSnLongNum];
                                                                      info.type = kHXSOrderTypePrint;
                                                                      info.order_amount = @(_orderInfo.payAmountDoubleNum.doubleValue);
                                                                      info.attach = _orderInfo.attachStr;
                                                                      [[HXSWXApiManager sharedManager] wechatPay:info delegate:weakSelf];
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
                                                                              [weakSelf payOrderWith:kHXSOrderPayTypeBaiHuaHua withErrorMessage:nil];
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
                
            default:
                break;
        }
    }
    
    [sheet show];
}

- (void)changeOrderPayTypeToCash
{
    __weak typeof(self) weakSelf = self;
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                                      message:@"您确定要将该订单转为货到付款吗?"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"货到付款"];
    alertView.rightBtnBlock = ^{
        
        [HXSPrintModel changePrintOrderPayType:[NSString stringWithFormat:@"%@",_orderInfo.orderSnLongNum] complete:^(HXSErrorCode code, NSString *message, NSDictionary *info) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            if (code == kHXSNoError) {
                weakSelf.firstFetching = YES;
                
                [weakSelf requestOrderDetail:YES];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }];
    };
    
    [alertView show];
}

#pragma mark - Bai Hua Hua Pay Method

- (void)payOrderWith:(HXSOrderPayType)payType withErrorMessage:(NSString *)errorMessageStr
{
    switch (payType) {
        case kHXSOrderPayTypeBaiHuaHua:
        {
            HXSMyPrintOrderItem *itemEntity = [[self.orderInfo itemsArr] firstObject];
            NSString *titleStr                = itemEntity.fileNameStr;
            
            HXSCreditPayOrderInfo *order = [[HXSCreditPayOrderInfo alloc] init];
            order.tradeTypeIntNum        = [NSNumber numberWithInteger:kHXStradeTypeNormal];
            order.orderSnStr             = [NSString stringWithFormat:@"%@", _orderInfo.orderSnLongNum];
            order.orderTypeIntNum        = [NSNumber numberWithInteger:kHXSOrderTypePrint];
            order.amountFloatNum         = @(_orderInfo.payAmountDoubleNum.doubleValue);
            order.discountFloatNum       = @(_orderInfo.discountDoubleNum.doubleValue);
            order.orderDescriptionStr    = titleStr;
            order.periodsIntNum          = [NSNumber numberWithInteger:1];
            order.callBackUrlStr         = _orderInfo.attachStr;
            
            [[HXSCreditPayManager instance] payOrder:order completion:^(HXSCreditPayResulType operation, NSString *message, NSDictionary *info) {
                switch (operation) {
                    case HXSCreditPaySuccess:
                    {
                        [self dealWithBaiHuaHuaResult:YES];
                    }
                        break;
                    case HXSCreditPayCanceled:
                    {
                        [self dealWithBaiHuaHuaResult:NO];
                    }
                        break;
                    case HXSCreditPayGetPasswdBack:
                    {
                       // [self dealWithBaiHuaHuaResult:NO];
                    }
                        break;
                    case HXSCreditPayFailed:
                    {
                        [self dealWithBaiHuaHuaResult:NO];
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
    UIAlertView *alertView = nil;
    
    if (hasPaid) {
        alertView = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        self.firstFetching = YES;
        
        [self requestOrderDetail:YES];
        
    } else {
        alertView = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    }
    
    [alertView show];
}

#pragma mark - HXSAlipayDelegate

- (void)payCallBack:(NSString *)status message:(NSString *)message result:(NSDictionary *)result
{
    NSString *messageStr = nil;
    if(status.intValue == 9000) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
        self.firstFetching = YES;
        
        [self requestOrderDetail:YES];
        messageStr = @"支付成功";
    }else if(status.intValue == 6001){
        messageStr = (message && message.length > 0)?message:@"用户取消";
    }else if(status.intValue == 4000) {
        messageStr = @"支付失败";
    }else if (message.length > 0) {
        messageStr = message;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"支付结果" message:messageStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - HXSWechatPayDelegate

- (void)wechatPayCallBack:(HXSWechatPayStatus)status message:(NSString *)message result:(NSDictionary *)result
{
    NSString *messageStr = nil;
    if (HXSWechatPayStatusSuccess == status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
        self.firstFetching = YES;
        
        [self requestOrderDetail:YES];
        messageStr = @"支付成功";
    } else {
        messageStr = @"支付失败";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"支付结果" message:messageStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}


#pragma mark - UITableViewDelegate&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(nil == _orderInfo){
        return 0;
    }
    
    if (section == 1) {
        return 2 + [_orderInfo.itemsArr count] + [self.couponArr count];
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if(_orderInfo.deliveryDescStr){
            NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
            
            CGSize contentSize = [_orderInfo.deliveryDescStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 127, MAXFLOAT)
                                                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                        attributes:attributes
                                                                           context:nil].size;
            int cellHeight = 210;
            if(ceilf(contentSize.height) > 17){
                cellHeight +=(ceilf(contentSize.height) - 17);
            }
            if(_orderInfo.remarkStr == nil)
                _orderInfo.remarkStr = @"";
            
            CGSize remarkSize = [_orderInfo.remarkStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 101, MAXFLOAT)
                                                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                       attributes:attributes
                                                                          context:nil].size;
            
            if(ceilf(remarkSize.height) > 17){
                cellHeight +=(ceilf(remarkSize.height) - 17);
            }
            
            return cellHeight;
        }
        
        return 210.0;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return  40.0;
        } else if (indexPath.row <= _orderInfo.itemsArr.count) {
            return 92.0;
        } else if(indexPath.row <= (_orderInfo.itemsArr.count + [self.couponArr count])){
            return 30.0f;
        } else {
            return 40.0;
        }
    }
    else if (indexPath.section == 2) {
        if(HXSPrintOrderStatusNotPay == _orderInfo.statusIntNum.intValue)
            return 50;
        if(HXSPrintOrderStatusCanceled == _orderInfo.statusIntNum.intValue){
            if(_orderInfo.paytypeIntNum&&_orderInfo.refundStatusCodeNum)
                return 114 + [_orderInfo getCancleResonLabelHeight];
            return 50;
        }
    }
    
    return 92.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HXSPrintOrderDetailStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSPrintOrderDetailStatusCellIdentify];
        cell.printOrder = _orderInfo;
        [cell.telephoneButton addTarget:self action:@selector(telephoneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (indexPath.section == 1) {
        if(indexPath.row == 0) {
            HXSOrderDetailSectionHeaderView *cell = [tableView dequeueReusableCellWithIdentifier:HXSOrderDetailSectionHeaderViewIdentify];
            cell.printOrderEntity = _orderInfo;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsZero;
            
            return cell;
        } else if (indexPath.row <= _orderInfo.itemsArr.count) {
            HXSMyOderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSPrintOrderItemCellIdentify];
            
            HXSMyPrintOrderItem *item = _orderInfo.itemsArr[indexPath.row - 1];
            cell.printItem = item;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.row == _orderInfo.itemsArr.count) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
            else {
                cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
            }
            
            return cell;
        } else if (indexPath.row <= (_orderInfo.itemsArr.count + [self.couponArr count])) {
            HXSPrintOrderFeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSPrintOrderFeeTableViewCellIdentify];
            
            NSUInteger index = indexPath.row - [self.orderInfo.itemsArr count] - 1; // 1 is because the first row is header view, should delete
            [cell setupPrintOrderFeeCellWith:[self.couponArr objectAtIndex:index]];
            
            return cell;
        } else{
            HXSOrderDetailTotalAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSOrderDetailTotalAmountCellIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.printOrderEntity = _orderInfo;
            return cell;
        }
        

    }
    else if (indexPath.section == 2) {
            HXSPrintOrderDetailFooterView *cell = [tableView dequeueReusableCellWithIdentifier:HXSPrintOrderDetailFooterViewIdentify];
            cell.printOrderEntity = _orderInfo;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
    }
    
    return nil;
}


#pragma mark - Setter & Getter Methods

- (NSArray *)couponArr
{
    if(!_orderInfo) {
        return nil;
    }
    
    NSMutableArray *couponArr = [[NSMutableArray alloc] initWithCapacity:5];
    if (0 < [self.orderInfo.adPageNumIntNum integerValue]) {
        NSDictionary *dic = @{@"key":[NSString stringWithFormat:@"免费打印：%zd张", [self.orderInfo.adPageNumIntNum integerValue]],
                              @"value":[NSString stringWithFormat:@"-￥%0.2f", [self.orderInfo.freeAmountDoubleNum doubleValue]]};
        
        [couponArr addObject:dic];
    }

    NSArray *tempArr = nil;
    if(HXSPrintDeliveryTypeShopOwner ==_orderInfo.sendTypeIntNum.intValue){// 店长配送
        if(_orderInfo.deliveryAmountDoubleNum
           &&_orderInfo.deliveryAmountDoubleNum.doubleValue > 0.0000000
           && _orderInfo.couponDiscountDoubleNum
           && _orderInfo.couponDiscountDoubleNum.doubleValue > 0.0000000){
            
            tempArr = @[@{@"key":@"优惠：",
                          @"value":[NSString stringWithFormat:@"-￥%.2f",_orderInfo.couponDiscountDoubleNum.doubleValue]},
                        @{@"key":@"配送费：",
                          @"value":[NSString stringWithFormat:@"￥%.2f",_orderInfo.deliveryAmountDoubleNum.doubleValue]},
                        ];
            
        }else if((_orderInfo.deliveryAmountDoubleNum
                  &&_orderInfo.deliveryAmountDoubleNum.doubleValue > 0.0000000)
                 &&(!_orderInfo.couponDiscountDoubleNum
                    || _orderInfo.couponDiscountDoubleNum.doubleValue <= 0.0000000)){
                     _ifShowDeliveryAmount = YES;
                     
                     tempArr = @[@{@"key":@"配送费：",
                                   @"value":[NSString stringWithFormat:@"￥%.2f",_orderInfo.deliveryAmountDoubleNum.doubleValue]},
                                 ];
                 } else if( _orderInfo.couponDiscountDoubleNum
                          && _orderInfo.couponDiscountDoubleNum.doubleValue > 0.0000000
                          &&(!_orderInfo.deliveryAmountDoubleNum
                             ||_orderInfo.deliveryAmountDoubleNum.doubleValue <= 0.0000000)){
                              _ifShowDeliveryAmount = NO;
                              
                              tempArr = @[@{@"key":@"优惠：",
                                            @"value":[NSString stringWithFormat:@"-￥%.2f",_orderInfo.couponDiscountDoubleNum.doubleValue]},
                                          ];
                          }
        
    } else { // 上门自取
        if(_orderInfo.couponDiscountDoubleNum && _orderInfo.couponDiscountDoubleNum.doubleValue > 0.0000000){
            _ifShowDeliveryAmount = NO;
            
            tempArr = @[@{@"key":@"优惠：",
                          @"value":[NSString stringWithFormat:@"-￥%.2f",_orderInfo.couponDiscountDoubleNum.doubleValue]},
                        ];
        }
    }
    
    [couponArr addObjectsFromArray:tempArr];
    
    return couponArr;
}

@end

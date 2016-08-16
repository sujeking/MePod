//
//  HXSBoxOrderViewController.m
//  store
//
//  Created by ArthurWang on 15/7/26.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBoxOrderViewController.h"
#import "HXSBoxMacro.h"

#import "HXSBoxModel.h"
#import "HXSLoadingView.h"
#import "HXSBoxOrderEntity.h"
#import "HXSAlipayManager.h"
#import "HXSSettingsManager.h"
#import "HXSPayPasswordAlertView.h"
#import "HXSBaiHuaHuaPayModel.h"
#import "UIImageView+AFNetworking.h"

#import "HXSCreditPayManager.h"
#import "HXSWXApiManager.h"
#import "HXSOrderActivityInfoView.h"
#import "HXSActionSheet.h"

#import "HXSPrintOrderDetailStatusCell.h"
#import "HXSMyOderTableViewCell.h"
#import "HXSOrderDetailSectionHeaderView.h"
#import "HXSOrderDetailTotalAmountCell.h"
#import "HXSPrintOrderDetailFooterView.h"
#import "HXSPrintOrderFeeTableViewCell.h"
#import "HXSPrintOrderDetaiNoPaylFooterView.h"


static NSString *HXSPrintOrderDetailStatusCellIdentify = @"HXSPrintOrderDetailStatusCell";
static NSString *HXSPrintOrderItemCellIdentify = @"HXSMyOderTableViewCell";
static NSString *HXSOrderDetailSectionHeaderViewIdentify = @"HXSOrderDetailSectionHeaderView";
static NSString *HXSOrderDetailTotalAmountCellIdentify = @"HXSOrderDetailTotalAmountCell";
static NSString *HXSPrintOrderDetailFooterViewIdentify = @"HXSPrintOrderDetailFooterView";
static NSString *HXSPrintOrderFeeTableViewCellIdentify = @"HXSPrintOrderFeeTableViewCell";
static NSString *HXSPrintOrderDetaiNoPaylFooterViewIdentify = @"HXSPrintOrderDetaiNoPaylFooterView";


@interface HXSBoxOrderViewController () <UITableViewDelegate,
                                         UITableViewDataSource,
                                         HXSAlipayDelegate,
                                         HXSWechatPayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *boxOrderDetailTableView;
@property (weak, nonatomic) IBOutlet UIView *boxOrderDetailBottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boxOrderDetailBottomViewBottom;

@property (nonatomic, strong) HXSBoxModel       *boxModel;
@property (nonatomic, strong) HXSBoxOrderModel *boxOrderEntity;

@property (nonatomic, strong) HXSBaiHuaHuaPayModel *baiHuahuaPayModel;
@property (nonatomic, strong) NSMutableDictionary  *offscreenCells;

@property (nonatomic, strong) HXSOrderActivityInfoView *activityInfoView;
@property (nonatomic, assign, getter=isFirstFetching) BOOL firstFetching;


@end

@implementation HXSBoxOrderViewController

#pragma mark - UIViewController Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.title = @"订单详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    self.boxOrderDetailBottomViewBottom.constant = - 49;
    [self initialTableView];
    
    self.firstFetching = YES;
    [self fetchOrderInfoFromService];
    
    _activityInfoView = [[HXSOrderActivityInfoView alloc] init];
    _activityInfoView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.boxOrderDetailTableView setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [HXSLoadingView closeInView:self.view];
    [self.boxOrderDetailTableView setHidden:NO];
}

- (void)dealloc
{
    self.orderSNStr          = nil;
    self.boxModel            = nil;
    self.boxOrderEntity      = nil;
    self.baiHuahuaPayModel   = nil;
    self.offscreenCells      = nil;
    self.activityInfoView    = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override Methods

- (void)back
{
    if(self.completeBlock) {
        self.completeBlock();
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Initial Methods

- (void)initialTableView
{
    [_boxOrderDetailTableView registerNib:[UINib nibWithNibName:HXSPrintOrderDetailStatusCellIdentify bundle:nil] forCellReuseIdentifier:HXSPrintOrderDetailStatusCellIdentify];
    [_boxOrderDetailTableView registerNib:[UINib nibWithNibName:HXSPrintOrderItemCellIdentify bundle:nil] forCellReuseIdentifier:HXSPrintOrderItemCellIdentify];
    [_boxOrderDetailTableView registerNib:[UINib nibWithNibName:HXSOrderDetailSectionHeaderViewIdentify bundle:nil] forCellReuseIdentifier:HXSOrderDetailSectionHeaderViewIdentify];
    [_boxOrderDetailTableView registerNib:[UINib nibWithNibName:HXSOrderDetailTotalAmountCellIdentify bundle:nil] forCellReuseIdentifier:HXSOrderDetailTotalAmountCellIdentify];
    [_boxOrderDetailTableView registerNib:[UINib nibWithNibName:HXSPrintOrderDetailFooterViewIdentify bundle:nil] forCellReuseIdentifier:HXSPrintOrderDetailFooterViewIdentify];
    [_boxOrderDetailTableView registerNib:[UINib nibWithNibName:HXSPrintOrderFeeTableViewCellIdentify bundle:nil] forCellReuseIdentifier:HXSPrintOrderFeeTableViewCellIdentify];
    [_boxOrderDetailTableView registerNib:[UINib nibWithNibName:HXSPrintOrderDetaiNoPaylFooterViewIdentify bundle:nil] forCellReuseIdentifier:HXSPrintOrderDetaiNoPaylFooterViewIdentify];

}

- (void)showShareInfos
{
    [_activityInfoView showActivityInfos:[_boxOrderEntity changeActivitiesArrToOld]
                                  inView:self.view
                             bottomSpace:([self.boxOrderEntity.orderStatusNum intValue] != kHSXBoxOrderStatusUnpay) ? 0.0 : 45];
}


#pragma mark - Setter Getter Methods

- (HXSBoxModel *)boxModel
{
    if (nil == _boxModel) {
        _boxModel = [[HXSBoxModel alloc] init];
    }
    
    return _boxModel;
}

- (HXSBaiHuaHuaPayModel *)baiHuahuaPayModel
{
    if (nil == _baiHuahuaPayModel) {
        _baiHuahuaPayModel = [[HXSBaiHuaHuaPayModel alloc] init];
    }
    
    return _baiHuahuaPayModel;
}

- (NSMutableDictionary *)offscreenCells
{
    if (nil == _offscreenCells) {
        _offscreenCells = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    
    return _offscreenCells;
}


#pragma mark - Target Methods

- (IBAction)onClickCancelOrderBtn:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventBoxOrderCansel parameter:nil];
    __weak HXSBoxOrderViewController *weakSelf = self;
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                      message:@"您确定要取消该订单吗?"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"确认"];
    
    
    alertView.rightBtnBlock = ^{
        [weakSelf cancelOrderToService];
    };
    
    [alertView show];
}

- (IBAction)onClickGoToPayBtn:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventBoxOrderImmediatelyPay parameter:nil];
    [self fetchSelectPayTypeView];
}

- (void)payWithBaiHuaHua
{
    if (![HXSUserAccount currentAccount].isLogin) {
        [[AppDelegate sharedDelegate].rootViewController checkIsLoggedin];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [[HXSCreditPayManager instance] checkCreditPay:^(HXSCreditCheckResultType operation) {
        if (operation == HXSCreditCheckSuccess) {
            [weakSelf payOrderWith:kHXSOrderPayTypeCreditCard withErrorMessage:nil];
        }
    }];
}

- (void)payWithAlipay
{
    HXSOrderInfo *orderInfo = [[HXSOrderInfo alloc] init];
    
    orderInfo.order_sn = [NSString stringWithFormat:@"%@", self.boxOrderEntity.orderIdStr];
    orderInfo.type = [self.boxOrderEntity.bizTypeNum intValue];
    orderInfo.order_amount = self.boxOrderEntity.orderAmountDoubleNum;
    
    [[HXSAlipayManager sharedManager] pay:orderInfo
                                 delegate:self];
}

- (void)payWithWechat
{
    HXSOrderInfo *orderInfo = [[HXSOrderInfo alloc] init];
    
    orderInfo.order_sn = [NSString stringWithFormat:@"%@", self.boxOrderEntity.orderIdStr];
    orderInfo.type = [self.boxOrderEntity.bizTypeNum intValue];
    orderInfo.order_amount = self.boxOrderEntity.orderAmountDoubleNum;
    
    [[HXSWXApiManager sharedManager] wechatPay:orderInfo delegate:self];
}


#pragma mark - Pay Type View Methods

- (void)fetchSelectPayTypeView
{
    __weak typeof(self) weakSelf = self;
    
    [HXSLoadingView showLoadingInView:self.view];
    [HXSActionSheetModel fetchPayMethodsWith:[NSNumber numberWithInt:kHXSOrderTypeNewBox]
                                   payAmount:self.boxOrderEntity.orderAmountDoubleNum
                                 installment:[NSNumber numberWithInteger:0]
                                    complete:^(HXSErrorCode code, NSString *message, NSArray *payArr) {
                                        [HXSLoadingView closeInView:weakSelf.view];
                                        
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
                // Donthing
            }
                break;
                
            case kHXSOrderPayTypeZhifu:
            {
                HXSAction *payAction = [HXSAction actionWithMethods:sheetEntity
                                                            handler:^(HXSAction *action) {
                                                                [HXSUsageManager trackEvent:kUsageEventBoxPayType parameter:@{@"pay_type":@"支付宝"}];
                                                                
                                                                [weakSelf payWithAlipay];
                                                            }];
                
                [sheet addAction:payAction];
            }
                break;
                
            case kHXSOrderPayTypeWechatApp:
            {
                HXSAction *wechatPayAction = [HXSAction actionWithMethods:sheetEntity
                                                                  handler:^(HXSAction *action) {
                                                                      [weakSelf payWithWechat];
                                                                  }];
                [sheet addAction:wechatPayAction];
            }
                break;
                
            case kHXSOrderPayTypeCreditCard:
            {
                HXSAction *baiHuahuaAction = [HXSAction actionWithMethods:sheetEntity
                                                                  handler:^(HXSAction *action) {
                                                                      [HXSUsageManager trackEvent:kUsageEventBoxPayType parameter:@{@"pay_type":@"信用钱包"}];
                                                                      
                                                                      [weakSelf payWithBaiHuaHua];
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


#pragma mark - HXSAlipayDelegate

- (void)payCallBack:(NSString *)status message:(NSString *)message result:(NSDictionary *)result
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBoxOrderHasPayed
                                                        object:nil];
    self.firstFetching = YES;
    
    [self fetchOrderInfoFromService];
}


#pragma mark - HXSWechatPayDelegate

- (void)wechatPayCallBack:(HXSWechatPayStatus)status message:(NSString *)message result:(NSDictionary *)result
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBoxOrderHasPayed
                                                        object:nil];
    self.firstFetching = YES;
    
    [self fetchOrderInfoFromService];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (nil == self.boxOrderEntity) {
        return 0;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (nil == self.boxOrderEntity) {
        return 0;
    }
    if (section == 1) {
        return 2 + _boxOrderEntity.itemsArr.count;
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
        return 210.0;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return  40.0;
        }
        else if (indexPath.row >  _boxOrderEntity.itemsArr.count) {

            return 40.0;
        }
    }
    else if (indexPath.section == 2) {
        if(kHXSBoxOrderStayusNotPay == _boxOrderEntity.orderStatusNum.intValue)
            return 50;
        if(kHXSBoxOrderStayusCancled == _boxOrderEntity.orderStatusNum.intValue){
            if(_boxOrderEntity.orderPayArr&&_boxOrderEntity.refundStatusMsg)
                return 114;
            return 50;
        }
    }
    
    return 92.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HXSPrintOrderDetailStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSPrintOrderDetailStatusCellIdentify];
        cell.boxOrder = self.boxOrderEntity;
        [cell.telephoneButton addTarget:self action:@selector(telephoneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 1){
        if(indexPath.row == 0) {
            HXSOrderDetailSectionHeaderView *cell = [tableView dequeueReusableCellWithIdentifier:HXSOrderDetailSectionHeaderViewIdentify];
            [cell setNumberOfItems:self.boxOrderEntity.itemCountNum.intValue];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsZero;
            
            return cell;
        }
        else if (indexPath.row <= self.boxOrderEntity.itemsArr.count){
            HXSMyOderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSPrintOrderItemCellIdentify];
            
            HXSBoxOrderItemModel *item = self.boxOrderEntity.itemsArr[indexPath.row - 1];
            cell.boxOrderItemModel = item;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.row == self.boxOrderEntity.itemsArr.count) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
            else {
                cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
            }
            
            return cell;
        }
        else {
                HXSOrderDetailTotalAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSOrderDetailTotalAmountCellIdentify];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.boxOrder = self.boxOrderEntity;
                return cell;
        }
    } else if (indexPath.section == 2) {
        HXSPrintOrderDetailFooterView *cell = [tableView dequeueReusableCellWithIdentifier:HXSPrintOrderDetailFooterViewIdentify];
        cell.boxOrderModel = self.boxOrderEntity;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;

}




#pragma mark - Fetch Order Info

- (void)fetchOrderInfoFromService
{
    __weak typeof(self) weakSelf = self;
    
    [self.boxOrderDetailTableView setHidden:YES];
    [HXSLoadingView showLoadingInView:self.view];
    
    [HXSBoxModel fetBoxOrderInfoWithOrderId:self.orderSNStr withOrderItems:YES withOrderPays:YES complete:^(HXSErrorCode code, NSString *message, HXSBoxOrderModel *boxOrderModel) {
        if (kHXSNoError != code) {
            [weakSelf showWarning:message];
            
            [HXSLoadingView showLoadFailInView:weakSelf.view
                                         block:^{
                                             [weakSelf fetchOrderInfoFromService];
                                         }];
            
            return;
        }
        
        if (weakSelf.isFirstFetching
            && (kHSXBoxOrderStatusUnpay == [boxOrderModel.orderStatusNum integerValue])) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HXSLoadingView closeInView:weakSelf.view];
                
                [weakSelf fetchOrderInfoFromService];
            });
            
            weakSelf.firstFetching = NO;
            
            return;
        }
        
        [HXSLoadingView closeInView:weakSelf.view];
        [weakSelf.boxOrderDetailTableView setHidden:NO];
        
        weakSelf.boxOrderEntity = boxOrderModel;
        [weakSelf.boxOrderDetailTableView reloadData];
        
        if(boxOrderModel.orderStatusNum.intValue != kHXSBoxOrderStayusNotPay){
            weakSelf.boxOrderDetailBottomView.hidden = YES;
            weakSelf.boxOrderDetailBottomViewBottom.constant = - 49;
        }
        else{
            weakSelf.boxOrderDetailBottomView.hidden = NO;
            weakSelf.boxOrderDetailBottomViewBottom.constant = 0;
        }
        
        [weakSelf showShareInfos];
        
    }];
}

- (void)cancelOrderToService
{
    __weak typeof(self) weakSelf = self;
    
    [self.boxOrderDetailTableView setHidden:YES];
    
    [MBProgressHUD showInView:self.view];
    
    [self.boxModel cancelOrderWithOrderSN:self.orderSNStr
                                 complete:^(HXSErrorCode code, NSString *message, NSDictionary *orderInfo) {
                                     
                                     [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                     
                                     [weakSelf.boxOrderDetailTableView setHidden:NO];
                                     if (kHXSNoError != code) {
                                         [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                            status:message
                                                                        afterDelay:1.5f];
                                         
                                         return ;
                                     }
                                     
                                     weakSelf.firstFetching = YES;
                                     [weakSelf fetchOrderInfoFromService];
                                     
                                     [[NSNotificationCenter defaultCenter] postNotificationName:kBoxOrderHasPayed
                                                                                         object:nil];
                                 }];
}

#pragma mark - Order Pay Methods

- (void)payOrderWith:(HXSOrderPayType)payType withErrorMessage:(NSString *)errorMessageStr
{
    switch (payType) {
        case kHXSOrderPayTypeCreditCard:
        {
            HXSBoxOrderItemModel *itemEntity = [[self.boxOrderEntity itemsArr] firstObject];
            NSString *titleStr                = itemEntity.nameStr;
            
            HXSCreditPayOrderInfo *order = [[HXSCreditPayOrderInfo alloc] init];
            order.tradeTypeIntNum        = [NSNumber numberWithInteger:kHXStradeTypeNormal];
            order.orderSnStr             = [NSString stringWithFormat:@"%@", self.boxOrderEntity.orderIdStr];
            order.orderTypeIntNum        = [NSNumber numberWithInteger:kHXSOrderTypeNewBox];
            order.amountFloatNum         = self.boxOrderEntity.orderAmountDoubleNum;
            order.discountFloatNum       = self.boxOrderEntity.couponAmountDoubleNum;
            order.orderDescriptionStr    = titleStr;
            order.periodsIntNum          = [NSNumber numberWithInteger:1];
            
            __weak typeof(self) weakSelf = self;
            
            [[HXSCreditPayManager instance] payOrder:order completion:^(HXSCreditPayResulType operation, NSString *message, NSDictionary *info) {
                switch (operation) {
                    case HXSCreditPaySuccess:
                    {
                        weakSelf.firstFetching = YES;
                        
                        [weakSelf fetchOrderInfoFromService];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kBoxOrderHasPayed  object:nil];
                    }
                        break;
                    case HXSCreditPayCanceled:
                        break;
                    case HXSCreditPayGetPasswdBack:
                    {
                        
                    }
                        break;
                    case HXSCreditPayFailed:
                    {
                        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                           status:message
                                                       afterDelay:1.5f];
                        weakSelf.firstFetching = YES;
                        
                        [weakSelf fetchOrderInfoFromService];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kBoxOrderHasPayed object:nil];
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

#pragma mark - Target/action
// 联系店长
- (void)telephoneButtonPressed
{
    [HXSUsageManager trackEvent:kUsageEventBoxOrderContactDorm parameter:nil];
    
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
    
    HXSActionSheetEntity *callEntity = [[HXSActionSheetEntity alloc] init];
    callEntity.nameStr = [self.boxOrderEntity.extensionStr objectForKey:@"dorm_mobile"];
    
    HXSAction *callAction = [HXSAction actionWithMethods:callEntity
                                                 handler:^(HXSAction *action) {
                                                     NSString *phoneNumber = [@"tel://" stringByAppendingString:[self.boxOrderEntity.extensionStr objectForKey:@"dorm_mobile"]];
                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                                 }];
    
    [sheet addAction:callAction];
    [sheet show];
}

@end

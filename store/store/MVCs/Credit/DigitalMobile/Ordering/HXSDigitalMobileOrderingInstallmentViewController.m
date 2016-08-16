//
//  HXSDigitalMobileOrderingInstallmentViewController.m
//  store
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileOrderingInstallmentViewController.h"
#import "HXSDigitalMobileResultViewController.h"
#import "HXSMyOrdersViewController.h"
#import "HXSActionSheet.h"
#import "HXSAlipayManager.h"
#import "HXSCreditPayManager.h"
#import "HXSWXApiManager.h"
#import "HXSSettingsManager.h"
#import "HXSActionSheetModel.h"

@interface HXSDigitalMobileOrderingInstallmentViewController ()<HXSAlipayDelegate>
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsProperty;
@property (weak, nonatomic) IBOutlet UILabel *orderAmount;
@property (weak, nonatomic) IBOutlet UILabel *installmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIImageView *tipIcon;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation HXSDigitalMobileOrderingInstallmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"下单成功";
    self.payButton.layer.masksToBounds = YES;
    self.payButton.layer.cornerRadius = 5.0f;
}

- (void)initView
{
    HXSOrderItem *item = self.orderInfo.items[0];
    self.goodsName.text = item.name;
    self.goodsProperty.text = item.specificationsStr;
    self.orderAmount.text = [NSString stringWithFormat:@"￥%0.2f",item.amount.floatValue];
    self.installmentLabel.text = [NSString stringWithFormat:@"￥%0.2f",[[self.confirmOrderEntity getDownPayment] floatValue]];
    self.orderId.text = self.orderInfo.order_sn;
    self.orderTime.text = [self getDateString:self.orderInfo.add_time.longValue];
    
    if (self.confirmOrderEntity.installmentInfo.downpayment.percent.floatValue == 0) {
        self.bottomView.hidden = NO;
        self.payButton.hidden = YES;
        self.tipIcon.image = [UIImage imageNamed:@"ic_stagingsuccess"];
        self.tipLabel.text = @"下单成功";
    } else {
        self.bottomView.hidden = YES;
        self.payButton.hidden = NO;
        self.tipIcon.image = [UIImage imageNamed:@"ic_checkoutsuccess"];
        self.tipLabel.text = @"下单成功，请支付首付";
    }
}

- (NSString *)getDateString:(long)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [dateFormatter stringFromDate:date];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectPayType:(id)sender
{
    [self fetchPayTypeMethods];
}


#pragma mark - Select Pay Type Methods

- (void)fetchPayTypeMethods
{
    HXSOrderItem *item = self.orderInfo.items[0];
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showInView:self.view];
    [HXSActionSheetModel fetchPayMethodsWith:[NSNumber numberWithInt:kHXSOrderTypeInstallment]
                                   payAmount:item.amount
                                 installment:[NSNumber numberWithInteger:1]
                                    complete:^(HXSErrorCode code, NSString *message, NSArray *payArr) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
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
                HXSAction *action = [HXSAction actionWithMethods:sheetEntity handler:^(HXSAction *action) {
                    
                }];
                [sheet addAction:action];
            }
                break;
                
            case kHXSOrderPayTypeZhifu:
            {
                HXSAction *payAction = [HXSAction actionWithMethods:sheetEntity handler:^(HXSAction *action) {
                    [[HXSAlipayManager sharedManager] pay:weakSelf.orderInfo delegate:weakSelf];
                }];
                
                [sheet addAction:payAction];
            }
                break;
                
            case kHXSOrderPayTypeWechatApp:
            {
                HXSAction *wechatPayAction = [HXSAction actionWithMethods:sheetEntity handler:^(HXSAction *action) {
                    [[HXSWXApiManager sharedManager] wechatPay:weakSelf.orderInfo delegate:weakSelf];
                }];
                [sheet addAction:wechatPayAction];
            }
                break;
                
            case kHXSOrderPayTypeCreditCard:
            {
                HXSAction *baiHuahuaAction = [HXSAction actionWithMethods:sheetEntity handler:^(HXSAction *action) {
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
                
            default:
                break;
        }
    }
    
    [sheet show];
}


#pragma mark - pay call back

- (void)payCallBack:(NSString *)status message:(NSString *)message result:(NSDictionary *)result
{
    if(status.intValue == 9000) {
        [self dealWithBaiHuaHuaResult:YES];
    } else if(status.intValue == 6001){
        [self dealWithBaiHuaHuaResult:NO];
    } else if(status.intValue == 4000) {
        [self dealWithBaiHuaHuaResult:NO];
    }
}


#pragma mark - HXSWechatPayDelegate

- (void)wechatPayCallBack:(HXSWechatPayStatus)status message:(NSString *)message result:(NSDictionary *)result
{
    if (HXSWechatPayStatusSuccess == status) {
        [self dealWithBaiHuaHuaResult:YES];
    } else {
        [self dealWithBaiHuaHuaResult:NO];
    }
}


#pragma mark - Baihuahua Methods

- (void)payOrderWith:(HXSOrderPayType)payType withErrorMessage:(NSString *)errorMessageStr
{
    switch (payType) {
        case kHXSOrderPayTypeCreditCard:
        {
            HXSOrderItem *itemEntity = [[self.orderInfo items] firstObject];
            NSString *titleStr                = itemEntity.name;
            
            HXSCreditPayOrderInfo *order = [[HXSCreditPayOrderInfo alloc] init];
            if (kHXSOrderInfoInstallmentNO == [self.orderInfo.installmentIntNum integerValue]) {
                order.tradeTypeIntNum        = [NSNumber numberWithInteger:kHXStradeTypeNormal];
                order.periodsIntNum          = [NSNumber numberWithInteger:1];
            } else {
                order.tradeTypeIntNum        = [NSNumber numberWithInteger:kHXStradeTypeInstallment];
                order.periodsIntNum          = self.orderInfo.installmentNumIntNum;
            }
            order.orderSnStr             = [NSString stringWithFormat:@"%@", self.orderInfo.order_sn];
            order.orderTypeIntNum        = [NSNumber numberWithInteger:self.orderInfo.type];
            order.amountFloatNum         = self.orderInfo.order_amount;
            order.discountFloatNum       = self.orderInfo.discount;
            order.orderDescriptionStr    = titleStr;
            order.callBackUrlStr         = self.orderInfo.attach;
            
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
                        NSTimeInterval timeInterval = 1.5f;
                        [MBProgressHUD showInViewWithoutIndicator:self.view
                                                           status:message
                                                       afterDelay:timeInterval];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf dealWithBaiHuaHuaResult:NO];
                        });
                        
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
    HXSDigitalMobileResultViewController *result = [[HXSDigitalMobileResultViewController alloc] init];
    [result initDataWithOrderInfo:self.orderInfo success:hasPaid];
    
    NSMutableArray *controllerList = [[NSMutableArray alloc] init];
    [controllerList addObject:self.navigationController.viewControllers[0]];
    [controllerList addObject:self.navigationController.viewControllers[1]];
    [controllerList addObject:result];
    
    [self.navigationController setViewControllers:controllerList animated:YES];
}


#pragma mark - 花不完

- (IBAction)goToCreditViewController:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - 我的订单

- (IBAction)showMyOrders:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HXSMyOrdersViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"HXSMyOrdersViewController"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end

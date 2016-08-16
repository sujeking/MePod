//
//  HXSDigitalMobileResultViewController.m
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileResultViewController.h"
#import "HXSMyOrdersViewController.h"

@interface HXSDigitalMobileResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *statusLable;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UILabel *orderAmount;
@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *successOrderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *successOrderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentType;

@property (weak, nonatomic) IBOutlet UIView *paySuccessInfoView;
@property (weak, nonatomic) IBOutlet UIView *payFailInfoView;

@property (nonatomic) BOOL isSuccess;
@property (nonatomic, strong) HXSOrderInfo *orderInfo;

@end

@implementation HXSDigitalMobileResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"结算";
    
    [self initView];
}

- (void)initView
{
    if (self.isSuccess) {
        self.statusImage.image = [UIImage imageNamed:@"ic_paysuccess"];
        self.statusLable.text = @"支付成功";
        self.paySuccessInfoView.hidden = NO;
        self.payFailInfoView.hidden = YES;
        
        switch (self.orderInfo.paytype) {
            case kHXSOrderPayTypeCash:
                self.paymentType.text = @"现金";
                break;
            case kHXSOrderPayTypeZhifu:
                self.paymentType.text = @"支付宝";
                break;
            case kHXSOrderPayTypeWechatApp:
                self.paymentType.text = @"微信";
                break;
            case kHXSOrderPayTypeCreditCard:
                self.paymentType.text = @"59钱包";
                break;
            default:
                break;
        }
        
        self.successOrderIdLabel.text = self.orderInfo.order_sn;
        self.successOrderTimeLabel.text = [self getDateString:[self.orderInfo.add_time longValue]];
    } else {
        self.statusImage.image = [UIImage imageNamed:@"ic_payfailed"];
        self.statusLable.text = @"支付失败";
        self.paySuccessInfoView.hidden = YES;
        self.payFailInfoView.hidden = NO;
        
        self.orderId.text = self.orderInfo.order_sn;
        self.orderTime.text = [self getDateString:[self.orderInfo.add_time longValue]];
    }
    
    if ([self.orderInfo.installmentIntNum boolValue]) {
        self.orderName.text = @"分期首付";
        self.orderAmount.text = [NSString stringWithFormat:@"￥%0.2f",[self.orderInfo.downPaymentFloatNum floatValue]];
    }else {
        self.orderName.text = @"分期商城订单";
        self.orderAmount.text = [NSString stringWithFormat:@"￥%0.2f",[self.orderInfo.order_amount floatValue]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDataWithOrderInfo:(HXSOrderInfo *)orderInfo success:(BOOL)isSuccess
{
    self.isSuccess = isSuccess;
    self.orderInfo = [[HXSOrderInfo alloc] init];
    self.orderInfo.paytype = orderInfo.paytype;
    self.orderInfo.installmentIntNum = orderInfo.installmentIntNum;
    self.orderInfo.downPaymentFloatNum = orderInfo.downPaymentFloatNum;
    self.orderInfo.order_amount = orderInfo.order_amount;
    self.orderInfo.order_sn = orderInfo.order_sn;
    self.orderInfo.add_time = orderInfo.add_time;
}

- (NSString *)getDateString:(long)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [dateFormatter stringFromDate:date];
}


#pragma mark - actions

- (IBAction)goToCreditViewController:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)showOrders:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HXSMyOrdersViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"HXSMyOrdersViewController"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)dealloc
{
    
}
@end

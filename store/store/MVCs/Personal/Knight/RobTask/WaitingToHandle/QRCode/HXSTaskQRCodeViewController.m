//
//  HXSTaskQRCodeViewController.m
//  store
//
//  Created by 格格 on 16/4/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTaskQRCodeViewController.h"
#import "UIImage+Extension.h"
#import "HXSQRCoder.h"
#import "HXSQRModel.h"
#import "HXSQRCodeEntity.h"

@interface HXSTaskQRCodeViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *shopImageView; // 店铺头像
@property (nonatomic, weak) IBOutlet UILabel *shopNameLabel; // 店铺名称
@property (nonatomic, weak) IBOutlet UILabel *orderNumLabel; // 订单号
@property (nonatomic, weak) IBOutlet UIImageView *qrCodeIamgeView; // 二维码头像
@property (nonatomic, weak) IBOutlet UIView *contianterView;

@property (nonatomic, strong) HXSTaskOrder *taskOrder;
@property (nonatomic, strong) HXSQRCodeEntity *qrCodeEntity;
@end

@implementation HXSTaskQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialNav];
    [self initialPrama];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadQRCodeEntity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setter
- (void)setQrCodeEntity:(HXSQRCodeEntity *)qrCodeEntity{
    _qrCodeEntity = qrCodeEntity;
    UIImage *QRImage = [self cteateQRCodeImageWithSoure:qrCodeEntity.codeStr];
    [self.qrCodeIamgeView setImage:QRImage];
    
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:qrCodeEntity.shopLogoStr] placeholderImage:[UIImage imageNamed:@"ic_shop_logo"]];
    _shopNameLabel.text = qrCodeEntity.shopNameStr;
    _orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",qrCodeEntity.orderIdStr];
}

#pragma mark - webService
- (void)loadQRCodeEntity{
    
    [MBProgressHUD showInView:self.view];
     __weak typeof (self) weakSelf = self;
    
    [HXSQRModel knightDelverlyOrderCodeWithDeliveryOrderId:self.taskOrder.deliveryOrderIdStr
                                                   orderId:self.taskOrder.orderSnStr
                                                    shopId:self.taskOrder.shopIdLongNum complete:^(HXSErrorCode code, NSString *message, HXSQRCodeEntity *codeEntity) {
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        if(kHXSNoError == code){
                                                            weakSelf.qrCodeEntity = codeEntity;
                                                        }else{
                                                            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                                            weakSelf.contianterView.hidden = YES;
                                                        }
        
    }];
}

#pragma mark - initial
- (void)initialNav{
    self.navigationItem.title = @"订单二维码";
}

- (void)initialPrama{
    
    _shopImageView.layer.cornerRadius = 4;
    _shopImageView.layer.borderColor = [UIColor colorWithRGBHex:0xe1e2e3].CGColor;
    _shopImageView.layer.borderWidth = 1;
    _shopImageView.layer.masksToBounds = YES;
    
    self.orderNumLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setTaskOrderEntity:(HXSTaskOrder *)taskOrder{
    self.taskOrder = taskOrder;
}

#pragma mark - 
- (UIImage *)cteateQRCodeImageWithSoure:(NSString *)source{
    
    //使用iOS 7后的CIFilter对象操作，生成二维码图片imgQRCode（会拉伸图片，比较模糊，效果不佳）
    CIImage *imgQRCode = [HXSQRCoder createQRCodeImage:source];
    UIImage *imgAdaptiveQRCode = [HXSQRCoder resizeQRCodeImage:imgQRCode withSize:255];
    UIImage *imgIcon = [UIImage createRoundedRectImage:[UIImage imageNamed:@"AppIcon"]
                                              withSize:CGSizeMake(70, 70)
                                            withRadius:10];
    imgAdaptiveQRCode = [HXSQRCoder addIconToQRCodeImage:imgAdaptiveQRCode
                                             withIcon:imgIcon
                                         withIconSize:imgIcon.size];
    return imgAdaptiveQRCode;
}



@end

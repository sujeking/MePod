//
//  HXSDigitalMobileConfirmOrderViewController.m
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileConfirmOrderViewController.h"

// Controllers
#import "HXSDigitalMobileOrderingViewController.h"
#import "HXSUpgradeCreditViewController.h"
#import "HXSDigitalMobileInstallmentAgreementViewController.h"
#import "HXSDigitalMobileOrderingInstallmentViewController.h"
#import "HXSDigitalMobileAddressViewController.h"
#import "HXSDigitalMobileInstallmentDetailViewController.h"
#import "HXSSubscribeViewController.h"
#import "HXSBindTelephoneController.h"
#import "HXSDormEditRemarksViewController.h"
#import "HXSCouponViewController.h"

// Model
#import "HXSDigitalMobileParamEntity.h"
#import "HXSDigitalMobileAddressEntity.h"
#import "HXSSettingsManager.h"
#import "HXSConfirmOrderEntity.h"
#import "HXSAddressViewModel.h"
#import "HXSDownpaymentEntity.h"
#import "HXSConfirmOrderModel.h"

// Views
#import "HXSNonAddressInfoView.h"
#import "HXSAddressInfoView.h"
#import "HXSOrderDetailInfoView.h"


static NSInteger const kNonAddressViewHeight =   44;
static NSInteger const kAddressViewHeight    =   86;
static NSInteger const kOrderDetailViewHeight =  368;

@interface HXSDigitalMobileConfirmOrderViewController ()<HXSCouponViewControllerDelegate,
                                                         HXSAddressControllerDelegate,
                                                         HXSSelectInstallmentDetailDelegate,
                                                         HXSAddAddressInfoDelegate,
                                                         HXSEditAddressInfoDelegate,
                                                         HXSAddressDetailInfoDelegate,
                                                         DigitalMobileInstallmentAgreementDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *container;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) HXSNonAddressInfoView *nonAddressView;
@property (nonatomic, strong) HXSAddressInfoView *addressView;
@property (nonatomic, strong) HXSOrderDetailInfoView *orderDetailView;

@property (nonatomic, strong) HXSAddressViewModel *addressModel;
@property (nonatomic, strong) HXSConfirmOrderModel *confirmOrderModel;
@property (nonatomic, strong) HXSConfirmOrderEntity *confirmOrderEntity;

@property (nonatomic, strong) NSArray *addressInfoList;

@property (weak, nonatomic) IBOutlet UILabel *totalAccountLabel;

@end

@implementation HXSDigitalMobileConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"确认订单";
    
    [self initConfirmOrderView];
    [self initCommitButton];
    
    [self.orderDetailView initOrderDetailInfo:self.confirmOrderEntity];
    [self initTotalAccountLabel];
    [self getUserAddressInfo];
}

- (void)getUserAddressInfo
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    [self.addressModel fetchAddressWithComplete:^(HXSErrorCode code, NSString *message, HXSAddressEntity *addressInfo) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (kHXSNoError == code) {
            if (addressInfo !=nil) {
                weakSelf.confirmOrderEntity.addressInfo = addressInfo;
                [weakSelf addNewAddressInfo];
                [weakSelf updateAddressInfo];
                [weakSelf checkGoodsStock];
            }
            
        }else {
            
        }
    }];
}

- (void)checkGoodsStock
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    [self.confirmOrderModel checkGoodsStockWithGoodsId:self.confirmOrderEntity.goodsId andAddressCode:[self.confirmOrderEntity.addressInfo getAddressCode] Complete:^(HXSErrorCode code, NSString *message, NSDictionary *stockInfo) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (kHXSNoError == code) {
            BOOL isHaveStock = [[stockInfo valueForKey:@"stock"] boolValue];
            if (!isHaveStock) {
                self.commitButton.enabled = NO;
                HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒" message:@"抱歉！您选择的地区暂时没有库存" leftButtonTitle:@"确定" rightButtonTitles:nil];
                [alertView show];
            }else {
                self.commitButton.enabled = YES;
            }
        }
    }];
}

- (void)creatOrder
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    [self.confirmOrderModel creaeOrderWithOrderInfo:self.confirmOrderEntity Complete:^(HXSErrorCode code, NSString *message, HXSOrderInfo *orderInfo) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (kHXSNoError == code) {
            
            [[HXSUserAccount currentAccount].userInfo updateUserInfo];
            
            // save type of order
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:kHXSOrderTypeInstallment] forKey:USER_DEFAULT_LATEST_ORDER_TYPE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (self.confirmOrderEntity.isInstallment.boolValue) {
                
                HXSDigitalMobileOrderingInstallmentViewController *digitalMobileOrderingInstallmentViewController = [[HXSDigitalMobileOrderingInstallmentViewController alloc] init];
                digitalMobileOrderingInstallmentViewController.orderInfo = orderInfo;
                digitalMobileOrderingInstallmentViewController.confirmOrderEntity = self.confirmOrderEntity;
                
                NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
                [viewControllers addObject:self.navigationController.viewControllers[0]];
                [viewControllers addObject:self.navigationController.viewControllers[1]];
                [viewControllers addObject:digitalMobileOrderingInstallmentViewController];
                [self.navigationController setViewControllers:viewControllers animated:YES];
                
            } else {
                
                HXSDigitalMobileOrderingViewController *digitalMobileOrderingViewController = [[HXSDigitalMobileOrderingViewController alloc] init];
                digitalMobileOrderingViewController.orderInfo = orderInfo;
                
                NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
                [viewControllers addObject:self.navigationController.viewControllers[0]];
                [viewControllers addObject:self.navigationController.viewControllers[1]];
                [viewControllers addObject:digitalMobileOrderingViewController];
                [self.navigationController setViewControllers:viewControllers animated:YES];
            }
            
        }else {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒" message:message leftButtonTitle:@"确定" rightButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.confirmOrderEntity.remark = [[HXSSettingsManager sharedInstance] getRemarks];
    self.orderDetailView.remark.text = self.confirmOrderEntity.remark;
    [self updateAddressInfo];
    
    // 设置分期设置显示 3种
    [self initInstallmentTip];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initConfirmOrderView {
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNonAddressViewHeight + kOrderDetailViewHeight)];
    [self.container addSubview:self.contentView];
    self.container.contentSize = self.contentView.frame.size;
    
    self.nonAddressView = [[[NSBundle mainBundle] loadNibNamed:@"HXSNonAddressInfoView" owner:nil options:nil] firstObject];
    self.nonAddressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kNonAddressViewHeight);
    self.nonAddressView.delegate = self;
    
    self.orderDetailView = [[[NSBundle mainBundle] loadNibNamed:@"HXSOrderDetailInfoView" owner:nil options:nil] firstObject];
    self.orderDetailView.frame = CGRectMake(0, self.nonAddressView.frame.size.height, SCREEN_WIDTH, kOrderDetailViewHeight);
    self.orderDetailView.delegate = self;
    
    [self.contentView addSubview:self.nonAddressView];
    [self.contentView addSubview:self.orderDetailView];

}

- (void)initCommitButton
{
    [self.commitButton setTitle:@"暂无库存" forState:UIControlStateDisabled];
    [self.commitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    
    [self.commitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0xE1E2E3]] forState:UIControlStateDisabled];
    [self.commitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0xF9A502]] forState:UIControlStateNormal];
    self.commitButton.enabled = YES;
}

- (void)initData:(HXSDigitalMobileParamSKUEntity *)paramSKUEnity andAddressInfo:(NSArray *)addressInfo
{
    self.addressInfoList = addressInfo;
    self.confirmOrderEntity = [[HXSConfirmOrderEntity alloc] init];
    
    // 商品属性
    self.confirmOrderEntity.goodsId = paramSKUEnity.skuIDIntNum;
    self.confirmOrderEntity.goodsName = paramSKUEnity.nameStr;
    self.confirmOrderEntity.goodsImageUrl = paramSKUEnity.skuImageURLStr;
    self.confirmOrderEntity.goodsPrice = paramSKUEnity.priceFloatNum;
    self.confirmOrderEntity.goodsNum = @1;
    self.confirmOrderEntity.total = [NSNumber numberWithFloat:self.confirmOrderEntity.goodsPrice.floatValue * self.confirmOrderEntity.goodsNum.integerValue];
    
    self.confirmOrderEntity.goodsProperty = [self getPropertyName:paramSKUEnity.propertiesArr];
    self.confirmOrderEntity.goodsService = @"";
    self.confirmOrderEntity.carriage = @0;
    
    // 初始化省市区地址信息
    [self initAddressEntityWith:addressInfo];
}

- (void)initAddressEntityWith:(NSArray *)addressInfo
{
    if (self.confirmOrderEntity.addressInfo == nil) {
        self.confirmOrderEntity.addressInfo = [[HXSAddressEntity alloc] init];
    }
    
    // 地址信息
    HXSDigitalMobileAddressEntity *provinceEntity = (HXSDigitalMobileAddressEntity *)addressInfo[0];
    HXSDigitalMobileCityAddressEntity *cityEntity = (HXSDigitalMobileCityAddressEntity *)addressInfo[1];
    HXSDigitalMobileCountryAddressEntity *countyEntity = (HXSDigitalMobileCountryAddressEntity *)addressInfo[2];
    
    self.confirmOrderEntity.addressInfo.province = provinceEntity.provinceNameStr;
    self.confirmOrderEntity.addressInfo.provinceId = provinceEntity.provinceIDIntNum;
    self.confirmOrderEntity.addressInfo.city = cityEntity.cityNameStr;
    self.confirmOrderEntity.addressInfo.cityId = cityEntity.cityIDIntNum;
    self.confirmOrderEntity.addressInfo.county = countyEntity.countryNameStr;
    self.confirmOrderEntity.addressInfo.countyId = countyEntity.countryIDIntNum;
}

- (NSString *)getPropertyName:(NSArray *)propertyList
{
    NSMutableArray * propertyNames = [[NSMutableArray alloc] init];
    for (HXSDigitalMobileParamSKUPropertyEntity * property in propertyList) {
        [propertyNames addObject:property.valueNameStr];
    }
    
    return [propertyNames componentsJoinedByString:@","];
}

- (void)initTotalAccountLabel
{
    self.totalAccountLabel.text = [NSString stringWithFormat:@"￥%0.2f",[[self.confirmOrderEntity getToTalAccount] floatValue]];
}

- (void)initInstallmentInfo
{
    if (self.confirmOrderEntity.installmentInfo == nil) {
        self.orderDetailView.downPayment.text = @"";
        self.orderDetailView.monthPayments.text = @"";
        self.orderDetailView.installmentTime.text = @"";
    }else {
        self.orderDetailView.downPayment.text = [NSString stringWithFormat:@"￥%0.2f",[self.confirmOrderEntity.installmentInfo.downpayment.percent floatValue] * [self.confirmOrderEntity.installmentInfo.spend floatValue]];
        self.orderDetailView.monthPayments.text = [NSString stringWithFormat:@"￥%0.2f",self.confirmOrderEntity.installmentInfo.installment.installmentMoney.floatValue];
        self.orderDetailView.installmentTime.text = [NSString stringWithFormat:@"%i个月",self.confirmOrderEntity.installmentInfo.installment.installmentNum.intValue];
        
        self.orderDetailView.installmentPayment.text = [NSString stringWithFormat:@"￥%0.2f/期",[self.confirmOrderEntity.installmentInfo.installment.chargeMoney floatValue]];
    }
    
}

- (void)initInstallmentTip
{
    HXSUserInfo * userInfo = [[HXSUserAccount currentAccount] userInfo];
    
    int status = userInfo.creditCardInfo.accountStatusIntNum.intValue;
    CGFloat availableInstallmentDoubleNum = [userInfo.creditCardInfo.availableInstallmentDoubleNum floatValue];
    
    if (kHXSCreditAccountStatusOpened == status) {
        self.orderDetailView.installSwitch.hidden = NO;
        
        if (availableInstallmentDoubleNum > [[self.confirmOrderEntity getToTalAccount] floatValue]) {
            
            // 订单金额小于200，关闭分期开关
            if ([[self.confirmOrderEntity getToTalAccount] floatValue] > 200) {
                self.orderDetailView.installSwitch.enabled = YES;
            } else {
                self.orderDetailView.installSwitch.enabled = NO;
            }
        } else {
            self.orderDetailView.installSwitch.enabled = NO;
        }
        
        if (self.orderDetailView.installSwitch.enabled) {
            self.orderDetailView.installmentTipButton.userInteractionEnabled = NO;
        }else {
            self.orderDetailView.installmentTipButton.userInteractionEnabled = YES;
        }
    }else if (status == kHXSCreditAccountStatusNotOpen) {
        
        self.orderDetailView.moreInfoForInstallment.hidden = NO;
        self.orderDetailView.installmentArrowIcon.hidden = NO;
        self.orderDetailView.creditCardInfoButton.userInteractionEnabled = YES;
    } else {
        
        self.orderDetailView.noInstallmentLabel.hidden = NO;
    }

}

// 添加联系地址，刷新视图
- (void)addNewAddressInfo
{
    [self.nonAddressView removeFromSuperview];
    
    self.addressView = [[[NSBundle mainBundle] loadNibNamed:@"HXSAddressInfoView" owner:nil options:nil] firstObject];
    self.addressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kAddressViewHeight);
    self.addressView.delegate = self;
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kAddressViewHeight + kOrderDetailViewHeight);
    self.container.contentSize = self.contentView.frame.size;
    [self.contentView addSubview:self.addressView];
    self.orderDetailView.frame = CGRectMake(0, self.addressView.frame.size.height, SCREEN_WIDTH, kOrderDetailViewHeight);
}

// 刷新新联系地址视图
- (void)updateAddressInfo
{
    [self.addressView initBuyerInfo:self.confirmOrderEntity.addressInfo];
}

- (void)addRemark
{
    HXSDormEditRemarksViewController *editRemarksViewController = [[HXSDormEditRemarksViewController alloc] init];
    [self.navigationController pushViewController:editRemarksViewController animated:YES];
}

- (void)addAddress
{
    HXSDigitalMobileAddressViewController *addressController = [[HXSDigitalMobileAddressViewController alloc] init];
    addressController.delegate = self;
    [addressController initData:self.confirmOrderEntity.addressInfo];
    [self.navigationController pushViewController:addressController animated:YES];
}

- (void)showCoupon
{
    HXSCouponViewController * couponViewController = [[HXSCouponViewController alloc] init];
    couponViewController.delegate = self;
    [self.navigationController pushViewController:couponViewController animated:YES];
}

- (void)addMoreInfoForInstallment;
{
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    if (kHXSCreditAccountStatusNotOpen == [creditCardInfo.accountStatusIntNum intValue]) {
        // 立即开通
        [self jumpToApplyCreditVC];
    } else {
        // 提升额度
        [self jumpToImproveQuota];
    }
}

- (void)changeInstallment:(UISwitch *)switchView
{
    self.confirmOrderEntity.isInstallment = [NSNumber numberWithBool:NO];
    if (switchView.on) {
        [self selectInstallmentDetail];
        switchView.on = NO;
    }else {
        self.orderDetailView.installInfoView.hidden = YES;
        self.confirmOrderEntity.installmentInfo = nil;
    }
}

- (void)selectInstallmentDetail
{
    HXSDigitalMobileInstallmentDetailViewController *digitalMobileInstallmentDetailViewController=[[HXSDigitalMobileInstallmentDetailViewController alloc] init];
    digitalMobileInstallmentDetailViewController.delegate = self;
    
    [digitalMobileInstallmentDetailViewController initDigitalMobileInstallmentDetailEntity:self.confirmOrderEntity];
    [self.navigationController pushViewController:digitalMobileInstallmentDetailViewController animated:YES];
}


#pragma mark - Jump To VC

- (void)jumpToApplyCreditVC
{
    // Must bind telephone at first
    BOOL hasPayPasswd = [[HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity.havePasswordIntNum boolValue];
    HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;
    if ((!hasPayPasswd) && (basicInfo.phone.length < 1)) {
        [self displayBindTelephoneNumberView];
        
        return;
    }
    
    // apply credit card
    HXSSubscribeViewController *subscribeVC = [HXSSubscribeViewController createSubscribeVC];
    
    [self.navigationController pushViewController:subscribeVC animated:YES];
}

- (void)displayBindTelephoneNumberView
{
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                      message:@"您还未绑定过手机，请先去绑定。"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"去绑定"];
    alertView.rightBtnBlock = ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalInfo"
                                                             bundle:[NSBundle mainBundle]];
        
        HXSBindTelephoneController *telephoneVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSBindTelephoneController"];;
        
        [self.navigationController pushViewController:telephoneVC animated:YES];
    };
    
    [alertView show];
}

- (void)jumpToImproveQuota
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    HXSUpgradeCreditViewController *upgradeVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HXSUpgradeCreditViewController class])];
    [self.navigationController pushViewController:upgradeVC animated:YES];
}

#pragma mark - HXSAddAddressInfoDelegate

- (void)gotoAddAddressViewcontroller
{
    [self addAddress];
}

#pragma mark - HXSEditAddressInfoDelegate

- (void)gotoEditAddressViewcontroller
{
    HXSDigitalMobileAddressViewController *addressController = [[HXSDigitalMobileAddressViewController alloc] init];
    addressController.delegate = self;
    [addressController initData:self.confirmOrderEntity.addressInfo];
    [self.navigationController pushViewController:addressController animated:YES];
}

#pragma mark - HXSAddressDetailInfoDelegate

- (void)addRemarkAction
{
    [self addRemark];
}

- (void)showCouponAction
{
    [self showCoupon];
}

- (void)addMoreInfoForInstallmentAction
{
    [self addMoreInfoForInstallment];
}

- (void)changeInstallmentAction:(UISwitch *)switchView
{
    [self changeInstallment:switchView];
}

- (void)selectInstallmentDetailAction
{
    [self selectInstallmentDetail];
}

- (void)showInstallmentTip
{
    NSString *messageStr = nil;
    
    HXSUserInfo * userInfo = [[HXSUserAccount currentAccount] userInfo];
    CGFloat availableInstallmentDoubleNum = [userInfo.creditCardInfo.availableInstallmentDoubleNum floatValue];
    CGFloat totalAccountFloatNum = [[self.confirmOrderEntity getToTalAccount] floatValue];
        
    if (totalAccountFloatNum < availableInstallmentDoubleNum) {
        // 订单金额小于200，关闭分期开关
        if (200.0 > totalAccountFloatNum) {
            messageStr = @"抱歉，200元以下商品不可以分期";
        }
    } else {
        messageStr = @"抱歉！您的分期金额不足，不能进行分期。";
    }

    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒"
                                                                      message:messageStr
                                                              leftButtonTitle:@"确定"
                                                            rightButtonTitles:nil];
    [alertView show];
}

#pragma mark - HXSCouponViewControllerDelegate

- (void)didSelectCoupon:(HXSCoupon *)coupon
{
    self.confirmOrderEntity.coupon = coupon;
    self.orderDetailView.coupon.text = [NSString stringWithFormat:@"-￥%@",coupon.discount];
    
    [self initTotalAccountLabel];
}

#pragma mark - HXSAddressControllerDelegate

- (void)didSaveAddress:(HXSAddressEntity *)addressInfo
{
    [self addNewAddressInfo];
    self.confirmOrderEntity.addressInfo = addressInfo;
    [self updateAddressInfo];
    [self checkGoodsStock];
}

#pragma mark - HXSSelectInstallmentDetailDelegate

- (void)didSelectInstallmentDetail:(HXSDigitalMobileInstallmentDetailEntity *)digitalMobileInstallmentDetail
{
    self.confirmOrderEntity.installmentInfo = digitalMobileInstallmentDetail;
    [self initInstallmentInfo];
    self.orderDetailView.installInfoView.hidden = NO;
    self.orderDetailView.installSwitch.on = YES;
    self.confirmOrderEntity.isInstallment = [NSNumber numberWithBool:YES];
}

#pragma mark - Setter Getter Methods

- (HXSAddressViewModel *)addressModel
{
    if (nil == _addressModel) {
        _addressModel = [[HXSAddressViewModel alloc] init];
    }
    
    return _addressModel;
}

- (HXSConfirmOrderModel *)confirmOrderModel
{
    if (nil == _confirmOrderModel) {
        _confirmOrderModel = [[HXSConfirmOrderModel alloc] init];
    }
    
    return _confirmOrderModel;
}

#pragma mark - 提交订单

- (IBAction)commitOrder:(id)sender
{
    // 订单数据完整性校验
    if (![self checkOrderInfo]) {
        return;
    }
    
    if (self.confirmOrderEntity.isInstallment.boolValue) {
        HXSDigitalMobileInstallmentAgreementViewController *agreement = [[HXSDigitalMobileInstallmentAgreementViewController alloc] init];
        agreement.delegate = self;
        [self.navigationController pushViewController:agreement animated:YES];
    }else {
        [self creatOrder];
    }
}

- (BOOL)checkOrderInfo
{
    BOOL isInfoComplete = YES;
    
    if (self.confirmOrderEntity.addressInfo.name.length == 0) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请添加收货地址" afterDelay:1.0f];
        return NO;
    }
    
    if ([self.confirmOrderEntity.isInstallment boolValue]) {
        if (self.confirmOrderEntity.installmentInfo == nil) {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请选择分期" afterDelay:1.0f];
            return NO;
        }
    }
    
    return isInfoComplete;
}

#pragma mark - DigitalMobileInstallmentAgreementDelegate

- (void)didPassPWD
{
    [self creatOrder];
}

@end

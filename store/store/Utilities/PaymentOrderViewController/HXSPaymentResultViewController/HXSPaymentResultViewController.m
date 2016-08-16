//
//  HXSPaymentResultViewController.m
//  store
//
//  Created by ArthurWang on 16/5/12.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSPaymentResultViewController.h"
#import "HXSUtilities.h"

// Controllers
#import "HXSPrintOrderDetailViewController.h"
#import "HXSMyOrderDetailViewController.h"
#import "HXSBoxOrderViewController.h"
#import "HXSWebViewController.h"
#import "HXSPaymentResultViewController.h"
#import "HXSApplyBoxInfoViewController.h"
#import "HXSApplyBoxViewController.h"


// Model

// Views
#import "HXSOrderActivityInfoView.h"
#import "HXSBannerView.h"
#import "HXSLineView.h"

// Others
#import "NSString+HXSOrderPayType.h"
#import "HXSShopManager.h"


@interface HXSPaymentResultViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;          // view 相当于 scrollview的contentview
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *mainViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *myOrderBtn;
@property (weak, nonatomic) IBOutlet HXSLineView *centerLineView;
@property (weak, nonatomic) IBOutlet UIView *recommendContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *recommendImageView;
@property (weak, nonatomic) IBOutlet HXSLineView *bottomLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineToOrderTimeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recommendBottomConstraint;

@property (nonatomic, strong) HXSOrderActivityInfoView *activityInfoView;
@property (nonatomic, strong) HXSBannerView *bannerView;

@property (nonatomic, assign) BOOL hasShowLoginAlert;

@property (nonatomic, assign) BOOL result;
@property (nonatomic, strong) HXSOrderInfo *orderInfo;

@end

@implementation HXSPaymentResultViewController


#pragma mark - UIViewController Lifecyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hasShowLoginAlert = NO;
    
    [self initialNavigationBar];
    
    [self initialRecommendContainerView];
    
    [self initialResultView];
    
    [self updateRecommendViewVisibility];
    
    [self initialBannerView];
    
    [self showShareInfos];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // login
    if (![HXSUserAccount currentAccount].isLogin
        && !self.hasShowLoginAlert) {
        HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                          message:@"登陆后下单，可获得积分哦~"
                                                                  leftButtonTitle:@"取消"
                                                                rightButtonTitles:@"登录"];
        [alertView setRightBtnBlock:^() {
            [[AppDelegate sharedDelegate].rootViewController checkIsLoggedin];
        }];
        
        [alertView show];
        
        self.hasShowLoginAlert = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.orderInfo        = nil;
    self.activityInfoView = nil;
    self.bannerView       = nil;
}


#pragma mark - Public Methods

+ (instancetype)createPaymentResultVCWithOrderInfo:(HXSOrderInfo *)orderInfo result:(BOOL)result
{
    HXSPaymentResultViewController *paymentResultVC = [HXSPaymentResultViewController controllerFromXib];
    
    paymentResultVC.orderInfo = orderInfo;
    paymentResultVC.result    = result;
    
    return paymentResultVC;
}


#pragma mark - Override

- (void)back
{
    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_PAYMENT_RESULT_GO_BACK parameter:@{@"business_type":self.orderInfo.typeName,@"type":self.result?@"成功":@"失败"}];
    
    [super back];
}

#pragma mark  - private Methods

- (void)backToMainView{
    if([[AppDelegate sharedDelegate].rootViewController isKindOfClass:[UITabBarController class]]){
        
        UITabBarController *tabBarController = [AppDelegate sharedDelegate].rootViewController;
        
        if(tabBarController.viewControllers.count > 0&&tabBarController.selectedIndex != 0){
            UIViewController *firstController = [tabBarController.viewControllers objectAtIndex:0];
            if([firstController isKindOfClass:[UINavigationController class]]){
                [(UINavigationController *)firstController popToRootViewControllerAnimated:NO];
            }
            [self.navigationController popToRootViewControllerAnimated:NO];
            [(UITabBarController *)[AppDelegate sharedDelegate].rootViewController setSelectedIndex:0];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.title = @"结算";
    self.navigationItem.title = @"结算";
}


- (void)initialResultView
{
    // 订单价格，订单号，订单时间，支付方式
    self.orderTitleLabel.text = [NSString stringWithFormat:@"%@订单", self.orderInfo.typeName];
    
    self.orderAmountLabel.text = [NSString stringWithFormat:@"￥%.02f",[self.orderInfo.order_amount floatValue]];
    
    self.orderNumberLabel.text = self.orderInfo.order_sn;
    
    if (nil == self.orderInfo.add_time) {
        self.orderTimeLabel.text = @"无";
    } else {
        self.orderTimeLabel.text = [NSDate stringFromSecondsSince1970:[self.orderInfo.add_time longLongValue] format:@"YYYY-MM-dd HH:mm:ss"];
    }
    
    
    self.payMethodLabel.text = [NSString stringWithFormat:@"%@", [self.orderInfo getPayType]];
    
    if (self.result) {
        self.resultImageView.image = [UIImage imageNamed:@"ic_paysuccess"];
        self.resultLabel.text = @"付款成功";
        self.resultLabel.textColor = [UIColor colorWithR:7 G:169 B:250 A:1.0];
        self.centerLineView.hidden = NO;

    } else {
        
        [HXSUsageManager trackEvent:HXS_USAGE_EVENT_CHECKOUT_FIELD_MY_ORDER parameter:@{@"business_type":self.orderInfo.typeName}];
        self.resultImageView.image = [UIImage imageNamed:@"ic_payfailed"];
        self.resultLabel.text = @"付款失败";
        self.resultLabel.textColor = [UIColor colorWithR:251 G:108 B:66 A:1.0];
        self.centerLineView.hidden = YES;
        [self.payTitleLabel removeFromSuperview];
        [self.payMethodLabel removeFromSuperview];
        [self.mainViewBtn removeFromSuperview];
        self.lineToOrderTimeHeight.constant = 20;
        
        [self.myOrderBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
        }];
        
        [self.view layoutIfNeeded];
    }
    
    [self.mainViewBtn addTarget:self
                         action:@selector(onClickMainPageBtn:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.myOrderBtn addTarget:self
                        action:@selector(onClickMyOrderBtn:)
              forControlEvents:UIControlEventTouchUpInside];
    
    return;

}

- (void)initialRecommendContainerView
{
    self.recommendContainerView.layer.masksToBounds = YES;
    self.recommendContainerView.layer.cornerRadius = 3.0;
    self.recommendContainerView.hidden = YES;
}

- (void)initialBannerView
{
    // If result is NO, don't display the bannber view.
    if (!self.result) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.bannerView.loadBannerComplete = ^(void){
        [weakSelf.contentView removeConstraint:weakSelf.recommendBottomConstraint];
        
        [weakSelf.contentView addSubview:weakSelf.bannerView];
        
        [weakSelf updateRecommendLayout];
    };
    
    self.bannerView.didSelectedBanner = ^(HXSStoreAppEntryEntity *entity) {
        HXSWebViewController * webViewController = [HXSWebViewController controllerFromXib];
        [webViewController setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",entity.linkURLStr]]];
        webViewController.title = entity.titleStr;
        [weakSelf.navigationController pushViewController:webViewController animated:YES];
    };
}

- (void)showShareInfos
{
    [_activityInfoView showActivityInfos:self.orderInfo.activityInfos inView:self.view];
}


#pragma mark - Target Methods

- (void)onClickMainPageBtn:(UIButton *)button
{
    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_CHECKOUT_SUCCESS_CONTINUE_SHOPPING parameter:@{@"business_type":self.orderInfo.typeName}];
    [self backToMainView];
}

- (void)onClickMyOrderBtn:(UIButton *)button
{
    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_CHECKOUT_SUCCESS_MY_ORDER parameter:@{@"business_type":self.orderInfo.typeName}];
    switch (self.orderInfo.type) {
        case kHXSOrderTypeDorm:
        {
            HXSMyOrderDetailViewController *orderDetailViewController = [HXSMyOrderDetailViewController controllerFromXib];
            orderDetailViewController.order = self.orderInfo;
            
            [self replaceCurrentViewControllerWith:orderDetailViewController animated:YES];
        }
            break;
        case kHXSOrderTypeDrink:
        {
            // Do nothing
        }
            break;
        case kHXSOrderTypePrint:
        {
            HXSPrintOrderDetailViewController *orderDetailViewController = [HXSPrintOrderDetailViewController controllerFromXib];
            orderDetailViewController.orderSNNum = self.orderInfo.order_sn;
            
            [self replaceCurrentViewControllerWith:orderDetailViewController animated:YES];
            
        }
            break;
        case kHXSOrderTypeStore:
        {
            // Do nothing
        }
            break;
            
        case kHXSOrderTypeBox:
        case kHXSOrderTypeNewBox:
        {
            HXSBoxOrderViewController *orderDetailViewController = [HXSBoxOrderViewController controllerFromXib];
            orderDetailViewController.orderSNStr = self.orderInfo.order_sn;
            
            [self replaceCurrentViewControllerWith:orderDetailViewController animated:YES];
        }
            break;
            
        case kHXSOrderTypeEleme:
        {
            // Do nothing
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)cancelRecommend:(id)sender
{
    [[ApplicationSettings instance] setRecommendBoxHidden:YES];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.recommendContainerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.recommendContainerView.hidden = YES;
        
        [self updateRecommendLayout];
    }];
}

- (IBAction)knowAboutBox:(id)sender
{
    HXSApplyBoxViewController *applyBoxVC = [HXSApplyBoxViewController controllerFromXib];
    
    [self.navigationController pushViewController:applyBoxVC animated:YES];
}

- (IBAction)applyBox:(id)sender
{
    HXSApplyBoxInfoViewController *applyBoxInfoVC = [HXSApplyBoxInfoViewController controllerFromXib];
    
    [self.navigationController pushViewController:applyBoxInfoVC animated:YES];
}


#pragma mark - Update Recommend Status

- (void)updateRecommendViewVisibility
{
    if ((self.orderInfo.recommendBoxInfo.recommendImage.length > 0)
        && ![[ApplicationSettings instance] isRecommendBoxHidden]) {
        _recommendContainerView.hidden = NO;
        
        NSString *imageURL = [self.orderInfo.recommendBoxInfo.recommendImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_recommendImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"img_snacksbanner"]];
    }
    else {
        _recommendContainerView.hidden = YES;
    }
}

- (void)updateRecommendLayout
{
    if (self.recommendContainerView.isHidden) {
        [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomLineView.mas_bottom);
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_equalTo(self.bannerView.height);
        }];
    } else {
        [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.recommendContainerView.mas_bottom);
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_equalTo(self.bannerView.height);
        }];
    }
    
    [self.view layoutIfNeeded];
}

#pragma mark - Setter Getter Methods

- (HXSBannerView *)bannerView
{
    if (nil == _bannerView) {
        HXSShopManager *shopManager = [HXSShopManager shareManager];
        HXSLocationManager *locationManager = [HXSLocationManager manager];
        _bannerView = [[HXSBannerView alloc] initWithShopID:shopManager.currentEntry.shopEntity.shopIDIntNum
                                                dormentryID:locationManager.buildingEntry.dormentryIDNum
                                                      width:SCREEN_WIDTH];
    }
    
    return _bannerView;
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

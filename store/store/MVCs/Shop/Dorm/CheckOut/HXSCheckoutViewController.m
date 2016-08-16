//
//  HXSCheckoutViewController.m
//  store
//
//  Created by chsasaw on 15/6/24.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSCheckoutViewController.h"

// Controllers
#import "HXSCouponViewController.h"
#import "HXSDormEditRemarksViewController.h"
#import "HXSPaymentResultViewController.h"
#import "HXSPaymentOrderViewController.h"
#import "HXSLoginViewController.h"

// Model
#import "HXSDormCartManager.h"
#import "HXSSettingsManager.h"
#import "HXSOrderRequest.h"
#import "HXSCouponValidate.h"
#import "HXSBaiHuaHuaPayModel.h"
#import "HXSShop.h"
#import "HXSDormEntry.h"
#import "HXSSite.h"
#import "HXSDormCartItem.h"
#import "HXSCartsItem.h"
#import "HXSCreateOrderParams.h"
#import "HXSDormCart.h"
#import "HXSCoupon.h"

// Views
#import "HXSPayPasswordAlertView.h"
#import "HXSPhoneIdentificationAndLoginView.h"
#import "HXSCheckoutInputCell.h"
#import "HXSDormCheckoutFoodCell.h"
#import "HXSCustomPickerView.h"
#import "HXSDrinkCheckoutSupplementCell.h"

// Others
#import "HXSActionSheet.h"
#import "HXSShopManager.h"
#import "HXSBuildingArea.h"

static NSString *HXSCheckoutInputCellIdentifier    = @"HXSCheckoutInputCell";
static NSString *HXSCheckoutFoodCellIdentifier     = @"HXSDormCheckoutFoodCell";
static NSString *HXSCheckoutSupplementCellIdentify = @"HXSCheckoutSupplementCellIdentify";

typedef NS_ENUM(NSInteger, HXSCheckoutViewSection)
{
    kHXSCheckoutViewSectionAddressAndPhoneNum    = 0,//寝室号,手机号
    kHXSCheckoutViewSectionProducts              = 1,//商品
    kHXSCheckoutViewSectionPromotion             = 2,//赠品活动
    kHXSCheckoutViewSectionCoupon                = 3,//优惠券
    kHXSCheckoutViewSectionDeliverTime           = 4,//送达时间
    kHXSCheckoutViewSectionMessage               = 5,//留言
};

@interface HXSCheckoutViewController ()<UIAlertViewDelegate,
                                        UITableViewDataSource,
                                        UITableViewDelegate,
                                        HXSCouponViewControllerDelegate,
                                        UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, weak) IBOutlet UIView *blurView;

@property (nonatomic, weak) IBOutlet UILabel * totalLabel;
@property (nonatomic, weak) IBOutlet UIButton * checkoutBtn;

@property (nonatomic, strong) HXSOrderRequest * orderRequest;
@property (nonatomic, strong) HXSOrderInfo * checkoutOrderInfo;
@property (nonatomic, strong) HXSCouponValidate * validate;

@property (nonatomic, strong) HXSCoupon * coupon;

@property (nonatomic, strong) NSMutableArray * cartItems;

@property (nonatomic, strong) NSMutableArray * promotionItems;

@property (nonatomic, assign) double totalAmount; // the amount of order

@property (nonatomic, strong) NSString *verifyCode;
@property (nonatomic, strong) HXSExpectTimeEntity *hasSelectedExpectTimeEntity;
@property (nonatomic, strong) NSArray *expectTimeArr;
@property (nonatomic, strong) NSArray *expectTimeNameArr;

@end

@implementation HXSCheckoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"确认订单";
    
    [self initialTableView];
    
    [self intitialExpectTime];
    
    self.cartItems = [NSMutableArray array];
    
    [self.checkoutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0XF9A502]]
                                forState:UIControlStateNormal];
    [self.checkoutBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xE5D9CD)]
                                forState:UIControlStateDisabled];
    
    [self initialNotificationMethods];
    
    
    if ([HXSUserAccount currentAccount].isLogin) {
        // auto matching coupon
        [self autoMatchingCoupon];
    } else {
        [[HXSDormCartManager sharedManager] refreshCartInfo];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kUpdateDormCartComplete
                                                  object:nil];
    
    [[HXSSettingsManager sharedInstance] setRemarks:@""];
    
    self.coupon              = nil;
    self.orderRequest        = nil;
    self.checkoutOrderInfo   = nil;
    self.validate            = nil;
    self.cartItems           = nil;
    self.verifyCode          = nil;
}


#pragma mark - Override Methods

- (void)back
{
    [HXSUsageManager trackEvent:kUsageEventCheckOutGoBack parameter:@{@"business_type":@"夜猫店"}];
    [[HXSDormCartManager sharedManager] refreshCartInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Initial Methods

- (void)initialTableView
{
    [self.tableView setBackgroundColor:UIColorFromRGB(0xF5F6FB)];
    
    self.tableView.layer.masksToBounds = NO;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionIndexColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorColor = HXS_BORDER_COLOR;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HXSCheckoutInputCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:HXSCheckoutInputCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"HXSDormCheckoutFoodCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:HXSCheckoutFoodCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"HXSDrinkCheckoutSupplementCell" bundle:nil] forCellReuseIdentifier:HXSCheckoutSupplementCellIdentify];
}

- (void)intitialExpectTime
{
    __weak typeof(self) weakSelf = self;
    
    HXSShopManager *shopManager = [HXSShopManager shareManager];
    [self.validate fetchExpectTimeList:shopManager.currentEntry.shopEntity.shopIDIntNum
                              compelte:^(HXSErrorCode code, NSString *message, NSArray *expectTimeArr) {
                                  if (kHXSNoError != code) {
                                      [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                         status:message
                                                                     afterDelay:1.5f];
                                      
                                      return ;
                                  }
                                  
                                  weakSelf.expectTimeArr = expectTimeArr;
                                  HXSExpectTimeEntity *timeEntity = [expectTimeArr firstObject];
                                  if (kHXSExpectTimeTypeImmediately == [timeEntity.expectTimeTypeIntNum integerValue]) {
                                      weakSelf.hasSelectedExpectTimeEntity = [expectTimeArr firstObject];
                                  } else {
                                      weakSelf.hasSelectedExpectTimeEntity = nil;
                                  }
                                  
                                  [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
                                  
                              }];
}

- (void)initialNotificationMethods
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cartUpdated:)
                                                 name:kUpdateDormCartComplete
                                               object:nil];
}


#pragma mark - Notification Methods

- (void)cartUpdated:(NSNotification *)noti
{
    self.cartItems = [[[HXSDormCartManager sharedManager] getCartItemsOfCurrentSession] mutableCopy];
    [self.tableView reloadData];
    
    HXSDormCart * cart = [[HXSDormCartManager sharedManager] getCartOfCurrentSession];
    if((nil != self.coupon)
       && (nil != cart.couponCode)
       && (0 < cart.couponCode.length)) {
        [self.totalLabel setText:[NSString stringWithFormat:@"¥%.2f", MAX([cart.itemAmount floatValue], 0)]];
    } else {
        self.coupon = nil;
        
        [self.totalLabel setText:[NSString stringWithFormat:@"¥%.2f", [cart.itemAmount floatValue]]];
    }
    
    self.totalAmount = [cart.itemAmount floatValue];
}


#pragma mark - Targets Methods

- (void)dormitoryNumberChanged:(UITextField *)textField
{
    [HXSUsageManager trackEvent:kUsageEventDromNumberInput parameter:@{@"business_type":@"夜猫店"}];
    [[HXSSettingsManager sharedInstance] setRoomNum: textField.text];
}

- (void)telephoneNumberChanged:(UITextField *)textField
{
    [HXSUsageManager trackEvent:kUsageEventPhoneNumberInput parameter:@{@"business_type":@"夜猫店"}];
    
    NSString *telephone = textField.text;
    [[HXSSettingsManager sharedInstance] setPhoneNum:textField.text];
    
    if ([telephone isValidCellPhoneNumber]) {
        [self.tableView endEditing:YES];
    }
}

- (IBAction)onClickCheckout:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    [button setEnabled:NO];
    
    [HXSUsageManager trackEvent:kUsageEventCheckoutPay parameter:@{@"business_type":@"夜猫店"}];
    
    if (![[HXSUserAccount currentAccount] isLogin]) {
        __weak typeof(self) weakSelf = self;
        NSString * phone = [[HXSSettingsManager sharedInstance] getPhoneNum];
        if (![phone isValidCellPhoneNumber]) {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请输入正确的手机号码" afterDelay:1.0f];
            return ;
        }
        
        HXSPhoneIdentificationAndLoginView *phoneIdentificationAndLoginView = [[HXSPhoneIdentificationAndLoginView alloc] initWithPhone:phone finished:^(BOOL success, NSString *message) {
            if (success) {
                [weakSelf didSelectCoupon:nil];
            } else {
                [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.0f];
            }
        }];
        
        [phoneIdentificationAndLoginView start];
        
        [button setEnabled:YES];
        
        return;
    } else {
        [self checkout:nil];
        [button setEnabled:YES];
    }
}

- (void)checkout:(NSString *)verification_code
{
    NSString * room = [[HXSSettingsManager sharedInstance] getRoomNum];
    if(room.length == 0) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"寝室号不能为空" afterDelay:1.0f];
        return;
    }
    
    NSString * phone = [[HXSSettingsManager sharedInstance] getPhoneNum];
    if (![phone isValidCellPhoneNumber]) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请输入正确的手机号码" afterDelay:1.0f];
        return ;
    }
    
    if (nil == self.hasSelectedExpectTimeEntity) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请选择送达时间" afterDelay:1.0f];
        return;
    }
    
    self.verifyCode = verification_code;
    
    [MobClick event:@"dorm_check_out"];
    [self payOrder];
}

/**
 *  创建订单
 */
- (void)payOrder
{
    WS(weakSelf);
    NSString * phone = [[HXSSettingsManager sharedInstance] getPhoneNum];
    NSString * room = [[HXSSettingsManager sharedInstance] getRoomNum];
    
    self.orderRequest = [[HXSOrderRequest alloc] init];
    
    NSString * remarks = [[HXSSettingsManager sharedInstance] getRemarks];
    
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSShopManager *shopManager = [HXSShopManager shareManager];
    
    HXSCreateOrderParams *createOrderParams = [[HXSCreateOrderParams alloc] init];
    createOrderParams.dormentryIDIntNum     = locationMgr.buildingEntry.dormentryIDNum;
    createOrderParams.shopIDIntNum          = shopManager.currentEntry.shopEntity.shopIDIntNum;
    createOrderParams.deliveryTypeIntNum    = self.hasSelectedExpectTimeEntity.expectTimeTypeIntNum;
    createOrderParams.expectStartTimeIntNum = self.hasSelectedExpectTimeEntity.expectStartTimeNum;
    createOrderParams.expectEndTimeIntNum   = self.hasSelectedExpectTimeEntity.expectEndTimeNum;
    createOrderParams.dormitoryStr          = room;
    createOrderParams.phoneStr              = phone;
    createOrderParams.couponCodeStr         = self.coupon ? self.coupon.couponCode : nil;
    createOrderParams.verificationCodeStr   = self.verifyCode;
    createOrderParams.remarkStr             = remarks;
    
    [HXSLoadingView showLoadingInView:self.view];
    [self.orderRequest newDormOrderWithCreateOrderParams:createOrderParams
                                                compelte:^(HXSErrorCode code, NSString *message, HXSOrderInfo *orderInfo)
     {
         [HXSLoadingView closeInView:weakSelf.view];
         
         if(code == kHXSNoError) {
             [MobClick event:@"dorm_check_out_suc" attributes:@{@"msg1":message}];
             
             [[HXSSettingsManager sharedInstance] setRemarks:@""];
             
             // save type of order
             [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:kHXSOrderTypeDorm] forKey:USER_DEFAULT_LATEST_ORDER_TYPE];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             weakSelf.checkoutOrderInfo = orderInfo;
             
             if((nil != orderInfo)
                && (0 == orderInfo.status)
                && (0 == orderInfo.paystatus)) {
                 //在线支付未支付
                 HXSPaymentOrderViewController *paymentOrderViewController = [HXSPaymentOrderViewController createPaymentOrderVCWithOrderInfo:orderInfo installment:NO];
                 
                 [weakSelf replaceCurrentViewControllerWith:paymentOrderViewController animated:YES];
             } else {
                 
                 if (weakSelf.checkoutOrderInfo) {
                     HXSPaymentResultViewController *balanceVC = [HXSPaymentResultViewController createPaymentResultVCWithOrderInfo:weakSelf.checkoutOrderInfo result:YES];
                     
                     [weakSelf replaceCurrentViewControllerWith:balanceVC animated:YES];
                 } else {
                     [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                 }
             }
             
             [[HXSDormCartManager sharedManager] refreshCartInfo];
         }else if(code == kHXSNeedVerifyCodeError) {
             
             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
             alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
             alertView.tag = 101;
             UITextField *textfield=[alertView textFieldAtIndex:0];
             textfield.keyboardType = UIKeyboardTypeNumberPad;
             [alertView show];
         }else {
             [MobClick event:@"dorm_check_out_fail" attributes:@{@"msg1":message}];
             
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.0];
             
             if ((code > kHXSCouponExpiredError)
                 && (code <= kHXSCouponError)) {
                 weakSelf.coupon = nil;
                 
                 // refresh cart info, after refreshing will update the bottom view
                 [[HXSDormCartManager sharedManager] refreshCartInfo];
             }
         }
     }];
    
    self.verifyCode = nil;
}

- (void)onClickBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Coupon Methods

- (void)autoMatchingCoupon
{
    [self didSelectCoupon:nil];
}


#pragma mark - Check Out Coupon Methods

- (void)onClickSelectCouponBtn
{
    HXSCouponViewController * couponController = [[HXSCouponViewController alloc] initWithNibName:@"HXSCouponViewController" bundle:nil];
    couponController.delegate = self;
    couponController.couponScope = kHXSCouponScopeDorm;
    [self.navigationController pushViewController:couponController animated:YES];
}

- (void)onClickInputCouponBtn
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入优惠券券号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textfield=[alertView textFieldAtIndex:0];
    textfield.keyboardType = UIKeyboardTypeNamePhonePad;
    alertView.tag = 103;
    [alertView show];
}

- (void)displayCheckOutView
{
    __weak typeof(self) weakSelf = self;
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:@"选择优惠券的方式" cancelButtonTitle:@"取消"];
    
    HXSActionSheetEntity *myConponEntity = [[HXSActionSheetEntity alloc] init];
    myConponEntity.nameStr = @"从我的优惠券选择";
    HXSAction *selectAction = [HXSAction actionWithMethods:myConponEntity handler:^(HXSAction *action) {
        
        [HXSUsageManager trackEvent:kUsageEventChooseCouponFromMylist parameter:@{@"business_type":@"夜猫店"}];
        [weakSelf onClickSelectCouponBtn];
    }];
    
    HXSActionSheetEntity *inputConponEntity = [[HXSActionSheetEntity alloc] init];
    inputConponEntity.nameStr = @"手动输入券号";
    HXSAction *inputAction = [HXSAction actionWithMethods:inputConponEntity handler:^(HXSAction *action) {
        
        [HXSUsageManager trackEvent:kUsageEventCouponNumberInput parameter:@{@"business_type":@"夜猫店"}];
        [weakSelf onClickInputCouponBtn];
    }];
    
    [sheet addAction:selectAction];
    [sheet addAction:inputAction];
    
    [sheet show];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == kHXSCheckoutViewSectionAddressAndPhoneNum) {
        return 2;
    } else if(section == kHXSCheckoutViewSectionProducts) {
        return [self.cartItems count];
    } else if(section == kHXSCheckoutViewSectionPromotion) {
        return [self.promotionItems count] + 1;
    } else if (section == kHXSCheckoutViewSectionCoupon) {
        return 1;
    } else if (section == kHXSCheckoutViewSectionDeliverTime) {
        return 1;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == kHXSCheckoutViewSectionProducts
       && indexPath.row < self.cartItems.count) {
        return 80;
    } else if (indexPath.section == kHXSCheckoutViewSectionPromotion
             && indexPath.row < self.promotionItems.count) {
        return 80;
    } else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UIImageView *indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_direction_right_black"]];
    cell.accessoryView = indicatorImageView;
    cell.textLabel.textColor = [UIColor colorWithRGBHex:0x333333];
    cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    
    if(indexPath.section == kHXSCheckoutViewSectionAddressAndPhoneNum) {
        HXSCheckoutInputCell *inputCell = [tableView dequeueReusableCellWithIdentifier:HXSCheckoutInputCellIdentifier];
        
        inputCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        inputCell.titleLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        if(indexPath.row == 0) {
            inputCell.titleLabel.text = @"寝室号";
            inputCell.textField.placeholder = @"请输入寝室号";
            NSString * room = [[HXSSettingsManager sharedInstance] getRoomNum];
            inputCell.textField.text = room;
            
            [inputCell.textField addTarget:self action:@selector(dormitoryNumberChanged:) forControlEvents:UIControlEventEditingChanged];
        } else {
            inputCell.titleLabel.text = @"手机号";
            inputCell.textField.placeholder = @"请输入手机号";
            NSString * phone = [[HXSSettingsManager sharedInstance] getPhoneNum];
            inputCell.textField.text = phone;
            
            [inputCell.textField addTarget:self action:@selector(telephoneNumberChanged:) forControlEvents:UIControlEventEditingChanged];
        }
        inputCell.tintColor = [UIColor colorWithRGBHex:0x0065CD];
        
        return inputCell;
        
    } else if(indexPath.section == kHXSCheckoutViewSectionProducts) {
        if (indexPath.row < self.cartItems.count) {
            HXSDormCheckoutFoodCell * itemCell = [tableView dequeueReusableCellWithIdentifier:HXSCheckoutFoodCellIdentifier];
            itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.row < self.cartItems.count) {
                HXSDormCartItem * item = [self.cartItems objectAtIndex:indexPath.row];
                itemCell.item = item;
            }
        
            if (indexPath.row == (self.cartItems.count - 1)) {
                itemCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            } else {
                itemCell.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
            }
            
            return itemCell;
        }
    } else if(indexPath.section == kHXSCheckoutViewSectionPromotion) {   //赠品活动
        if (indexPath.row < self.promotionItems.count) {
            HXSDormCheckoutFoodCell * itemCell = [tableView dequeueReusableCellWithIdentifier:HXSCheckoutFoodCellIdentifier];
            itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.row < self.promotionItems.count) {
                HXSCartsItem * item = [self.promotionItems objectAtIndex:indexPath.row];
                [itemCell setPromotionItems:item];
            }
            
            if (indexPath.row == (self.promotionItems.count - 1)) {
                itemCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            } else {
                itemCell.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
            }
            
            return itemCell;
        } else {
            HXSDormCart * cart = [[HXSDormCartManager sharedManager] getCartOfCurrentSession];
            
            /**
             *  暂未计算商品与奖品的总价   只有商品总价
             */
            
            NSInteger totalNum = 0;
            
            totalNum = cart.itemNum.integerValue;
            HXSDrinkCheckoutSupplementCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSCheckoutSupplementCellIdentify];
            cell.leftLabel.text  = [NSString stringWithFormat:@"共%ld件商品", (long)totalNum];
            cell.rightLabel.text = [NSString stringWithFormat:@"￥%0.02f", MAX(cart.itemAmount.floatValue, cart.originAmountDoubleNum.doubleValue)];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    } else if(indexPath.section == kHXSCheckoutViewSectionCoupon) {
        [cell.textLabel setText:@"优惠券"];
        
        if (![HXSUserAccount currentAccount].isLogin) {
            [cell.detailTextLabel setText:@"登录后显示"];
            cell.detailTextLabel.textColor = HXS_PROMPT_TEXT_COLOR;
        } else {
            HXSDormCart * cart = [[HXSDormCartManager sharedManager] getCartOfCurrentSession];
            if(cart.couponDiscount.floatValue > 0) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"-￥%.2f", cart.couponDiscount.floatValue]];
                cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
            } else {
                [cell.detailTextLabel setText:@"无可用优惠券"];
                cell.detailTextLabel.textColor = HXS_PROMPT_TEXT_COLOR;
            }
        }
    } else if (kHXSCheckoutViewSectionDeliverTime == indexPath.section) {// 送达时间
        [cell.textLabel setText:@"送达时间"];

        cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
        if (nil == self.hasSelectedExpectTimeEntity) {
            [cell.detailTextLabel setText:@"请选择送达时间"];
        } else {
            [cell.detailTextLabel setText:self.hasSelectedExpectTimeEntity.expectTimeNameStr];
        }
        
    } else {//留言
        [cell.textLabel setText:@"留言"];
        NSString * remarks = [[HXSSettingsManager sharedInstance] getRemarks];
        if(remarks.length > 0) {
            [cell.detailTextLabel setText:remarks];
            cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        } else {
            cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0xCCCCCC];
            [cell.detailTextLabel setText:@"给店主留言(选填)"];
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        HXSLocationManager *locationMgr = [HXSLocationManager manager];
        HXSBuildingArea *buildingArea = locationMgr.currentBuildingArea;
        HXSSite * site = locationMgr.currentSite;
        HXSBuildingEntry *buildingEntry = locationMgr.buildingEntry;
        
        if(site.name
           && site.name.length > 0
           && (nil != buildingEntry)
           && (0 < [buildingEntry.buildingNameStr length])) {
            return [NSString stringWithFormat:@"%@%@%@", site.name, buildingArea.name, buildingEntry.buildingNameStr];
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return 45;
    }
    else if(section == 2){
        
        if ([self.promotionItems count] > 0) {
        
            return 34;
        } else {
            
            return 0;
        }
    }
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section != 0) {
        [self.view endEditing:YES];
    }
    
    if(indexPath.section == kHXSCheckoutViewSectionAddressAndPhoneNum) {
        
    } else if(indexPath.section == kHXSCheckoutViewSectionCoupon) {
        
        [HXSUsageManager trackEvent:kUsageEventChooseCoupon parameter:@{@"business_type":@"夜猫店"}];
        if(indexPath.row == 0) {
            if (![HXSUserAccount currentAccount].isLogin) {
                [HXSLoginViewController showLoginController:self loginCompletion:^{
                    [self autoMatchingCoupon];
                }];
            } else {
                [self displayCheckOutView];
            }
        }
    } else if (indexPath.section == kHXSCheckoutViewSectionDeliverTime) {
        
        [HXSUsageManager trackEvent:kUsageEventChooseDeliveryTime parameter:@{@"business_type":@"夜猫店"}];
        if (0 >= [self.expectTimeArr count]) {
            [self intitialExpectTime];
            
            return;
        }
        
        __weak typeof(self) weakSelf = self;
        [HXSCustomPickerView showWithStringArray:self.expectTimeNameArr
                                    defaultValue:self.hasSelectedExpectTimeEntity.expectTimeNameStr
                                    toolBarColor:[UIColor whiteColor]
                                   completeBlock:^(int index, BOOL finished) {
                                       if (finished) {
                                           weakSelf.hasSelectedExpectTimeEntity = [weakSelf.expectTimeArr objectAtIndex:index];
                                           [HXSUsageManager trackEvent:kUsageEventDeliveryTimeSelected parameter:@{@"business_type":@"夜猫店",@"type":weakSelf.hasSelectedExpectTimeEntity.expectTimeNameStr}];
                                           
                                           [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:kHXSCheckoutViewSectionDeliverTime] withRowAnimation:UITableViewRowAnimationAutomatic];
                                       }
                                   }];
    } else if (indexPath.section == kHXSCheckoutViewSectionMessage) {
        
        [HXSUsageManager trackEvent:kUsageEventLeaveMessage parameter:@{@"business_type":@"夜猫店"}];
        
        HXSDormEditRemarksViewController * remarksController = [[HXSDormEditRemarksViewController alloc] initWithNibName:@"HXSDormEditRemarksViewController" bundle:nil];
        
        [self.navigationController pushViewController:remarksController animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == kHXSCheckoutViewSectionPromotion) {
        
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"HXSPromotionItemsTitleView" owner:nil options:nil][0];

        return view;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (section == kHXSCheckoutViewSectionAddressAndPhoneNum) {
        view.tintColor = [UIColor clearColor];
        
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        [header.textLabel setTextColor:UIColorFromRGB(0x333333)];
        [header.textLabel setFont:[UIFont systemFontOfSize:15]];
    }
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 44;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark - HXSCouponViewControllerDelegate

- (void)didSelectCoupon:(HXSCoupon *)coupon
{
    __weak typeof(self) weakSelf = self;
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [[HXSDormCartManager sharedManager] checkCouponAvailable:coupon.couponCode
                                                    complete:^(HXSErrorCode code, NSString *message, NSDictionary *cartInfo) {
                                                        [HXSLoadingView closeInView:weakSelf.view];
                                                        
                                                        if (kHXSNoError != code) {
                                                            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                               status:message
                                                                                           afterDelay:1.5f];
                                                            
                                                            return ;
                                                        }
                                                        
                                                        //满即送
                                                        if ([cartInfo.allKeys containsObject:@"promotion_items"]) {
                                                            NSArray *items = cartInfo[@"promotion_items"];
                                                            for (NSDictionary *dict in items) {
                                                                HXSCartsItem *item = [HXSCartsItem initWithDict:dict];
                                                                [weakSelf.promotionItems addObject:item];
                                                            }
                                                        }
                                                        
                                                        
                                                        if (nil == coupon) {
                                                            HXSDormCart * cart = [[HXSDormCartManager sharedManager] getCartOfCurrentSession];
                                                            
                                                            if ((nil != cart.couponCode)
                                                                && (0 < [cart.couponCode length]))
                                                            {
                                                                HXSCoupon *autoCoupon = [[HXSCoupon alloc] init];
                                                                autoCoupon.couponCode = cart.couponCode;
                                                                autoCoupon.discount = cart.couponDiscount;
                                                                
                                                                weakSelf.coupon = autoCoupon;
                                                            } else {
                                                                weakSelf.coupon = nil;
                                                            }
                                                        } else {
                                                            weakSelf.coupon = coupon;
                                                        }
                                                        
                                                        [weakSelf.tableView reloadData];
                                                    }];

}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1 && alertView.tag == 101) {
        UITextField *textfield=[alertView textFieldAtIndex:0];
        if(textfield.text.length < 6) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码为6位,请再次输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag = 101;
            UITextField *textfield=[alertView textFieldAtIndex:0];
            textfield.keyboardType = UIKeyboardTypeNumberPad;
            [alertView show];
        } else {
            
            self.verifyCode = textfield.text;
            [self payOrder];
        }
    } else if (alertView.tag == 103 && buttonIndex == 1) {
        UITextField *textfield=[alertView textFieldAtIndex:0];
        if(textfield.text.length > 0) {
            [HXSLoadingView showLoadingInView:self.view];
            
            __weak typeof(self) weakSelf = self;
            NSString * couponCode = textfield.text;
            [self.validate validateWithToken:[HXSUserAccount currentAccount].strToken
                                  couponCode:couponCode
                                        type: kHXSCouponScopeDorm
                                    complete:^(HXSErrorCode code, NSString *message, HXSCoupon *coupon) {
                [HXSLoadingView closeInView:weakSelf.view];
                                        
                if (code == kHXSNoError)
                {
                    [weakSelf didSelectCoupon:coupon];
                }
                else
                {
                    [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.0];
                }
            }];
        }
    }
}


#pragma mark - Setter Getter Methods

- (HXSCouponValidate *)validate
{
    if (nil == _validate) {
        _validate = [[HXSCouponValidate alloc] init];
    }
    
    return _validate;
}

- (NSArray *)expectTimeNameArr
{
    NSMutableArray *nameMArr = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (HXSExpectTimeEntity *entity in self.expectTimeArr) {
        [nameMArr addObject:entity.expectTimeNameStr];
    }
    
    return nameMArr;
}

- (NSMutableArray *)promotionItems
{
    if (nil == _promotionItems) {
        _promotionItems = [NSMutableArray array];
    }
    
    return _promotionItems;
}


@end

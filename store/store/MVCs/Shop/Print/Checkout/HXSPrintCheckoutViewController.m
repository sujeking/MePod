//
//  HXSPrintCheckoutViewController.m
//  store
//
//  Created by 格格 on 16/3/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintCheckoutViewController.h"

// Controllers
#import "HXSDeliveryInfoViewController.h"
#import "HXSDormEditRemarksViewController.h"
#import "HXSPrintCouponViewController.h"
#import "HXSLoginViewController.h"
#import "HXSPaymentResultViewController.h"
#import "HXSPaymentOrderViewController.h"

// Model
#import "HXSSettingsManager.h"
#import "HXSShop.h"
#import "HXSPrintCartEntity.h"
#import "HXSMyPrintOrderItem.h"
#import "HXSCoupon.h"
#import "HXSPrintModel.h"
#import "HXSCouponValidate.h"
#import "HXSDeliveryEntity.h"
#import "HXSBuildingArea.h"

// Views
#import "HXSActionSheet.h"
#import "HXSPhoneIdentificationAndLoginView.h"
#import "HXSCheckoutInputCell.h"
#import "HXSMyOderTableViewCell.h"
#import "HXSPrintCheckOutWelfarePaperCell.h"
#import "HXSDrinkCheckoutSupplementCell.h"

typedef NS_ENUM(NSUInteger,HXSSectionType) {
    HXSSectionTypeUserInfo                  = 0,  // 用户信息
    HXSSectionTypeGoodsInfo                 = 1,  // 商品信息
    HXSSectionTypeWelfarePaper              = 2,  // 福利纸信息
    HXSSectionTypeCoupon                    = 3,  // 优惠券信息
    HXSSectionTypeDelivery                  = 4,  // 配送信息
    HXSSectionTypeRemark                    = 5   // 留言
};


static NSString *HXSPrintCheckoutInputCellIdentify      = @"HXSCheckoutInputCell";
static NSString *HXPrintOderTableViewCellIdentify       = @"HXSMyOderTableViewCell";
static NSString *HXSPrintCheckoutSupplementCellIdentify = @"HXSDrinkCheckoutSupplementCell";
static NSString *HXSPrintCheckOutWelfarePaperCellIdentify = @"HXSPrintCheckOutWelfarePaperCell";

static NSInteger COUPON_POPOVER_TAG      = 100;
static NSInteger VERIFY_CODE_POPOVER_TAG = 101;

@interface HXSPrintCheckoutViewController ()<UITableViewDataSource,
                                             UITableViewDelegate,
                                             HXSPrintCouponViewControllerDelegate,
                                             HXSDeliveryInfoViewControllerDelegate>


@property(nonatomic,weak) IBOutlet UITableView *tableView;
@property(nonatomic,weak) IBOutlet UILabel *totalPagesLabel;
@property(weak, nonatomic) IBOutlet UILabel *actualAmoutLabel;
/**是否使用福利纸*/
@property(assign,nonatomic) BOOL ifUseWelfarePaper;
/**优惠券 */
@property (nonatomic, strong) HXSCoupon *coupon;
@property (nonatomic, strong) NSString *verifyCode;
@property (nonatomic, assign) HXSOrderPayType payType;
@property (nonatomic, strong) HXSPrintOrderInfo * printOrderInfo;
@property (nonatomic, strong) HXSDeliveryEntity *selectDeliveryEntity;
@property (nonatomic, strong) HXSDeliveryTime *selectDeliveryTime;
@property (nonatomic, strong) HXSDeliveryInfoViewController *deliveryInfoVC;
@property (nonatomic, strong) HXSCouponValidate * validate;
/**购物车entity*/
@property (nonatomic,strong) HXSPrintCartEntity *printCartEntity;
/***店铺entity*/
@property (nonatomic,strong) HXSShopEntity *shopEntity;
@property (nonatomic,strong) NSArray *sectionArray;

@end

@implementation HXSPrintCheckoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigation];
    [self initialAttribute];
    [self initialTableView];
    
    [self refreshPrintCarEntity];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    [[HXSSettingsManager sharedInstance] setRemarks:@""];
    
    self.printCartEntity      = nil;
    self.coupon         = nil;
    self.verifyCode     = nil;
    self.printOrderInfo = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshActualAmoutUI];
    [self.tableView reloadData];
}


#pragma mark - Override Methods

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - initialMethod

- (void)initialNavigation
{
    self.navigationItem.title = @"确认订单";
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initialAttribute
{
    self.ifUseWelfarePaper = NO; // 福利纸默认关闭状态
}

- (void)initPrintCheckoutViewControllerWithEntity:(HXSPrintCartEntity *)entity
                                andWithShopEntity:(HXSShopEntity *)shopEntity
{
    _printCartEntity = entity;
    _shopEntity      = shopEntity;
    if(_printCartEntity.docTypeNum.intValue == HXSPrintDocumentTypePicture) {
        _sectionArray = @[@(HXSSectionTypeUserInfo)
                          ,@(HXSSectionTypeGoodsInfo)
                          ,@(HXSSectionTypeCoupon)
                          ,@(HXSSectionTypeDelivery)
                          ,@(HXSSectionTypeRemark)];
    } else {
        _sectionArray = @[@(HXSSectionTypeUserInfo)
                          ,@(HXSSectionTypeGoodsInfo)
                          ,@(HXSSectionTypeWelfarePaper)
                          ,@(HXSSectionTypeCoupon)
                          ,@(HXSSectionTypeDelivery)
                          ,@(HXSSectionTypeRemark)];
    
    }
}

- (void)initialTableView{

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorColor = [UIColor colorWithRGBHex:0xE5E6E7];
    _tableView.backgroundColor = [UIColor colorWithRGBHex:0xF5F6F7];
    _tableView.showsVerticalScrollIndicator = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:@"HXSCheckoutInputCell" bundle:nil] forCellReuseIdentifier:HXSPrintCheckoutInputCellIdentify];
    [_tableView registerNib:[UINib nibWithNibName:@"HXSMyOderTableViewCell" bundle:nil] forCellReuseIdentifier:HXPrintOderTableViewCellIdentify];
    [_tableView registerNib:[UINib nibWithNibName:@"HXSDrinkCheckoutSupplementCell" bundle:nil] forCellReuseIdentifier:HXSPrintCheckoutSupplementCellIdentify];
    [_tableView registerNib:[UINib nibWithNibName:@"HXSPrintCheckOutWelfarePaperCell" bundle:nil] forCellReuseIdentifier:HXSPrintCheckOutWelfarePaperCellIdentify];
}


#pragma mark - webServies

// 刷新购物车订单价格
- (void)refreshPrintCarEntity
{
    [MBProgressHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    NSNumber *openAdNum;
    if(self.printCartEntity.docTypeNum.intValue == HXSPrintDocumentTypePicture) {
        openAdNum = @(0);
    } else {
        openAdNum = self.ifUseWelfarePaper?@(1):@(0);
    }
    
    [HXSPrintModel createOrCalculatePrintOrderWithPrintCartEntity:self.printCartEntity
                                                      shopId:self.shopEntity.shopIDIntNum
                                                      openAd:openAdNum
                                                    complete:^(HXSErrorCode code, NSString *message, HXSPrintCartEntity *printCartEntity) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(kHXSNoError == code) {
            weakSelf.printCartEntity = printCartEntity;
            
            [weakSelf refreshActualAmoutUI];
            [weakSelf refreshHasSelectedPayType];
            
            [weakSelf.tableView reloadData];
        
        } else {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f];
            // 福利纸已经用完
            if(code == kPrintWelfarePaper) {
                self.ifUseWelfarePaper = NO;
                self.printCartEntity.openAdIntNum = @(0);
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

// 刷新总价格显示
- (void)refreshActualAmoutUI
{
    //  订单合计
    _actualAmoutLabel.text = [NSString stringWithFormat:@"￥%0.2f", [_printCartEntity.totalAmountDoubleNum floatValue]];
    // 共打印页数
    if(self.printCartEntity.docTypeNum.integerValue == HXSPrintDocumentTypeOther)
        _totalPagesLabel.text = [NSString stringWithFormat:@"%d页",[_printCartEntity.printPagesIntNum intValue]];
    else if(self.printCartEntity.docTypeNum.integerValue == HXSPrintDocumentTypePicture)
        _totalPagesLabel.text = [NSString stringWithFormat:@"%d张",[_printCartEntity.printPagesIntNum intValue]];
}

// 修改福利纸状态
-(void)refreshHasSelectedPayType
{
    // 打开福利纸但后台返回的是未打开，修改本地状态和显示
    if(self.ifUseWelfarePaper
       && self.printCartEntity.openAdIntNum.intValue == 0) {
        self.ifUseWelfarePaper = NO;
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"福利纸正在路上，敬请期待" afterDelay:1];
    }
}


#pragma mark - TableViewSelected 选择优惠券

// 选择优惠券
-(void)displayCouponSelectionActionSheet
{
    __weak typeof(self) weakSelf = self;
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:@"选择优惠券的方式" cancelButtonTitle:@"取消"];
    
    HXSActionSheetEntity *myConponEntity = [[HXSActionSheetEntity alloc] init];
    myConponEntity.nameStr = @"从我的优惠券选择";
    HXSAction *selectAction = [HXSAction actionWithMethods:myConponEntity handler:^(HXSAction *action) {
        [weakSelf showCouponSelectionController];
    }];
    
    HXSActionSheetEntity *inputConponEntity = [[HXSActionSheetEntity alloc] init];
    inputConponEntity.nameStr = @"手动输入券号";
    HXSAction *inputAction = [HXSAction actionWithMethods:inputConponEntity handler:^(HXSAction *action) {
        [weakSelf showCouponInputPopover];
    }];
    
    [sheet addAction:selectAction];
    [sheet addAction:inputAction];
    
    [sheet show];
}

- (void)showCouponSelectionController
{
    HXSPrintCouponViewController * couponController = [[HXSPrintCouponViewController alloc] initWithNibName:@"HXSPrintCouponViewController" bundle:nil];
    couponController.delegate = self;
    NSNumber *docTypeNum;
    if(self.printCartEntity.docTypeNum.intValue == HXSPrintDocumentTypePicture) {
        docTypeNum = @(1);
    } else {
        docTypeNum = @(2);
    }
    
    [couponController setOrderAmount:self.printCartEntity.documentAmountDoubleNum docType:docTypeNum isAll:NO];
    [self.navigationController pushViewController:couponController animated:YES];
}


#pragma mark - Target/Action

// 修改寝室号
- (void)printCheckoutDormitoryNumberChanged:(UITextField *)textField
{
    [[HXSSettingsManager sharedInstance] setRoomNum: textField.text];
}

// 修改手机号
- (void)printCheckoutTelephoneNumberChanged:(UITextField *)textField
{
    NSString *telephone = textField.text;
    [[HXSSettingsManager sharedInstance] setPhoneNum:textField.text];
    
    if ([telephone isValidCellPhoneNumber]) {
        [self.tableView endEditing:YES];
    }
}

// 修改福利纸状态
- (void)welfarePaperSwitchStatusChange:(UISwitch *)sender
{
    
    self.ifUseWelfarePaper = sender.on;
    NSNumber *welfarePaperNum = [[NSUserDefaults standardUserDefaults]objectForKey:PrintIfUseWelfarePage];
    
    if(!welfarePaperNum&&sender.on) {
        [[NSUserDefaults standardUserDefaults]setObject:@(1) forKey:PrintIfUseWelfarePage];
        NSString *welfarePaperStr = @"勾选免费打印后，会在相应页面的\n页脚添加一则广告";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:welfarePaperStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
    [self refreshPrintCarEntity];
}

- (void)showCouponInputPopover
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入优惠券券号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textfield=[alertView textFieldAtIndex:0];
    textfield.keyboardType = UIKeyboardTypeNamePhonePad;
    alertView.tag = COUPON_POPOVER_TAG;
    [alertView show];
}


// 点击立即支付
- (IBAction)payButtonPressed:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventPrintConfirmCheckOut parameter:nil];
    
    if (![[HXSUserAccount currentAccount] isLogin]) {
        
        __weak typeof(self) weakSelf = self;
        NSString * phone = [[HXSSettingsManager sharedInstance] getPhoneNum];
        if (![phone isValidCellPhoneNumber]) {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请输入正确的手机号码" afterDelay:1.0f];
            return ;
        }
        
        HXSPhoneIdentificationAndLoginView *phoneIdentificationAndLoginView = [[HXSPhoneIdentificationAndLoginView alloc] initWithPhone:phone finished:^(BOOL success, NSString *message) {
            if (success) {
                [weakSelf refreshPrintCarEntity];
            } else {
                [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.0f];
            }
        }];
        
        [phoneIdentificationAndLoginView start];
    } else {
        [self createPrintOrder];
    }
}

/**
 *  创建打印订单
 */
- (void)createPrintOrder
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
    
    if(nil == self.selectDeliveryEntity&&!self.printCartEntity.sendTypeIntNum){
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请选择配送信息" afterDelay:1.0f];
        return;
    }
    
    [MBProgressHUD showInView:self.view];
    
    NSString * remarks = [[HXSSettingsManager sharedInstance] getRemarks];
    
    __weak typeof(self) weakSelf = self;
    
    NSString *apiStr = @"";
    if(_printCartEntity.docTypeNum.intValue == HXSPrintDocumentTypePicture)
        apiStr = HXS_ORDERPIC_PRINT_CREATEORDER;
    else
        apiStr = HXS_PRINT_CREATEORDER;
    
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    [HXSPrintModel createPrintOrderWithPhone:phone
                                     address:room
                                      remark:remarks
                                    pay_type:([self.printCartEntity.totalAmountDoubleNum doubleValue] < 0.01) ? @(kHXSOrderPayTypeCash):@(kHXSOrderPayTypeZhifu)
                                dormentry_id:locationMgr.buildingEntry.dormentryIDNum
                                     shop_id:self.printCartEntity.shopIdIntNum
                                     open_ad:self.ifUseWelfarePaper?@(1):@(0)
                            printOrderEntity:self.printCartEntity
                                      apiStr:apiStr
                                    complete:^(HXSErrorCode code, NSString *message, HXSPrintOrderInfo *orderInfo) {
                                        [HXSUsageManager trackEvent:kUsageEventPrintConfirmCheckOutSuc parameter:nil];
                                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                        
                                        if(kHXSNoError == code){
                                            [[HXSSettingsManager sharedInstance] setRemarks:@""];
                                            
                                            // save type of order
                                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:kHXSOrderTypePrint] forKey:USER_DEFAULT_LATEST_ORDER_TYPE];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            weakSelf.printOrderInfo = orderInfo;
                                            if(orderInfo && orderInfo.statusIntNum.intValue == HXSPrintOrderStatusNotPay && orderInfo.paytypeIntNum.intValue != kHXSOrderPayTypeCash){ // 订单未支付且支付方式不为现金支付
                                                
                                                [weakSelf gotoPaymentViewController];
                                                
                                            }else{
                                                [weakSelf openBalanceViewController:YES];
                                            }
                                            // Refresh cart info
                                            [weakSelf updatePrintStoreCartInfo];
                                        }else if(kHXSNeedVerifyCodeError == code){
                                            [HXSUsageManager trackEvent:kUsageEventPrintConfirmCheckOutFail parameter:nil];
                                            
                                            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                                            alertView.tag = VERIFY_CODE_POPOVER_TAG;
                                            UITextField *textfield=[alertView textFieldAtIndex:0];
                                            textfield.keyboardType = UIKeyboardTypeNumberPad;
                                            [alertView show];
                                            
                                        }else{
                                            [HXSUsageManager trackEvent:kUsageEventPrintConfirmCheckOutFail parameter:nil];
                                            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.0];
                                            
                                            if ((code > kHXSCouponExpiredError)
                                                && (code <= kHXSCouponError)) {
                                                weakSelf.coupon = nil;
                                            }
                                        }
                                        
                                    }];
    self.verifyCode = nil;
}


- (void)openBalanceViewController:(BOOL)hasPaid
{
    NSNumber *paidFlag = hasPaid ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];
    [self performSelector:@selector(delayedShowPrintBalanceViewController:) withObject:paidFlag afterDelay:0.5];
}

- (void)delayedShowPrintBalanceViewController:(NSNumber *)paidStatus
{
    if (self.printOrderInfo) {
        [MBProgressHUD showInView:self.view];
        [HXSPrintModel getPrintOrderDetialWithOrderSn:self.printOrderInfo.orderSnLongNum complete:^(HXSErrorCode code, NSString *message, HXSPrintOrderInfo *printOrder) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (kHXSNoError == code) {
                HXSPaymentResultViewController *vc = [HXSPaymentResultViewController createPaymentResultVCWithOrderInfo:[[HXSOrderInfo alloc] initWithOrderInfo:printOrder] result:[paidStatus boolValue]];
                
                [self replaceCurrentViewControllerWith:vc animated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - HXSCouponViewControllerDelegate

- (void)didSelectCoupon:(HXSCoupon *)coupon{
    self.printCartEntity.couponCodeStr = coupon.couponCode;
    [self refreshPrintCarEntity];
}


#pragma mark - HXSDeliveryInfoViewControllerDelegate

- (void)selectHXSDeliveryEntity:(HXSDeliveryEntity *)selectDeliveryEntity deliveryTime:(HXSDeliveryTime *)selectDeliveryTime{
    
    self.selectDeliveryEntity = selectDeliveryEntity;
    self.selectDeliveryTime = selectDeliveryTime;
    self.printCartEntity.sendTypeIntNum = selectDeliveryEntity.sendTypeIntNum;
    self.printCartEntity.deliveryTypeIntNum = selectDeliveryTime?selectDeliveryTime.typeIntNum : nil;
    self.printCartEntity.expectStartTimeLongNum = selectDeliveryTime?selectDeliveryTime.expectStartTimeLongNum : nil;
    self.printCartEntity.expectEndTimeLongNum = selectDeliveryTime?selectDeliveryTime.expectEndTimeLongNum : nil;
    self.printCartEntity.expectTimeNameStr = selectDeliveryTime?selectDeliveryTime.nameStr : selectDeliveryEntity.pickTimeStr;
    
    [self refreshPrintCarEntity];

}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *num = [_sectionArray objectAtIndex:section];
    switch (num.integerValue) {
        case HXSSectionTypeUserInfo:
            return 2;
            break;
        case HXSSectionTypeGoodsInfo:
            return [self.printCartEntity.itemsArray count] + 1;
            break;
        case HXSSectionTypeWelfarePaper:
            return 1;
            break;
        case HXSSectionTypeCoupon:
            return 1;
            break;
        case HXSSectionTypeDelivery:
            return 1;
            break;
        case HXSSectionTypeRemark:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = [_sectionArray objectAtIndex:indexPath.section];
    if(num.integerValue == HXSSectionTypeGoodsInfo && indexPath.row < self.printCartEntity.itemsArray.count) {
        return 92;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSNumber *num = [_sectionArray objectAtIndex:section];
    if(num.integerValue == HXSSectionTypeUserInfo) {
        return 40.0;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSNumber *num = [_sectionArray objectAtIndex:section];
    if (num.integerValue == HXSSectionTypeUserInfo) {
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = [UIColor colorWithRGBHex:0xF5F6F7];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.width - 15, 45)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor colorWithRGBHex:0x666666];
        
        HXSLocationManager *locationMgr = [HXSLocationManager manager];
        HXSBuildingArea *buildingArea = locationMgr.currentBuildingArea;
        HXSSite * site = locationMgr.currentSite;
        
        label.text = [NSString stringWithFormat:@"%@%@%@(%@)", site.name,buildingArea.name,locationMgr.buildingEntry.buildingNameStr,self.shopEntity.shopNameStr];
        
        [header addSubview:label];
        
        return header;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = [_sectionArray objectAtIndex:indexPath.section];
    if(HXSSectionTypeUserInfo == num.integerValue){ // 寝室号 + 手机号
        HXSCheckoutInputCell *inputCell = [tableView dequeueReusableCellWithIdentifier:HXSPrintCheckoutInputCellIdentify];
        inputCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        if(0 == indexPath.row) {
            inputCell.titleLabel.text = @"寝室号";
            inputCell.textField.placeholder = @"请输入寝室号";
            
            NSString * room = [[HXSSettingsManager sharedInstance] getRoomNum];
            inputCell.textField.text = room;
            
            [inputCell.textField addTarget:self action:@selector(printCheckoutDormitoryNumberChanged:) forControlEvents:UIControlEventEditingChanged];
        } else {
            inputCell.titleLabel.text = @"手机号";
            inputCell.textField.placeholder = @"请输入手机号";
            NSString * phone = [[HXSSettingsManager sharedInstance] getPhoneNum];
            inputCell.textField.text = phone;
            
            [inputCell.textField addTarget:self action:@selector(printCheckoutTelephoneNumberChanged:) forControlEvents:UIControlEventEditingChanged];
        }
        inputCell.tintColor = [UIColor colorWithRGBHex:0x0065CD];
        inputCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return inputCell;
    } else if(HXSSectionTypeGoodsInfo == num.integerValue) { // 打印列表
        
        if(self.printCartEntity.itemsArray.count > indexPath.row) {
            
            HXSMyOderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HXPrintOderTableViewCellIdentify];
            HXSMyPrintOrderItem *item = self.printCartEntity.itemsArray[indexPath.row];
            cell.printItem = item;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.row == self.printCartEntity.itemsArray.count) {
                
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            } else {
                
                cell.separatorInset = UIEdgeInsetsMake(0, 96, 0, 0);
            }
            return cell;
        } else {
            
            HXSDrinkCheckoutSupplementCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSPrintCheckoutSupplementCellIdentify];
            cell.leftLabel.text = [NSString stringWithFormat:@"共%d份",self.printCartEntity.printIntNum.intValue];
            cell.rightLabel.text = [NSString stringWithFormat:@"￥%.2f",self.printCartEntity.documentAmountDoubleNum?self.printCartEntity.documentAmountDoubleNum.doubleValue : 0.00];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else if (HXSSectionTypeWelfarePaper == num.integerValue) { // 福利纸
        
        HXSPrintCheckOutWelfarePaperCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSPrintCheckOutWelfarePaperCellIdentify];
        cell.nameLabel.text = @"免费打印";
        cell.nameLabel.font = [UIFont systemFontOfSize:14.0];
        cell.nameLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        
        cell.welfarePaperSwitch.on = self.ifUseWelfarePaper;
        [cell.welfarePaperSwitch addTarget:self action:@selector(welfarePaperSwitchStatusChange:) forControlEvents:UIControlEventValueChanged];
        
        if (self.ifUseWelfarePaper) {
            [cell.freePaperDetialLabel setHidden:NO];
            
            NSString *freePaperStr = [NSString stringWithFormat:@"%zd张，-￥%0.2f", [self.printCartEntity.adPageNumIntNum integerValue], [self.printCartEntity.freeAmountDoubleNum doubleValue]];
            cell.freePaperDetialLabel.text = freePaperStr;
        } else {
            [cell.freePaperDetialLabel setHidden:YES];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (HXSSectionTypeCoupon == num.integerValue) { // 优惠券
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = @"优惠券";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        
        if (![HXSUserAccount currentAccount].isLogin) {
            [cell.detailTextLabel setText:@"登录后显示"];
            cell.detailTextLabel.textColor = HXS_PROMPT_TEXT_COLOR;
        } else {
            if([self.printCartEntity.couponDiscountDoubleNum floatValue] > 0) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"-￥%.2f", self.printCartEntity.couponDiscountDoubleNum.floatValue]];
                cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
            } else {
                if(self.printCartEntity.couponHadNum.integerValue == 0) {
                    [cell.detailTextLabel setText:@"无可用优惠券"];
                    cell.detailTextLabel.textColor = HXS_PROMPT_TEXT_COLOR;
                } else {
                    [cell.detailTextLabel setText:@"有可用优惠券"];
                    cell.detailTextLabel.textColor = HXS_SPECIAL_COLOR;
                }
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else if (HXSSectionTypeDelivery == num.integerValue) { // 配送信息
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = @"配送信息";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if(self.printCartEntity.sendTypeIntNum) {
            if(HXSPrintDeliveryTypeShopOwner == self.printCartEntity.sendTypeIntNum.doubleValue&&self.printCartEntity.deliveryAmountDoubleNum) {
                if(self.printCartEntity.deliveryAmountDoubleNum.doubleValue <= 0.00) {
                    cell.detailTextLabel.text = @"店长配送：免费配送";
                    cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x666666];
                } else {
                    NSString *str = [NSString stringWithFormat:@"店长配送：￥%.2f",self.printCartEntity.deliveryAmountDoubleNum.doubleValue];
                    NSString *subStr = [NSString stringWithFormat:@"￥%.2f",self.printCartEntity.deliveryAmountDoubleNum.doubleValue];
                    
                    NSMutableAttributedString *showStr = [[NSMutableAttributedString alloc]initWithString:str];
                    [showStr addAttribute:NSForegroundColorAttributeName
                                          value:[UIColor colorWithRGBHex:0xF9A502]
                                          range:[str rangeOfString:subStr]];
                    
                    cell.detailTextLabel.attributedText = showStr;
                }
            } else if(HXSPrintDeliveryTypeSelf == self.printCartEntity.sendTypeIntNum.doubleValue) {
                cell.detailTextLabel.text = @"上门自取";
                cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            }
        } else {
            cell.detailTextLabel.text = @"";
        }
        return cell;
    } else if(HXSSectionTypeRemark == num.integerValue) {  // 留言
        UITableViewCell *messageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        messageCell.textLabel.text = @"留言";
        messageCell.textLabel.font = [UIFont systemFontOfSize:14.0];
        messageCell.textLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        messageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        messageCell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        messageCell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0xCCCCCC];
        
        NSString * remarks = [[HXSSettingsManager sharedInstance] getRemarks];
        if(remarks.length > 0) {
            messageCell.detailTextLabel.text = remarks;
            messageCell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        } else {
            messageCell.detailTextLabel.text = @"给店主留言(选填)";
            messageCell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0xCCCCCC];
        }
        
        return messageCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
    NSNumber *num = [_sectionArray objectAtIndex:indexPath.section];
    if(HXSSectionTypeCoupon == num.integerValue) {
        if(![HXSUserAccount currentAccount].isLogin) { // 用户未登录，登录后匹配自动匹配优惠券
            [HXSLoginViewController showLoginController:self loginCompletion:^{
                [self didSelectCoupon:nil];
            }];
        } else {
          [self displayCouponSelectionActionSheet];
        }
        
    } else if(HXSSectionTypeDelivery == num.integerValue) { // 配送信息
        if(!self.deliveryInfoVC) {
            HXSDeliveryInfoViewController *deliveryInfoVC = [[HXSDeliveryInfoViewController alloc]initWithNibName:@"HXSDeliveryInfoViewController" bundle:nil];
            self.deliveryInfoVC = deliveryInfoVC;
            self.deliveryInfoVC.shopIdStr =  self.shopEntity.shopIDIntNum;
            self.deliveryInfoVC.delegate =  self;
        }
        
        if(self.selectDeliveryEntity)
            [self.deliveryInfoVC setSelectDeliveryEntity:self.selectDeliveryEntity selectDeliveryTime:self.selectDeliveryTime];
        
        
        [self.navigationController pushViewController:self.deliveryInfoVC animated:YES];
    
    } else if(HXSSectionTypeRemark == num.integerValue) { // 留言
        HXSDormEditRemarksViewController * remarksController = [HXSDormEditRemarksViewController controllerFromXib];
        [self.navigationController pushViewController:remarksController animated:YES];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == COUPON_POPOVER_TAG && buttonIndex == 1) { // 优惠券手动输入
        UITextField *textfield = [alertView textFieldAtIndex:0];
        
        if(textfield.text.length > 0) {
            [MBProgressHUD showInView:self.view];
            NSString * couponCode = textfield.text;
            
            __weak typeof(self) weakSelf = self;
            HXSCouponValidate *validateReq = [[HXSCouponValidate alloc] init];
            [validateReq validateWithToken:[HXSUserAccount currentAccount].strToken
                                couponCode: couponCode
                                      type: kHXSCouponScopePrint
                                  complete:^(HXSErrorCode code, NSString *message, HXSCoupon *coupon) {
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      
                                      if (code == kHXSNoError) {
                                          weakSelf.printCartEntity.couponCodeStr = coupon.couponCode;
                                          [weakSelf refreshPrintCarEntity];
                                      }
                                      else {
                                          [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.0];
                                      }
                                  }];
        }
    } else if (buttonIndex == 1 && alertView.tag == VERIFY_CODE_POPOVER_TAG) {
        UITextField *textfield=[alertView textFieldAtIndex:0];
        if(textfield.text.length < 6) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码为6位,请再次输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag = VERIFY_CODE_POPOVER_TAG;
            UITextField *textfield=[alertView textFieldAtIndex:0];
            textfield.keyboardType = UIKeyboardTypeNumberPad;
            [alertView show];
        } else {
            
            self.verifyCode = textfield.text;
            [self createPrintOrder];
        }
    }
}


#pragma mark -支付页面

/**
 *  跳转支付页面
 */
- (void)gotoPaymentViewController
{
    HXSPaymentOrderViewController *paymentOrderViewController = [HXSPaymentOrderViewController createPaymentOrderVCWithOrderInfo:[[HXSOrderInfo alloc] initWithOrderInfo:self.printOrderInfo] installment:NO];
    
    [self replaceCurrentViewControllerWith:paymentOrderViewController animated:YES];
}


#pragma mark - Private Method

- (void)updatePrintStoreCartInfo
{
    if(self.clearPrintStoreCart)
        self.clearPrintStoreCart();
}


#pragma mark - Getter Setter Methods

- (HXSCouponValidate *)validate
{
    if (nil == _validate) {
        _validate = [[HXSCouponValidate alloc] init];
    }
    
    return _validate;
}

@end

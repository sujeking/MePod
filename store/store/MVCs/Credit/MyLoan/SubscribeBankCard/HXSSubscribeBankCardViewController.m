//
//  HXSSubscribeBankCardViewController.m
//  59dorm
//
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSSubscribeBankCardViewController.h"

// VC
#import "HXSWebViewController.h"

//view
#import "HXSSubscribeProgressCell.h"
#import "HXSSubscribeHeaderFooterView.h"
#import "HXSSubscribeInputTableViewCell.h"
#import "UIRenderingButton.h"
#import "HXSCustomAlertView.h"
#import "HXSSubscribeSelectCell.h"
#import "HXSCustomPickerView.h"
#import "HXSSubscribeVaildNumCell.h"
#import "HXSSubscribeBankCardBottomCell.h"
#import "HXSPayPasswordAlertView.h"

//model
#import "NSString+Verification.h"
#import "HXSBusinessLoanViewModel.h"

#import "HXMyLoan.h"

static NSInteger const kLengthVerificationNum = 6;
static CGFloat const headerViewHeight         = 40;

typedef NS_ENUM(NSInteger,HXSSubscribeBankSectionIndex){
    HXSSubscribeBankSectionIndexProgress             = 0,//进程
    HXSSubscribeBankSectionIndexInput                = 1,//输入
};

typedef NS_ENUM(NSInteger, HXSSubscribeBankCardInputIndex){
    kHXSSubscribeBankCardInputIndexBank             = 0,//所属银行
    kHXSSubscribeBankCardInputIndexBankCardNum      = 1,//银行卡号
    kHXSSubscribeBankCardInputIndexPhoneNum         = 2,//预留手机号
    kHXSSubscribeBankCardInputIndexVerificationCode = 3,//验证码
    kHXSSubscribeBankCardInputIndexBottom           = 4,//底部

    kHXSSubscribeBankCardInputIndexCount            = 5,// 总个数
};

@interface HXSSubscribeBankCardViewController () <HXSPayPasswordAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView                        *mainTableView;
@property (nonatomic, strong) HXSSubscribeHeaderFooterView              *headerView;
@property (nonatomic, strong) HXSSubscribeHeaderFooterView              *footerView;
@property (nonatomic, strong) HXSRoundedButton                          *submitButton;

@property (nonatomic, strong) NSArray<UITableViewCell *>                *dataArray;
@property (nonatomic, strong) HXSSubscribeSelectCell                    *bankCell;//所属银行
@property (nonatomic, strong) HXSSubscribeInputTableViewCell            *cardCell;//银行卡号
@property (nonatomic, strong) HXSSubscribeInputTableViewCell            *phoneCell;//预留手机号
@property (nonatomic, strong) HXSSubscribeVaildNumCell                  *numVaildCell;//验证码

@property (nonatomic, strong) NSString                                  *currentBankCode;
@property (nonatomic, strong) HXSUserCreditcardBaseInfoEntity           *baseInfoEntity;

@property (nonatomic, strong) HXSPayPasswordAlertView                   *walletPasswordFirstAlertview;      //第一次59钱包支付密码设置
@property (nonatomic, strong) HXSPayPasswordAlertView                   *walletPasswordSecondAlertview;     //第二次59钱包支付密码验证



@end

@implementation HXSSubscribeBankCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTheMainTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - create

+ (instancetype)createSubscribeBankCardVC
{
    HXSSubscribeBankCardViewController *vc = [HXSSubscribeBankCardViewController controllerFromXib];
    
    return vc;
}


#pragma mark - init

- (void)initTheMainTableView
{
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSSubscribeProgressCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSSubscribeProgressCell class])];
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSSubscribeInputTableViewCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSSubscribeInputTableViewCell class])];
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSSubscribeSelectCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSSubscribeSelectCell class])];
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSSubscribeVaildNumCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSSubscribeVaildNumCell class])];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSSubscribeBankCardBottomCell class])
                                                   bundle:nil]
             forCellReuseIdentifier:NSStringFromClass([HXSSubscribeBankCardBottomCell class])];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    
    if(section == HXSSubscribeBankSectionIndexInput)
    {
        rows = kHXSSubscribeBankCardInputIndexCount;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.section == HXSSubscribeBankSectionIndexProgress)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSSubscribeProgressCell class]) forIndexPath:indexPath];
    }
    else
    {
        if (kHXSSubscribeBankCardInputIndexBottom == indexPath.row) {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSSubscribeBankCardBottomCell class]) forIndexPath:indexPath];
        } else {
            cell = [self.dataArray objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = cellInputHeight;
    
    if(indexPath.section == HXSSubscribeBankSectionIndexProgress) {
        height = subscribeProgressCellHeight;
    } else {
        if (indexPath.row == kHXSSubscribeBankCardInputIndexBottom) {
            height = subscribeAuthorizeBottomCellHeight;
        }
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    if(section == HXSSubscribeBankSectionIndexProgress) {
        height = headerViewHeight;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    if(section == HXSSubscribeBankSectionIndexProgress) {
        height = headerViewHeight;
    }
    
    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == HXSSubscribeBankSectionIndexProgress) {
        return self.headerView;
    }
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == HXSSubscribeBankSectionIndexProgress) {
        return self.footerView;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == HXSSubscribeBankSectionIndexProgress) {
        HXSSubscribeProgressCell *progressCell = (HXSSubscribeProgressCell *)cell;
        [progressCell initSubscribeProgressCellWithCurrentStepIndex:kHXSSubscribeStepIndexBankCard];
    } else {
        if (indexPath.row == kHXSSubscribeBankCardInputIndexBottom) {
            HXSSubscribeBankCardBottomCell *bottomCell = (HXSSubscribeBankCardBottomCell *)cell;
            _submitButton = bottomCell.submitButton;
            [bottomCell.submitButton addTarget:self
                                        action:@selector(submitTheApply)
                              forControlEvents:UIControlEventTouchUpInside];
            [bottomCell.openLoanContractButton addTarget:self
                                                  action:@selector(jumpToLoanContract)
                                        forControlEvents:UIControlEventTouchUpInside];
            [bottomCell.agreementBtn addTarget:self
                                        action:@selector(onClickAgreementBtn:)
                              forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == HXSSubscribeBankSectionIndexInput) {
        if(indexPath.row == 0
           && (nil == self.baseInfoEntity.bankNameStr)) { //所属银行
            [self fetchBankListNetworkingAndShowPickView];
        }
    }
}


/**
 *  获取银行列表并展示picker view
 */
- (void)fetchBankListNetworkingAndShowPickView
{
    if([[HXSBusinessLoanViewModel sharedManager] getMyLoanBankListModel]) {
        [self showThePickerView];
        return;
    }
    
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [[HXSBusinessLoanViewModel sharedManager] fetchBankListComplete:^(HXSErrorCode code, NSString *message, HXSMyLoanBankListModel *model){
        [HXSLoadingView closeInView:weakSelf.view];
        if(!model) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:0.8];
        } else {
            [weakSelf showThePickerView];
        }
    }];
}


#pragma mark - ShowPickView

/**
 *  弹出滚轮选择框
 *
 *  @param index
 */
- (void)showThePickerView
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray<HXSMyLoanBankModel *> *tempBankListArray = [[HXSBusinessLoanViewModel sharedManager] getMyLoanBankListModel].bankListArray;
    
    for (HXSMyLoanBankModel *model in tempBankListArray)
    {
        [array addObject:model.bankName];
    }
    __weak typeof(self) weakSelf = self;
    
    [HXSCustomPickerView showWithStringArray:array
                                defaultValue:@""
                                toolBarColor:UIColorFromRGB(0xFFFFFF)
                               completeBlock:^(int index, BOOL finished) {
                                 if(finished) {
                                     [weakSelf.bankCell.contentLabel setText:[array objectAtIndex:index]];
                                     [weakSelf.bankCell.contentLabel setTextColor:[UIColor colorWithRGBHex:0x4a4a4a]];
                                     weakSelf.currentBankCode = [tempBankListArray objectAtIndex:index].bankCode;
                                 }
                               }];
}


#pragma mark - Button Action

- (void)nextStepAction:(UIButton *)button
{
    HXSSubscribeBankParamModel *bankParamModel = [[HXSSubscribeBankParamModel alloc] init];
    
    bankParamModel.bankNameStr = self.bankCell.contentLabel.text;
    bankParamModel.bankCodeStr = self.currentBankCode;
    bankParamModel.cardNoStr = self.cardCell.valueTextField.text;
    bankParamModel.telephoneStr = self.phoneCell.valueTextField.text;
    bankParamModel.verifyCodeStr = self.numVaildCell.inputTextField.text;
    
    
    [MBProgressHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    [[HXSBusinessLoanViewModel sharedManager] addBankIdentifyWithParamModel:bankParamModel
                                                                   Complete:^(HXSErrorCode code, NSString *message, BOOL isSuccess) {
                                                                       [MBProgressHUD hideHUDForView:weakSelf.view
                                                                                            animated:YES];
                                                                       
                                                                       if (kHXSCreditCardErrorMoreFiveTimes == code) {
                                                                           [[HXSUserAccount currentAccount].userInfo updateUserInfo];
                                                                           
                                                                           [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                                              status:message
                                                                                                          afterDelay:1.5f
                                                                                                andWithCompleteBlock:^{
                                                                                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                                }];
                                                                           
                                                                           return;
                                                                       } else if (kHXSCreditCardErrorLessFiveTimes == code) {
                                                                           [weakSelf displayAlertViewWithMessage:message];
                                                                           
                                                                           return ;
                                                                       } else if (kHXSNoError != code) {
                                                                           [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                                              status:message
                                                                                                          afterDelay:1.5];
                                                                           
                                                                           return ;
                                                                       } else  {
                                                                           if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(subscribeBankNextStep)])
                                                                           {
                                                                               [weakSelf.delegate subscribeBankNextStep];
                                                                           }
                                                                           
                                                                           [[HXSUserAccount currentAccount].userInfo updateUserInfo];
                                                                       }
                                                                   }];
    
}

- (void)displayAlertViewWithMessage:(NSString *)message;
{
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒"
                                                                      message:message
                                                              leftButtonTitle:@"确定"
                                                            rightButtonTitles:nil];
    
    [alertView show];
}

- (void)verifyButtonClick
{
    if ([self.numVaildCell.verityButton isCounting]) {
        // Can't send anain when is counting.
        
        return;
    }
    
    [_numVaildCell.verityButton countingSeconds:MESSAGE_CODE_WAITING_TIME];
    
    [[HXSBusinessLoanViewModel sharedManager] fetchVerifyCodeWithPhone:self.phoneCell.valueTextField.text
                                                              Complete:^(HXSErrorCode code, NSString *message, BOOL isSuccess) {
                                                                  // Do nothing
                                                              }];
}


#pragma mark - HXSPayPasswordAlertViewDelegate

- (void)alertView:(HXSPayPasswordAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex passwd:(NSString *)passwd exemptionStatus:(NSNumber *)hasSelectedExemptionBoolNum
{
    if([alertView isEqual:_walletPasswordFirstAlertview])
    {
        if (1 == buttonIndex) {
            [self jumpToSubmitSuccessView];
        } else {
            _walletPasswordFirstAlertview = nil;
        }
    }
}


#pragma mark - ShowPassword view

- (void)showSetPayPasswordAlertViewWithTitle:(NSString *)titleStr
{
    HXSPayPasswordAlertView *alert = [[HXSPayPasswordAlertView alloc] initWithTitle:titleStr
                                                                            message:@""
                                                                           delegate:self
                                                                    leftButtonTitle:@"取消"
                                                                  rightButtonTitles:@"确定"];
    
    [alert show];
}


#pragma mark - Button Action

/**
 *  正式提交开通申请
 */
- (void)submitTheApply
{
    [self.walletPasswordFirstAlertview show];
}

/**
 *  跳转到经营贷、59钱包协议界面
 */
- (void)jumpToLoanContract
{
    NSString *baseURL = [[ApplicationSettings instance] currentCreditPayAgreementURL];
    
    HXSWebViewController *vc = [HXSWebViewController controllerFromXib];
    vc.url = [NSURL URLWithString:baseURL];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  跳转到申请成功界面
 */
- (void)jumpToSubmitSuccessView
{
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showInView:self.view];
    [[HXSBusinessLoanViewModel sharedManager] openMyLoanComplete:^(HXSErrorCode code, NSString *message, BOOL isOpen) {
        [MBProgressHUD hideHUDForView:weakSelf.view
                             animated:YES];
        
        if (kHXSCreditCardErrorMoreFiveTimes == code) {
            [[HXSUserAccount currentAccount].userInfo updateUserInfo];
            
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f
                                 andWithCompleteBlock:^{
                                     [weakSelf.navigationController popViewControllerAnimated:YES];
                                 }];
            
            return;
        } else if (kHXSCreditCardErrorLessFiveTimes == code) {
            [weakSelf displayAlertViewWithMessage:message];
            
            return ;
        } else if (kHXSNoError != code) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5];
            
            return ;
        } else  {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(subscribeBankNextStep)])
            {
                [weakSelf.delegate subscribeBankNextStep];
            }
            
            [[HXSUserAccount currentAccount].userInfo updateUserInfo];
        }
    }];
}


- (void)onClickAgreementBtn:(id)sender
{
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    
    [self checkInputInfoValidation];
}

#pragma mark CheckCurrentInput

/**
 *  检测输入框中的数据从而enable 下一步按钮
 */
- (void)checkInputInfoValidation
{
    _submitButton.enabled = [self isBasicInfoValid];
    
    if (![self.numVaildCell.verityButton isCounting]) {
        self.numVaildCell.verityButton.enabled = [self hasPhoneNumCheck];
    }
}

- (BOOL)isBasicInfoValid
{
    NSString *phoneStr = [_phoneCell.valueTextField.text trim];
    
    BOOL isEnable = ((0 < [_bankCell.contentLabel.text trim])
                     && (0 < [_cardCell.valueTextField.text trim])
                     && (0 < [phoneStr length])
                     && (0 < [_numVaildCell.inputTextField.text trim])
                     && [phoneStr isValidCellPhoneNumber]
                     && (kLengthVerificationNum == [self.numVaildCell.inputTextField.text length]));
    
    return isEnable;
}

- (BOOL)hasPhoneNumCheck
{
    BOOL isEnable = [_phoneCell.valueTextField.text trim] > 0
                    && [[_phoneCell.valueTextField.text trim] isValidCellPhoneNumber];
    
    return isEnable;
}

#pragma mark  setting the input field

- (void)settingTheInputField:(UITextField *)textField
                 withContent:(NSString *)contentStr
{
    if([contentStr trim] > 0)
    {
        [textField setText:contentStr];
        [textField setEnabled:NO];
    }
    
    [self checkInputInfoValidation];
}

#pragma mark getter setter

- (NSArray<UITableViewCell *> *)dataArray
{
    if(nil == _dataArray)
    {
        _dataArray = @[self.bankCell,
                       self.cardCell,
                       self.phoneCell,
                       self.numVaildCell];
    }
    return _dataArray;
}

- (HXSSubscribeSelectCell *)bankCell
{
    if(nil == _bankCell)
    {
        _bankCell = [HXSSubscribeSelectCell createSubscribeSelectCell];
        [_bankCell.titleNameLabel setText:@"所属银行"];
        [_bankCell.contentLabel   setText:@"请选择银行"];
        [_bankCell.contentLabel   setTextColor:[UIColor colorWithRGBHex:0xdbdbdb]];
        
        if(self.baseInfoEntity.bankNameStr
           && [self.baseInfoEntity.bankNameStr trim] > 0)
        {
            [_bankCell.contentLabel   setText:self.baseInfoEntity.bankNameStr];
            [_bankCell.contentLabel   setTextColor:[UIColor colorWithRGBHex:0x4a4a4a]];
        }
    }
    
    return _bankCell;
}

- (HXSSubscribeInputTableViewCell *)cardCell
{
    if(nil == _cardCell)
    {
        _cardCell = [HXSSubscribeInputTableViewCell createSubscribeInputTableViewCell];
        [_cardCell.keyLabel setText:@"银行卡号"];
        [_cardCell.valueTextField setPlaceholder:@"请填写银行卡号"];
        [_cardCell.valueTextField addTarget:self
                                          action:@selector(checkInputInfoValidation)
                                forControlEvents:UIControlEventEditingChanged];
        [_cardCell.valueTextField setKeyboardType:UIKeyboardTypeNumberPad];
        
        [self settingTheInputField:_cardCell.valueTextField withContent:self.baseInfoEntity.cardNoStr];
    }
    
    return _cardCell;
}

- (HXSSubscribeInputTableViewCell *)phoneCell
{
    if(nil == _phoneCell)
    {
        _phoneCell = [HXSSubscribeInputTableViewCell createSubscribeInputTableViewCell];
        [_phoneCell.keyLabel setText:@"预留手机号"];
        [_phoneCell.valueTextField setPlaceholder:@"请填写银行预留手机号码"];
        [_phoneCell.valueTextField addTarget:self
                                     action:@selector(checkInputInfoValidation)
                           forControlEvents:UIControlEventEditingChanged];
        [_phoneCell.valueTextField setKeyboardType:UIKeyboardTypePhonePad];
        
        [self settingTheInputField:_phoneCell.valueTextField withContent:self.baseInfoEntity.phoneStr];
    }
    
    return _phoneCell;
}

- (HXSSubscribeVaildNumCell *)numVaildCell
{
    if(nil == _numVaildCell)
    {
        _numVaildCell = [HXSSubscribeVaildNumCell createSubscribeVaildNumCell];
        
        [_numVaildCell.inputTextField addTarget:self
                                      action:@selector(checkInputInfoValidation)
                            forControlEvents:UIControlEventEditingChanged];
        [_numVaildCell.verityButton addTarget:self
                                       action:@selector(verifyButtonClick)
                             forControlEvents:UIControlEventTouchUpInside];
        [_numVaildCell.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    
    return _numVaildCell;
}


- (HXSSubscribeHeaderFooterView *)headerView
{
    if(nil == _headerView)
    {
        _headerView = [HXSSubscribeHeaderFooterView createSubscribeHeaderFooterViewWithContent:@"通过数据发现，90%的用户3分钟内都可以完成开通哦~"
                                                                                     andHeight:headerViewHeight
                                                                                   andFontSize:13
                                                                                  andTextColor:[UIColor colorWithRGBHex:0x07A9FA]];
        [_headerView setBackgroundColor:[UIColor colorWithRGBHex:0xE1FBFF]];
    }
    
    return _headerView;
}

- (HXSSubscribeHeaderFooterView *)footerView
{
    if(nil == _footerView)
    {
        _footerView = [HXSSubscribeHeaderFooterView createSubscribeHeaderFooterViewWithContent:@"请填写以下信息"
                                                                                     andHeight:headerViewHeight
                                                                                   andFontSize:13
                                                                                  andTextColor:[UIColor colorWithRGBHex:0x898989]];
    }
    
    return _footerView;
}

- (HXSUserCreditcardBaseInfoEntity *)baseInfoEntity
{
    HXSUserCreditcardBaseInfoEntity *baseInfoEntity = [HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity;
    
    return baseInfoEntity;
}

- (HXSPayPasswordAlertView *)walletPasswordFirstAlertview
{
    if(!_walletPasswordFirstAlertview)
    {
        _walletPasswordFirstAlertview = [[HXSPayPasswordAlertView alloc] initWithTitle:@"59钱包支付密码设置"
                                                                               message:@""
                                                                              delegate:self
                                                                       leftButtonTitle:@"取消"
                                                                     rightButtonTitles:@"确定"];
    }
    
    return _walletPasswordFirstAlertview;
}

- (HXSPayPasswordAlertView *)walletPasswordSecondAlertview
{
    if(!_walletPasswordSecondAlertview)
    {
        _walletPasswordSecondAlertview = [[HXSPayPasswordAlertView alloc] initWithTitle:@"59钱包支付密码验证"
                                                                                message:@""
                                                                               delegate:self
                                                                        leftButtonTitle:@"取消"
                                                                      rightButtonTitles:@"确定"];
    }
    
    return _walletPasswordSecondAlertview;
}



@end

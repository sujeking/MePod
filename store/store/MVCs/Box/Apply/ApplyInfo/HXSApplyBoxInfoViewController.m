//
//  HXSApplyBoxInfoViewController.m
//  store
//
//  Created by ArthurWang on 16/5/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSApplyBoxInfoViewController.h"
#import "HXSBindTelephoneController.h"
#import "HXSBoxMacro.h"

// Controllers
#import "HXSWebViewController.h"
#import "HXSTextSelectionViewController.h"
#import "HXSSubmitApplyViewController.h"

// Model
#import "HXSApplyBoxModel.h"
#import "HXSUserAccountModel.h"
#import "HXSApplyInfoEntity.h"
#import "HXSApplyBoxModel.h"
#import "HXSDormNegoziante.h"
#import "HXSBoxModel.h"
#import "TPKeyboardAvoidingScrollView.h"

#import "HXSSite.h"

// Views
#import "HXSActionSheet.h"

// Others

@interface HXSApplyBoxInfoViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *boxApplyScrollView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *entranceYearTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *buildingTextField;
@property (weak, nonatomic) IBOutlet UITextField *dormTextField;

@property (weak, nonatomic) IBOutlet UIButton *haveReadedBtn;
@property (weak, nonatomic) IBOutlet UITextView *protocolTextView;
@property (weak, nonatomic) IBOutlet HXSRoundedButton *confirmBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewConstraint;

@property (nonatomic, strong) HXSApplyBoxModel *applyBoxModel;
@property (nonatomic, strong) HXSApplyInfoEntity *applyInfoEntity;

@property (nonatomic, assign) HXSBoxGenderType genderType;

@end

@implementation HXSApplyBoxInfoViewController

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self inittialNavigtaionBar];
    
    [self initialButtons];
    
    [self initialTextFields];
    [self initInputNotifacationCenter];
    
    [self initialProtocal];
    
    [self addTapInView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.inputViewConstraint.constant = self.view.frame.size.width;
    HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;
    self.phoneTextField.text = basicInfo.phone;
    
    if(!(self.genderTypeTextField.text.length > 0)){
        self.genderType = basicInfo.gender;
    }
    
    [self.view layoutIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.nameTextField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.dormTextField];
}

#pragma mark - Initail Methods

- (void)inittialNavigtaionBar
{
    self.title = @"填写申请资料";
}

- (void)initialButtons
{
    [self.confirmBtn setBackgroundColor:HXS_BUTTON_TEXT_AND_LINK_COLOR];
    
    [self.haveReadedBtn setImage:[UIImage imageNamed:@"btn_choose_empty"]
                        forState:UIControlStateNormal];
    [self.haveReadedBtn setImage:[UIImage imageNamed:@"btn_choose_blue"]
                        forState:UIControlStateSelected];
    
    self.haveReadedBtn.selected = YES;
    self.confirmBtn.enabled = NO;
}

- (void)initInputNotifacationCenter
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.nameTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.dormTextField];
}


- (void)initialTextFields
{
    // 取夜猫店地址
    HXSLocationManager *locationManager = [HXSLocationManager manager];
    
    if ([locationManager.currentDorm.dormIdNum intValue] > 0) {
        NSMutableString *addressMStr = [NSMutableString stringWithFormat:@"%@%@%@", locationManager.currentSite.name, locationManager.buildingEntry.nameStr, locationManager.buildingEntry.buildingNameStr];
        self.buildingTextField.text = addressMStr;
        self.buildingTextField.textColor = [UIColor colorWithRGBHex:0x666666];
    }
    else {
        self.buildingTextField.text = nil;
    }
    
    self.buildingTextField.tintColor     = HXS_SEPARATION_LINE_COLOR;
    self.dormTextField.tintColor         = HXS_SEPARATION_LINE_COLOR;
    self.nameTextField.tintColor         = HXS_SEPARATION_LINE_COLOR;
    self.phoneTextField.tintColor        = HXS_SEPARATION_LINE_COLOR;
    self.entranceYearTextField.tintColor = HXS_SEPARATION_LINE_COLOR;
}

- (void)initialProtocal
{
    self.protocolTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.protocolTextView.editable = NO;
    
    NSString *beginStr = @"我已阅读";
    NSString *protocolStr = @" 零食盒协议 ";
    NSString *endStr = @"并同意协议";
    NSString *wholeStr = [NSString stringWithFormat:@"%@%@%@", beginStr, protocolStr, endStr];
    
    NSRange beginRange = [wholeStr rangeOfString:beginStr];
    NSRange protocolRange = [wholeStr rangeOfString:protocolStr];
    NSRange endRange = [wholeStr rangeOfString:endStr];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:15]
                          range:NSMakeRange(0, wholeStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromRGB(0x999999)
                          range:beginRange];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromRGB(0x54ADF9)
                          range:protocolRange];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromRGB(0x999999)
                          range:endRange];
    [attributedStr addAttribute:NSLinkAttributeName
                          value:[NSURL URLWithString:@"protocol://"]
                          range:protocolRange];
    NSDictionary *linkedDic = @{NSForegroundColorAttributeName:UIColorFromRGB(0x54ADF9),
                                NSUnderlineColorAttributeName:UIColorFromRGB(0x54ADF9),
                                NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
    
    self.protocolTextView.linkTextAttributes = linkedDic;
    self.protocolTextView.attributedText = attributedStr;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(jumpToBoxProtocal)];
    [self.protocolTextView addGestureRecognizer:tap];
}

- (void)addTapInView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissView)];
    
    [self.view setUserInteractionEnabled:YES];
    
    [self.view addGestureRecognizer:tap];
}


#pragma mark - Overrive Methods

- (void)back
{
    self.phoneTextField.delegate = nil;
    
    [super back];
}



#pragma mark - Target Methods

- (IBAction)onClickConfromBtn:(id)sender
{
    [self.view endEditing:YES];
    
    WS(weakSelf);
    [HXSUsageManager trackEvent:kUsageEventBoxApplySubmit parameter:nil];
    HXSLocationManager *boxLoMgr = [HXSLocationManager manager];
    HXSBuildingEntry *building = boxLoMgr.buildingEntry;
    
    NSNumber *dormentryIDNum = building.dormentryIDNum;
    
    [self.applyInfoEntity setApplyUserNameStr:self.nameTextField.text];
    [self.applyInfoEntity setApplyUserGenderNum:@(self.genderType)];
    [self.applyInfoEntity setApplyUserAdmissionDateStr:self.entranceYearTextField.text];
    [self.applyInfoEntity setApplyUserMobileStr:self.phoneTextField.text];
    [self.applyInfoEntity setApplyUserRoomStr:self.dormTextField.text];
    [self.applyInfoEntity setApplyUserDormentryIdNum:dormentryIDNum];
    [self.applyInfoEntity setApplyUserdormIdNum:boxLoMgr.currentDorm.dormIdNum];
    
    [HXSApplyBoxModel commitApplyInfoToServerWithApplyInfo:self.applyInfoEntity complete:^(HXSErrorCode code, NSString *message) {
        
        if(code == kHXSNoError) {
            HXSSubmitApplyViewController *submitApplyVC = [HXSSubmitApplyViewController controllerFromXib];
            [weakSelf.navigationController pushViewController:submitApplyVC animated:YES];
        
        } else {
              HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                                message:message
                                                                        leftButtonTitle:@"OK"
                                                                      rightButtonTitles:nil];
              [alertView show];

        }
    }];
}

- (IBAction)onClickReadedBtn:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    [self updateHaveReadedBtnStatus:!button.selected];
}

- (IBAction)onClickedPhoneBtn:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalInfo"
                                                         bundle:[NSBundle mainBundle]];
    HXSBindTelephoneController *telephoneVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSBindTelephoneController"];
    telephoneVC.isUpdate = !(self.phoneTextField.text.length < 1);
    [self.navigationController pushViewController:telephoneVC animated:YES];
}


#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.buildingTextField||textField == self.phoneTextField) {
        return NO;
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self updateConfirmButtonStats];
    
    if (textField == self.phoneTextField
        && (nil != textField.text)
        && ![@"" isEqualToString:textField.text]) {
        
        BOOL isMatch = [textField.text isValidCellPhoneNumber];
        
        if (!isMatch) {
            [textField resignFirstResponder];
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                              message:@"请输入正确的手机号码"
                                                                      leftButtonTitle:@"OK"
                                                                    rightButtonTitles:nil];
            alertView.leftBtnBlock = ^{
                [textField becomeFirstResponder];
            };
            [alertView show];
            
            
            return YES;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    [self jumpToBoxProtocal];
    
    return YES;
}


#pragma mark - Jump To Box Protocal

- (void)jumpToBoxProtocal
{
    HXSWebViewController *webVCtrl = [HXSWebViewController controllerFromXib];
    NSString *urlText = [[ApplicationSettings instance] currentBoxProtocolURL];
    webVCtrl.url = [NSURL URLWithString:urlText];
    [self.navigationController pushViewController:webVCtrl animated:YES];
    
}


#pragma mark - Private Methods

- (void)updateHaveReadedBtnStatus:(BOOL)status
{
    self.haveReadedBtn.selected = status;
    
    [self updateConfirmButtonStats];
}

- (void)updateConfirmButtonStats
{
    if (self.haveReadedBtn.selected
        && (0 < [self.buildingTextField.text length])
        && (0 < [self.dormTextField.text length])
        && (0 < [self.nameTextField.text length])
        && (0 < [self.genderTypeTextField.text length])
        && (0 < [self.phoneTextField.text length])
        && (0 < [self.entranceYearTextField.text length])) {
        
        BOOL isMatch = [self.phoneTextField.text isValidCellPhoneNumber];
        
        if (isMatch) {
            [self.confirmBtn setEnabled:YES];
        } else {
            [self.confirmBtn setEnabled:NO];
        }
    } else {
        [self.confirmBtn setEnabled:NO];
    }
}

- (void)dismissView
{
    [self.view endEditing:YES];
    [self updateConfirmButtonStats];
}

- (void)textFiledEditChanged:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    NSString *inputString = textField.text;
    
    if (textField == self.nameTextField || textField == self.dormTextField)
    {
        UITextInputMode *textInputMode = textField.textInputMode;
        NSString *lang = [textInputMode primaryLanguage];
        if ([lang isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textField markedTextRange];
            
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            
            if (!position)
            {
                if (inputString.length >= 8)
                {
                    textField.text = [inputString substringToIndex:8];
                }
            }
        }
        else
        {
            if (inputString.length >= 8)
            {
                textField.text = [inputString substringToIndex:8];
            }
        }
    }
    else
    {
        if (inputString.length >= 11)
        {
            textField.text = [inputString substringToIndex:11];
        }
    }
}


#pragma mark - Target / Action

- (IBAction)onClickEntranceYearBtn:(id)sender
{
    [self.view endEditing:YES];
    
    NSInteger currentYear = [[NSDate date] year];
    int count = 8;
    NSMutableArray *enrolledYears = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = count ; i >= 0 ; i--) {
        NSString * text = [NSString stringWithFormat:@"%li", (long)(currentYear - count + i)];
        [enrolledYears addObject:text];
    }
    
    __weak typeof(self) weakSelf = self;
    HXSTextSelectionViewController *vc = [[HXSTextSelectionViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.texts = enrolledYears;
    vc.title = @"选择入学年份";
    vc.completion = ^(NSString *text) {
        [HXSUsageManager trackEvent:kUsageEventBoxSchoolYear parameter:@{@"year":text}];
        weakSelf.entranceYearTextField.text = text;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)genderButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
    
    HXSActionSheetEntity *maleEntity = [[HXSActionSheetEntity alloc] init];
    maleEntity.nameStr = @"男";
    HXSAction *maleAction = [HXSAction actionWithMethods:maleEntity handler:^(HXSAction *action) {
        [HXSUsageManager trackEvent:kUsageEventBoxApplySexSelect parameter:@{@"sex":@"男"}];
        self.genderType = HXSBoxGenderTypeMale;
    }];
    
    HXSActionSheetEntity *femaleEntity = [[HXSActionSheetEntity alloc] init];
    femaleEntity.nameStr = @"女";
    HXSAction *femaleAction = [HXSAction actionWithMethods:femaleEntity handler:^(HXSAction *action) {
        [HXSUsageManager trackEvent:kUsageEventBoxApplySexSelect parameter:@{@"sex":@"女"}];
        self.genderType = HXSBoxGenderTypeFemale;
    }];
    
    [sheet addAction:maleAction];
    [sheet addAction:femaleAction];
    
    [sheet show];
}



#pragma mark - Getter Setter Methods

- (HXSApplyInfoEntity *)applyInfoEntity
{
    if (!_applyInfoEntity) {
        _applyInfoEntity = [[HXSApplyInfoEntity alloc] init];
    }
    return _applyInfoEntity;
}


- (HXSApplyBoxModel *)applyBoxModel
{
    if (nil == _applyBoxModel) {
        _applyBoxModel = [[HXSApplyBoxModel alloc] init];
    }
    
    return _applyBoxModel;
}

- (void)setGenderType:(HXSBoxGenderType)genderType
{
    _genderType = genderType;
    
    if (_genderType == HXSBoxGenderTypeMale) {
        _genderTypeTextField.text = @"男";
    }
    else if (_genderType == HXSBoxGenderTypeFemale) {
        _genderTypeTextField.text = @"女";
    }
    else {
        _genderTypeTextField.text        = nil;
        _genderTypeTextField.placeholder = @"请选择（性别决定盒子的款式哦）";
    }
    
    [self updateConfirmButtonStats];
}

@end

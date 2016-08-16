//
//  HXSModifyBoxInfoViewController.m
//  store
//
//  Created by 格格 on 16/7/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSModifyBoxInfoViewController.h"
#import "HXSModifyBoxInfoCell.h"
#import "HXSWebViewController.h"
#import "HXSBoxModel.h"
#import "HXSTextSelectionViewController.h"
#import "TPKeyboardAvoidingTableView.h"

@interface HXSModifyBoxInfoViewController ()<UITableViewDelegate,
                                            UITableViewDataSource,
                                            UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet TPKeyboardAvoidingTableView *myTable;

@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *haveReadedBtn;
@property (nonatomic, strong) UITextView *protocolTextView;
@property (nonatomic, strong) UIView *tableFooterView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) HXSBoxInfoEntity *boxInfo;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) HXSBoxUserEntity *shareUser;

// cell
@property (nonatomic, strong) HXSModifyBoxInfoCell *nameCell;
@property (nonatomic, strong) HXSModifyBoxInfoCell *ganderCell;
@property (nonatomic, strong) HXSModifyBoxInfoCell *schoolYearCell;
@property (nonatomic, strong) HXSModifyBoxInfoCell *phoneCell;
@property (nonatomic, strong) HXSModifyBoxInfoCell *addressCell;
@property (nonatomic, strong) HXSModifyBoxInfoCell *roomNumCell;

@end

@implementation HXSModifyBoxInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initInputNotifacationCenter];
    [self initialMyTable];
    [self fetBoxShareInfo];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.submitButton.enabled = [self chackSubmitButtonIfEnable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.roomNumCell.valueTextField];
}

+ (instancetype)controllerWithBoxInfo:(HXSBoxInfoEntity *)boxInfoEntity
                            messageId:(NSString *)message_id;{
    HXSModifyBoxInfoViewController *controller = [[HXSModifyBoxInfoViewController alloc]initWithNibName:nil bundle:nil];
    controller.boxInfo = boxInfoEntity;
    controller.messageId = message_id;
    return controller;
}

#pragma mark - webservice

- (void)fetBoxShareInfo{
    
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [HXSBoxModel fetchBoxSharedInfoWithUid:[HXSUserAccount currentAccount].userID complete:^(HXSErrorCode code, NSString *message, HXSBoxUserEntity *boxShare) {
        [HXSLoadingView closeInView:weakSelf.view];
        if(kHXSNoError == code){
            weakSelf.shareUser = boxShare;
            weakSelf.submitButton.enabled = [weakSelf chackSubmitButtonIfEnable];
        }else{
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

- (void)submitButtonClicked{
    
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    HXSBoxUserEntity *temp = [[HXSBoxUserEntity alloc]init];
    temp.unameStr = self.nameCell.valueTextField.text;
    temp.phoneStr = self.phoneCell.valueTextField.text;
    temp.dormentryIdNum = self.boxInfo.boxerInfo.dormentryIdNum;
    temp.roomStr = self.roomNumCell.valueTextField.text;
    temp.genderNum = self.boxInfo.boxerInfo.genderNum;
    temp.enrollmentYearNum = @(self.schoolYearCell.valueTextField.text.intValue);
    
    [HXSBoxModel handleBoxTransterWithBoxId:self.boxInfo.boxIdNum
                                        uid:[HXSUserAccount currentAccount].userID
                                     action:@(kHXSBoxMessageEventButtonTypeAccept)
                                  messageId:self.messageId
                              boxUserEntity:temp
                                   complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                       [HXSLoadingView closeInView:weakSelf.view];
                                       if(kHXSNoError == code){
                                           if(weakSelf.transterSuccessedBlock){
                                               weakSelf.transterSuccessedBlock();
                                           }
                                           [weakSelf.navigationController popViewControllerAnimated:YES];

                                           HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"转让成功" message:@"您已经成为零食盒的盒主" leftButtonTitle:@"确定" rightButtonTitles:nil];
                                           [alert show];
                                           
                                           
                                        }else{
                                           [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                       }
    }];
}

#pragma mark - Target/Action
- (void)jumpToBoxProtocal
{
    HXSWebViewController *webVCtrl = [HXSWebViewController controllerFromXib];
    NSString *urlText = [[ApplicationSettings instance] currentBoxProtocolURL];
    webVCtrl.url = [NSURL URLWithString:urlText];
    [self.navigationController pushViewController:webVCtrl animated:YES];
    
}

#pragma mark - privateMethod

- (BOOL)chackSubmitButtonIfEnable{
    if(self.nameCell.valueTextField.text.length > 0
       &&self.ganderCell.valueTextField.text.length > 0
       &&self.schoolYearCell.valueTextField.text.length > 0
       &&self.phoneCell.valueTextField.text.length > 0
       &&self.addressCell.valueTextField.text.length > 0
       &&self.roomNumCell.valueTextField.text.length > 0
       &&self.haveReadedBtn.selected
       ){
        return YES;
    }
    return NO;
}

- (void)textFiledEditChanged:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    NSString *inputString = textField.text;
    
    if (textField == self.roomNumCell.valueTextField)
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
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.submitButton.enabled = [self chackSubmitButtonIfEnable];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HXSModifyBoxInfoCell *cell = [self.dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HXSModifyBoxInfoCell *cell = [self.dataArray objectAtIndex:indexPath.row];
    if(cell == self.schoolYearCell){
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
            weakSelf.schoolYearCell.valueTextField.text = text;
            weakSelf.submitButton.enabled = [weakSelf chackSubmitButtonIfEnable];
        };
        [self.navigationController pushViewController:vc animated:YES];
    
    }
}


#pragma mark - initial

- (void)initNav{
    self.navigationItem.title = @"完善资料";
}

- (void)initInputNotifacationCenter
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.roomNumCell.valueTextField];
}

- (void)initialMyTable{
    
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.myTable setTableFooterView:self.tableFooterView];
    [self.myTable setBackgroundColor:HXS_COLOR_BACKGROUND_MAIN];
}

#pragma mark - setter

- (void)setShareUser:(HXSBoxUserEntity *)shareUser{
    if(_shareUser)
        _shareUser = nil;
    _shareUser = shareUser;
    
    self.nameCell.valueTextField.text = shareUser.unameStr;
    self.phoneCell.valueTextField.text = [HXSUserAccount currentAccount].userInfo.basicInfo.phone;
}

- (void)setBoxInfo:(HXSBoxInfoEntity *)boxInfo{
    if(_boxInfo)
        _boxInfo = nil;
    
    _boxInfo = boxInfo;
    self.ganderCell.valueTextField.text = boxInfo.boxerInfo.genderNum.intValue == HXSBoxGenderTypeMale ? @"男":@"女";
    self.schoolYearCell.valueTextField.text = [NSString stringWithFormat:@"%d",boxInfo.boxerInfo.enrollmentYearNum.intValue];
    self.addressCell.valueTextField.text = boxInfo.boxerInfo.addressStr;
    self.roomNumCell.valueTextField.text = boxInfo.boxerInfo.roomStr;
}

#pragma mark - getter

- (NSArray *)dataArray{
    if(!_dataArray){
        _dataArray = @[self.nameCell,
                       self.ganderCell,
                       self.schoolYearCell,
                       self.phoneCell,
                       self.addressCell,
                       self.roomNumCell];
    }
    return _dataArray;
}

- (UIButton *)haveReadedBtn{
    if(!_haveReadedBtn){
        _haveReadedBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, 25, 25)];
        [_haveReadedBtn setImage:[UIImage imageNamed:@"btn_choose_empty"]
                            forState:UIControlStateNormal];
        [_haveReadedBtn setImage:[UIImage imageNamed:@"btn_choose_blue"]
                            forState:UIControlStateSelected];
        _haveReadedBtn.selected = YES;
    }
    return _haveReadedBtn;
}

- (UITextView *)protocolTextView{
    if(!_protocolTextView){
        _protocolTextView = [[UITextView alloc]initWithFrame:CGRectMake(45, 17, SCREEN_WIDTH - 30 - 10 - 25, 25)];
        _protocolTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        _protocolTextView.editable = NO;
        _protocolTextView.showsVerticalScrollIndicator = NO;
        _protocolTextView.scrollEnabled = NO;
        [_protocolTextView setBackgroundColor:[UIColor clearColor]];
        
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
        
        _protocolTextView.linkTextAttributes = linkedDic;
        _protocolTextView.attributedText = attributedStr;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(jumpToBoxProtocal)];
        [_protocolTextView addGestureRecognizer:tap];
    }
    return _protocolTextView;
}

- (UIButton *)submitButton{
    if(!_submitButton){
        _submitButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 65, SCREEN_WIDTH - 30, 44)];
        _submitButton.layer.cornerRadius = 4;
        _submitButton.layer.masksToBounds = YES;
        [_submitButton setTitle:@"提交申请" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor colorWithR:255 G:255 B:255 A:0.5] forState:UIControlStateDisabled];
        [_submitButton setBackgroundColor:HXS_COLOR_MASTER];
        [_submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (UIView *)tableFooterView{
    if(!_tableFooterView){
        _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 129)];
        [_tableFooterView setBackgroundColor:HXS_COLOR_BACKGROUND_MAIN];
        [_tableFooterView addSubview:self.haveReadedBtn];
        [_tableFooterView addSubview:self.protocolTextView];
        [_tableFooterView addSubview:self.submitButton];
    }
    return _tableFooterView;
}

- (HXSModifyBoxInfoCell *)nameCell{
    if(!_nameCell){
        _nameCell = [HXSModifyBoxInfoCell modifyBoxInfoCell];
        _nameCell.keyLabel.text = @"姓名";
        _nameCell.valueTextField.enabled = NO;
        _nameCell.valueTextField.placeholder = @"请填写";
    }
    return _nameCell;
}

- (HXSModifyBoxInfoCell *)ganderCell{
    if(!_ganderCell){
        _ganderCell = [HXSModifyBoxInfoCell modifyBoxInfoCell];
        _ganderCell.keyLabel.text = @"性别";
        _ganderCell.valueTextField.enabled = NO;
        _ganderCell.valueTextField.placeholder = @"请选择";
    }
    return _ganderCell;
}

- (HXSModifyBoxInfoCell *)schoolYearCell{
    if(!_schoolYearCell){
        _schoolYearCell = [HXSModifyBoxInfoCell modifyBoxInfoCell];
        _schoolYearCell.keyLabel.text = @"入学年份";
        _schoolYearCell.valueTextField.enabled = NO;
        _schoolYearCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _schoolYearCell.valueTextField.placeholder = @"请选择";
    }
    return _schoolYearCell;
}

- (HXSModifyBoxInfoCell *)phoneCell{
    if(!_phoneCell){
        _phoneCell = [HXSModifyBoxInfoCell modifyBoxInfoCell];
        _phoneCell.keyLabel.text = @"手机号码";
        _phoneCell.valueTextField.enabled = NO;
        _phoneCell.valueTextField.placeholder = @"请输入";
    }
    return _phoneCell;
}

- (HXSModifyBoxInfoCell *)addressCell{
    if(!_addressCell){
        _addressCell = [HXSModifyBoxInfoCell modifyBoxInfoCell];
        _addressCell.keyLabel.text = @"寝室地址";
        _addressCell.valueTextField.enabled = NO;
        _addressCell.valueTextField.placeholder = @"请选择";
    }
    return _addressCell;
}

- (HXSModifyBoxInfoCell *)roomNumCell{
    if(!_roomNumCell){
        _roomNumCell = [HXSModifyBoxInfoCell modifyBoxInfoCell];
        _roomNumCell.keyLabel.text = @"寝室号";
        _roomNumCell.valueTextField.delegate = self;
        _roomNumCell.valueTextField.placeholder = @"请输入";
    }
    return _roomNumCell;
}

@end

//
//  HXSBoxShareViewController.m
//  store
//
//  Created by ArthurWang on 16/5/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxShareViewController.h"
#import "HXSBoxModel.h"
#import "HXSBoxShareModel.h"
#import "HXSBoxOwnerInfoView.h"
#import "TPKeyboardAvoidingTableView.h"

static CGFloat const kKeyLableWidth =  80.0f;
static CGFloat const kCellHeight =  44.0f;

@interface HXSBoxShareViewController ()<UITableViewDelegate,
                                        UITableViewDataSource,
                                        UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet TPKeyboardAvoidingTableView *myTable;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *phoneTextField;

@property (nonatomic, strong) HXSBoxInfoEntity *boxInfoEntity;
@property (nonatomic, strong) HXSBoxOwnerInfoView *boxOwnerInfoView;

@end

@implementation HXSBoxShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialNav];
    [self initInputNotifacationCenter];
    [self initialParma];
    [self initialTable];
    [self fetchBoxInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
      [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.nameTextField];

}


#pragma mark - initial

- (void)initInputNotifacationCenter
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.nameTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.phoneTextField];
}

- (void)initialNav{
   self.navigationItem.title = @"分享零食盒";
}

- (void)initialParma{
    
    self.shareButton.layer.borderWidth = 1;
    self.shareButton.layer.borderColor = HXS_COLOR_SEPARATION_STRONG.CGColor;
    [self.shareButton setTitleColor:HXS_COLOR_MASTER forState:UIControlStateNormal];
    [self.shareButton setTitleColor:HXS_INFO_NOMARL_COLOR forState:UIControlStateDisabled];
    [self.shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.shareButton.enabled = NO;
}

- (void)initialTable{
    
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.myTable setBackgroundColor:self.view.backgroundColor];
    self.myTable.rowHeight = kCellHeight;
    
    UIView *tableViewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [tableViewHeader addSubview:self.boxOwnerInfoView];
    [self.boxOwnerInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableViewHeader);
    }];
    [self.myTable setTableHeaderView:tableViewHeader];
}

#pragma mark - webService

- (void)fetchBoxInfo
{
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [HXSBoxModel fetchBoxInfo:^(HXSErrorCode code, NSString *message, HXSBoxInfoEntity *boxInfoEntity) {
        [HXSLoadingView closeInView:weakSelf.view];
        
        if(kHXSNoError == code){
            weakSelf.boxInfoEntity = boxInfoEntity;
            [weakSelf.boxOwnerInfoView initialBoxInfo:boxInfoEntity];
        }else{
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

- (void)shareBox
{
    [HXSLoadingView showLoadingInView:self.view];

    __weak typeof(self) weakSelf = self;
    [HXSBoxShareModel shareBoxWithName:self.nameTextField.text
                                 phone:self.phoneTextField.text
                              complete:^(HXSErrorCode code, NSString *message, NSDictionary *data) {
        [HXSLoadingView closeInView:weakSelf.view];
        
        if(kHXSNoError == code){
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            if(code == 7022){
                HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"分享失败"
                                                                             message:message
                                                                     leftButtonTitle:@"确定"
                                                                   rightButtonTitles:nil];
                [alert show];
            }else{
                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
            }
        }
    }];
}

#pragma mark - Target/Action
- (void)shareButtonClicked{
    
    NSString *message = [NSString stringWithFormat:@"您确定把零食盒分享给%@",self.nameTextField.text];
    HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"确认分享" message:message leftButtonTitle:@"取消" rightButtonTitles:@"确定"];
    
    __weak typeof(self) weakSelf = self;
    alert.rightBtnBlock = ^{
        [weakSelf shareBox];
    };
    [alert show];
}

#pragma mark - others
- (void)refreshBoxinfo{
    self.shareButton.hidden = NO;

}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.nameTextField.text.length > 0 && self.phoneTextField.text.length > 0)
        self.shareButton.enabled = YES;
    else
        self.shareButton.enabled = NO;
}

- (void)textFiledEditChanged:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    NSString *inputString = textField.text;
    
    if (textField == self.nameTextField)
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
    }else if(textField == self.phoneTextField){
        if (inputString.length >= 11)
            {
                textField.text = [inputString substringToIndex:11];
            }
        }
}


#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.textLabel setTextColor:HXS_TITLE_NOMARL_COLOR];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        cell.textLabel.text = @"姓名";
        [cell.contentView addSubview:self.nameTextField];
    }else{
        cell.textLabel.text = @"手机";
        [cell.contentView addSubview:self.phoneTextField];
    }
}

#pragma mark - GET && SET Methods

- (UITextField *)nameTextField{
    if(!_nameTextField){
        _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(kKeyLableWidth,0, SCREEN_WIDTH - kKeyLableWidth , kCellHeight)];
        _nameTextField.delegate = self;
        _nameTextField.placeholder = @"请填写共享人的姓名";
        [_nameTextField setFont:[UIFont systemFontOfSize:14]];
    }
    return _nameTextField;
}

- (UITextField *)phoneTextField{
    if(!_phoneTextField){
        _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(kKeyLableWidth,0, SCREEN_WIDTH - kKeyLableWidth , kCellHeight)];
        _phoneTextField.delegate = self;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.placeholder = @"请填写共享人的手机";
        [_phoneTextField setFont:[UIFont systemFontOfSize:14]];
    }
    return _phoneTextField;
}

- (HXSBoxOwnerInfoView *)boxOwnerInfoView{
    if(!_boxOwnerInfoView){
        _boxOwnerInfoView = [HXSBoxOwnerInfoView initFromXib];
    }
    return _boxOwnerInfoView;
}

- (void)setBoxInfoEntity:(HXSBoxInfoEntity *)boxInfoEntity{
    _boxInfoEntity = boxInfoEntity;
    [self refreshBoxinfo];
}

@end

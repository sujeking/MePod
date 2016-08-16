//
//  HXSChangeNicknameViewController.m
//  store
//
//  Created by ranliang on 15/7/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSChangeSingleLineViewController.h"

#import "HXSPersonalInfoModel.h"

@interface HXSChangeSingleLineViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property (nonatomic, strong) HXSPersonalInfoModel *personalInfoModle;
@property (nonatomic, strong) UIButton *rightBarBtn;

@end

@implementation HXSChangeSingleLineViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self InitialTextField];
    
    [self initialNotification];
    
    [self configMode];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Initial Methdos

- (void)initialNavigationBar
{
    UIButton *leftBtn = [self buttonWithTitle:@"取消"];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [self buttonWithTitle:@"保存"];
    [rightBtn addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.rightBarBtn = rightBtn;
    if(self.type == HXSModifyAccountInfoNickname) {
        self.rightBarBtn.enabled = NO;
    }
}

- (void)InitialTextField
{
    [self.textField setTintColor:[UIColor darkGrayColor]];
    self.textField.delegate = self;
    self.textField.text = self.text;
}

- (void)initialNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFildChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)configMode
{
    switch (self.type) {
        case HXSModifyAccountInfoNickname: {
            self.title = @"昵称";
            self.textField.placeholder = @"填写昵称";
            self.promptLabel.text = @"昵称建议使用2-12位(中文、英文、数字及下划线)";
            break;
        }
            
        case HXSModifyAccountInfoUsername: {
            self.title = @"修改收货人";
            self.textField.placeholder = @"填写收货人姓名";
            self.promptLabel.text = @"请输入真名";
            break;
        }
            
        case HXSModifyAccountInfoCellNumber: {
            self.title = @"修改手机号";
            self.promptLabel.text = @"";
            break;
        }
            
        default:
            break;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //for unwindToPersonalInfoTableViewController
    NSString *text = self.textField.text;
    if(text.length > 12) {
        text = [text substringToIndex:12];
    }
    self.text = text;
}


#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - Save Info

- (void)saveButtonTapped:(UIButton *)sender
{
    switch (self.type) {
        case HXSModifyAccountInfoNickname: {
            if(![self.textField.text isValidNickname]) {
                [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请使用中文、英文、数字及下划线" afterDelay:2.0];
                
                return;
            }
            
            NSString *text = self.textField.text;
            if(text.length > 12) {
                text = [text substringToIndex:12];
            }
            [HXSLoadingView showLoadingInView:self.view];
            
            __weak typeof(self) weakSelf = self;
            [self.personalInfoModle updateNickName:text
                                         complete:^(HXSErrorCode code, NSString *message, NSDictionary *nickNameDic) {
                                             [HXSLoadingView closeInView:weakSelf.view];
                                             
                                             if (kHXSNoError != code) {
                                                 [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                    status:message
                                                                                afterDelay:1.5f];
                                                 
                                                 return ;
                                             }
                                             
                                             [weakSelf performSegueWithIdentifier:@"changeSingleLineVCToPersonalInfoTableVC" sender:weakSelf];
                                         }];
            
            break;
        }
            
        case HXSModifyAccountInfoUsername: {
            break;
        }
            
        case HXSModifyAccountInfoCellNumber: {
            break;
        }
            
        default:
            break;
    }
    
}

#pragma mark - Private Methods

- (void)textFildChanged:(id)sender {
    
    NSMutableString *resultMStr = [[NSMutableString alloc] initWithString:self.textField.text];
    
    if (self.type == HXSModifyAccountInfoNickname) {
        if (self.textField.markedTextRange == nil && resultMStr.length > 12) {
            self.textField.text = [resultMStr substringToIndex:12];
        }
    }
    
    [self updateRightBarBtnStatus];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.type == HXSModifyAccountInfoNickname) {
        if ([string length] == 0 || textField.markedTextRange != nil)
        {
            return YES;
        }
        
        if (([string length] + [textField.text length] > 12 ) )
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)updateRightBarBtnStatus
{
    if (0 < [self.textField.text length]) {
        [self.rightBarBtn setEnabled:YES];
    } else {
        [self.rightBarBtn setEnabled:NO];
    }
    
    if (self.type == HXSModifyAccountInfoNickname) {
        if (1 < [self.textField.text length]) {
            [self.rightBarBtn setEnabled:YES];
        } else {
            [self.rightBarBtn setEnabled:NO];
        }
    }
}

- (UIButton *)buttonWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor highlightedColorFromColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithARGBHex:0x66FFFFFF] forState:UIControlStateDisabled];
    btn.frame = CGRectMake(0, 0, 35, 40);
    
    return btn;
}


#pragma mark - Setter Getter Methods

- (HXSPersonalInfoModel *)personalInfoModle
{
    if (nil == _personalInfoModle) {
        _personalInfoModle = [[HXSPersonalInfoModel alloc] init];
    }
    
    return _personalInfoModle;
}

@end

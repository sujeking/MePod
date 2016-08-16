//
//  HXSSubscribeIDViewController.m
//  59dorm
//
//  Created by J006 on 16/7/7.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSSubscribeIDViewController.h"

//view
#import "HXSSubscribeProgressCell.h"
#import "HXSSubscribeHeaderFooterView.h"
#import "HXSSubscribeInputTableViewCell.h"
#import "UIRenderingButton.h"
#import "NSString+Verification.h"
#import "HXSCustomAlertView.h"

//model
#import "HXSBusinessLoanViewModel.h"

#import "HXMyLoan.h"


static CGFloat const headerViewHeight   = 40;
static CGFloat const nextStepViewHeight = 115;

typedef NS_ENUM(NSInteger,HXSSubscribeIDSectionIndex){
    HXSSubscribeIDSectionIndexProgress             = 0,//进程
    HXSSubscribeIDSectionIndexInput                = 1,//输入
    
    HXSSubscribeIDSectionCount                     = 2, // section个数
};

@interface HXSSubscribeIDViewController ()

@property (weak, nonatomic) IBOutlet UITableView                        *mainTableView;

@property (nonatomic, strong) HXSSubscribeHeaderFooterView              *headerView;
@property (nonatomic, strong) HXSSubscribeHeaderFooterView              *footerView;
@property (nonatomic, strong) UIView                                    *nextStepView;
@property (nonatomic, strong) HXSRoundedButton                          *nextStepButton;

/**姓名*/
@property (nonatomic, strong) HXSSubscribeInputTableViewCell            *nameCell;
/**身份证号码*/
@property (nonatomic, strong) HXSSubscribeInputTableViewCell            *idCell;
/**邮箱*/
@property (nonatomic, strong) HXSSubscribeInputTableViewCell            *mailCell;
/**邀请码*/
@property (nonatomic, strong) HXSSubscribeInputTableViewCell            *invitationCodeCell;

@property (nonatomic, strong) NSArray<HXSSubscribeInputTableViewCell *> *dataArray;
@property (nonatomic, strong) HXSUserCreditcardBaseInfoEntity *baseInfoEntity;

@end

@implementation HXSSubscribeIDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTheMainTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - create

+ (instancetype)createSubscribeIDVC
{
    HXSSubscribeIDViewController *vc = [HXSSubscribeIDViewController controllerFromXib];
    
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
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return HXSSubscribeIDSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    
    if(section == HXSSubscribeIDSectionIndexInput) {
        rows = [self.dataArray count];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.section == HXSSubscribeIDSectionIndexProgress) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSSubscribeProgressCell class]) forIndexPath:indexPath];
    } else {
        cell = [self.dataArray objectAtIndex:indexPath.row];
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = cellInputHeight;
    
    if(indexPath.section == HXSSubscribeIDSectionIndexProgress) {
        height = subscribeProgressCellHeight;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    if(section == HXSSubscribeIDSectionIndexProgress) {
        height = headerViewHeight;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    if(section == HXSSubscribeIDSectionIndexProgress) {
        height = headerViewHeight;
    } else {
        height = nextStepViewHeight;
    }
    
    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == HXSSubscribeIDSectionIndexProgress) {
        return self.headerView;
    }
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == HXSSubscribeIDSectionIndexProgress) {
        return self.footerView;
    }
    
    return self.nextStepView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == HXSSubscribeIDSectionIndexProgress) {
        HXSSubscribeProgressCell *progressCell = (HXSSubscribeProgressCell *)cell;
        [progressCell initSubscribeProgressCellWithCurrentStepIndex:kHXSSubscribeStepIndexID];
    }
}


#pragma mark - CheckCurrentInput

/**
 *  检测输入框中的数据从而enable 下一步按钮
 */
- (void)checkInputInfoValidation
{
    self.nextStepButton.enabled = [self isBasicInfoValid];
}

- (BOOL)isBasicInfoValid
{
    NSString *nameStr = [_nameCell.valueTextField.text trim];
    NSString *idStr   = [_idCell.valueTextField.text trim];
    NSString *mailStr = [_mailCell.valueTextField.text trim];
    
    BOOL isEnable = ([nameStr length] > 0
                    && [idStr length] > 0
                    && [mailStr length] > 0
                    && [idStr isValidPRCResidentIDCardNumber]
                    && [mailStr isValidEmailAddress]);
    
    
    return isEnable;
}


#pragma mark - Button Action

- (void)nextStepAction:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    HXSSubscribeIDParamModel *subscribeIDParamModel = [[HXSSubscribeIDParamModel alloc] init];
    subscribeIDParamModel.nameStr           = self.nameCell.valueTextField.text;
    subscribeIDParamModel.idCardNoStr       = self.idCell.valueTextField.text;
    subscribeIDParamModel.emailStr          = self.mailCell.valueTextField.text;
    subscribeIDParamModel.invitationCodeStr = self.invitationCodeCell.valueTextField.text;
    
    [MBProgressHUD showInView:self.view];
    [[HXSBusinessLoanViewModel sharedManager] addIdentifyInforWithParamModel:subscribeIDParamModel
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
                                                                            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(subscribeIDNextStep)])
                                                                            {
                                                                                [weakSelf.delegate subscribeIDNextStep];
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


#pragma mark - setting the input field

- (void)settingTheInputField:(UITextField *)textField
                 withContent:(NSString *)contentStr
{
    if([contentStr trim] > 0) {
        [textField setText:contentStr];
        [textField setEnabled:NO];
    }
    
    [self checkInputInfoValidation];
}

#pragma mark getter setter

- (NSArray *)dataArray
{
    if(nil == _dataArray) {
        _dataArray = @[self.nameCell,
                       self.idCell,
                       self.mailCell,
                       self.invitationCodeCell];
    }
    return _dataArray;
}

- (HXSSubscribeInputTableViewCell *)nameCell
{
    if(nil == _nameCell) {
        _nameCell = [HXSSubscribeInputTableViewCell createSubscribeInputTableViewCell];
        
        [_nameCell.keyLabel setText:@"姓名"];
        [_nameCell.valueTextField setPlaceholder:@"请输入您的姓名"];
        [_nameCell.valueTextField addTarget:self
                                     action:@selector(checkInputInfoValidation)
                           forControlEvents:UIControlEventEditingChanged];
        [self settingTheInputField:_nameCell.valueTextField withContent:self.baseInfoEntity.nameStr];
    }
    return _nameCell;
}

- (HXSSubscribeInputTableViewCell *)idCell
{
    if(nil == _idCell) {
        _idCell = [HXSSubscribeInputTableViewCell createSubscribeInputTableViewCell];
        [_idCell.keyLabel setText:@"身份证号"];
        [_idCell.valueTextField setPlaceholder:@"请输入您的身份证号"];
        [_idCell.valueTextField addTarget:self
                                   action:@selector(checkInputInfoValidation)
                         forControlEvents:UIControlEventEditingChanged];
        [self settingTheInputField:_idCell.valueTextField withContent:self.baseInfoEntity.idCardNoStr];
    }
    return _idCell;
}

- (HXSSubscribeInputTableViewCell *)mailCell
{
    if(nil == _mailCell) {
        _mailCell = [HXSSubscribeInputTableViewCell createSubscribeInputTableViewCell];
        [_mailCell.keyLabel setText:@"邮箱地址"];
        [_mailCell.valueTextField setPlaceholder:@"请输入您的常用邮箱"];
        [_mailCell.valueTextField addTarget:self
                                     action:@selector(checkInputInfoValidation)
                           forControlEvents:UIControlEventEditingChanged];
        [_mailCell.valueTextField setKeyboardType:UIKeyboardTypeEmailAddress];
        [self settingTheInputField:_mailCell.valueTextField withContent:self.baseInfoEntity.emailNameStr];
    }
    return _mailCell;
}

- (HXSSubscribeInputTableViewCell *)invitationCodeCell
{
    if(nil == _invitationCodeCell) {
        _invitationCodeCell = [HXSSubscribeInputTableViewCell createSubscribeInputTableViewCell];
        [_invitationCodeCell.keyLabel setText:@"邀请码"];
        [_invitationCodeCell.valueTextField setPlaceholder:@"非必填项"];
        [_invitationCodeCell.valueTextField addTarget:self
                                     action:@selector(checkInputInfoValidation)
                           forControlEvents:UIControlEventEditingChanged];
        [_invitationCodeCell.valueTextField setKeyboardType:UIKeyboardTypeNumberPad];
        
        [self settingTheInputField:_invitationCodeCell.valueTextField withContent:nil];
    }
    return _invitationCodeCell;
}

- (HXSSubscribeHeaderFooterView *)headerView
{
    if(nil == _headerView) {
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
    if(nil == _footerView) {
        _footerView = [HXSSubscribeHeaderFooterView createSubscribeHeaderFooterViewWithContent:@"请填写以下信息"
                                                                                     andHeight:headerViewHeight
                                                                                   andFontSize:13
                                                                                  andTextColor:[UIColor colorWithRGBHex:0x898989]];
    }
    
    return _footerView;
}

- (HXSRoundedButton *)nextStepButton
{
    if(nil == _nextStepButton) {
        _nextStepButton = [[HXSRoundedButton alloc] init];
        
        [_nextStepButton setTitle:@"下一步，填写授权信息"
                         forState:UIControlStateNormal];
        [_nextStepButton addTarget:self
                            action:@selector(nextStepAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [_nextStepButton setEnabled:NO];
    }
    return _nextStepButton;
}

- (UIView *)nextStepView
{
    if(nil == _nextStepView) {
        // next button
        _nextStepView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, nextStepViewHeight)];
        [_nextStepView setBackgroundColor:[UIColor clearColor]];
        
        [_nextStepView addSubview:self.nextStepButton];
        [_nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nextStepView).offset(20);
            make.left.equalTo(_nextStepView).offset(15);
            make.right.equalTo(_nextStepView).offset(-15);
            make.height.mas_equalTo(44);
        }];
        
        // prompt label
        UILabel *promptLabel = [[UILabel alloc] init];
        [promptLabel setBackgroundColor:[UIColor clearColor]];
        [promptLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [promptLabel setTextColor:[UIColor colorWithRGBHex:0x999999]];
        [promptLabel setNumberOfLines:0];
        [promptLabel setTextAlignment:NSTextAlignmentCenter];
        [promptLabel setText:@"填写店长分享的邀请码，开通后可以获得随机发放的优惠券哦~"];
        
        [_nextStepView addSubview:promptLabel];
        [promptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nextStepButton.mas_bottom).offset(25);
            make.left.equalTo(_nextStepView).offset(15);
            make.right.equalTo(_nextStepView).offset(-15);
        }];
        
    }
    return _nextStepView;
}

- (HXSUserCreditcardBaseInfoEntity *)baseInfoEntity
{
    HXSUserCreditcardBaseInfoEntity *baseInfoEntity = [HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity;
    
    return baseInfoEntity;
}

@end

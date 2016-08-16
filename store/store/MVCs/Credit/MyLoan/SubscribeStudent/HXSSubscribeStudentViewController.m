//
//  HXSSubscribeStudentViewController.m
//  59dorm
//
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSSubscribeStudentViewController.h"

//vc

//view
#import "HXSSubscribeProgressCell.h"
#import "HXSSubscribeHeaderFooterView.h"
#import "HXSSubscribeInputTableViewCell.h"
#import "UIRenderingButton.h"
#import "HXSCustomAlertView.h"
#import "HXSSubscribeSelectCell.h"
#import "HXSCustomPickerView.h"

//model
#import "NSString+Verification.h"
#import "HXSBusinessLoanViewModel.h"

#import "HXMyLoan.h"

static CGFloat const headerViewHeight   = 40;
static CGFloat const nextStepViewHeight = 84;

typedef NS_ENUM(NSInteger,HXSSubscribeStudentSectionIndex){
    HXSSubscribeStudentSectionIndexProgress             = 0,//进程
    HXSSubscribeStudentSectionIndexInput                = 1,//输入
};

typedef NS_ENUM(NSInteger,HXSSubscribeStudentSelectRowIndex){
    HXSSubscribeStudentSelectRowIndexYear             = 1,//入学年份
    HXSSubscribeStudentSelectRowIndexEducational      = 2,//学历层次
};

@interface HXSSubscribeStudentViewController ()

@property (weak, nonatomic) IBOutlet UITableView                        *mainTableView;

@property (nonatomic, strong) HXSSubscribeHeaderFooterView              *headerView;
@property (nonatomic, strong) HXSSubscribeHeaderFooterView              *footerView;
@property (nonatomic, strong) UIView                                    *nextStepView;
@property (nonatomic, strong) HXSRoundedButton                          *nextStepButton;

@property (nonatomic, strong) NSArray<UITableViewCell *>                *dataArray;
@property (nonatomic, strong) NSArray<NSString *>                       *eduDegreeArray;
@property (nonatomic, strong) HXSSubscribeInputTableViewCell            *schoolCell;//所在学校
@property (nonatomic, strong) HXSSubscribeSelectCell                    *yearCell;//入学年份
@property (nonatomic, strong) HXSSubscribeSelectCell                    *educationalCell;//学历层次
@property (nonatomic, strong) HXSSubscribeInputTableViewCell            *professionalCell;//专业名称
@property (nonatomic, strong) HXSSubscribeInputTableViewCell            *dormitoryCell;//宿舍地址
@property (nonatomic, strong) HXSCustomAlertView                        *noticeAlertView;//提醒学籍验证失败

@property (nonatomic, strong) NSNumber                                  *currentEduDegreeNum;
@property (nonatomic, strong) HXSUserCreditcardBaseInfoEntity           *baseInfoEntity;


@end

@implementation HXSSubscribeStudentViewController

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

+ (instancetype)createSubscribeStudentVC
{
    HXSSubscribeStudentViewController *vc = [HXSSubscribeStudentViewController controllerFromXib];
    
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
}


#pragma mark -  UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    
    if(section == HXSSubscribeStudentSectionIndexInput) {
        rows = [self.dataArray count];
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = cellInputHeight;
    
    if(indexPath.section == HXSSubscribeStudentSectionIndexProgress) {
        height = subscribeProgressCellHeight;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    if(section == HXSSubscribeStudentSectionIndexProgress) {
        height = headerViewHeight;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    if(section == HXSSubscribeStudentSectionIndexProgress) {
        height = headerViewHeight;
    } else {
        height = nextStepViewHeight;
    }
    
    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == HXSSubscribeStudentSectionIndexProgress) {
        return self.headerView;
    }
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == HXSSubscribeStudentSectionIndexProgress) {
        return self.footerView;
    }
    
    return self.nextStepView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == HXSSubscribeStudentSectionIndexProgress) {
        HXSSubscribeProgressCell *progressCell = (HXSSubscribeProgressCell *)cell;
        [progressCell initSubscribeProgressCellWithCurrentStepIndex:kHXSSubscribeStepIndexStudent];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.section == HXSSubscribeStudentSectionIndexProgress){
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSSubscribeProgressCell class]) forIndexPath:indexPath];
    } else {
        cell = [self.dataArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == HXSSubscribeStudentSectionIndexInput) {
        if(indexPath.row == HXSSubscribeStudentSelectRowIndexYear
           && (nil == self.baseInfoEntity.entranceYearIntNum)) { //入学年份
            [self showThePickerViewWithRowIndex:indexPath.row];
        } else if(indexPath.row == HXSSubscribeStudentSelectRowIndexEducational
                && (nil == self.baseInfoEntity.eduDegreeIntNum)) { //学历层次
            [self showThePickerViewWithRowIndex:indexPath.row];
        }
    }
}


#pragma mark - ShowPickView

/**
 *  弹出滚轮选择框
 *
 *  @param index
 */
- (void)showThePickerViewWithRowIndex:(HXSSubscribeStudentSelectRowIndex)index
{
    switch (index)
    {
        case HXSSubscribeStudentSelectRowIndexYear:
        {
            NSInteger currentYear = [[NSDate date] year];
            int count = 8;
            NSMutableArray *enrolledYears = [[NSMutableArray alloc] initWithCapacity:5];
            for (int i = count ; i >= 0 ; i--) {
                NSString * text = [NSString stringWithFormat:@"%li", (long)(currentYear - count + i)];
                [enrolledYears addObject:text];
            }
            
            [HXSCustomPickerView showWithStringArray:enrolledYears
                                        defaultValue:@""
                                        toolBarColor:UIColorFromRGB(0xFFFFFF)
                                       completeBlock:^(int index, BOOL finished) {
                                             if(finished) {
                                                 [_yearCell.contentLabel setText:[enrolledYears objectAtIndex:index]];
                                                 [_yearCell.contentLabel setTextColor:[UIColor colorWithRGBHex:0x4a4a4a]];
                                             }
                                       }];
            
            break;
        }
        case HXSSubscribeStudentSelectRowIndexEducational:
        {
            __weak typeof(self) weakSelf = self;
            [HXSCustomPickerView showWithStringArray:self.eduDegreeArray
                                        defaultValue:@""
                                        toolBarColor:UIColorFromRGB(0xFFFFFF)
                                       completeBlock:^(int index, BOOL finished) {
                                         if(finished) {
                                             [weakSelf.educationalCell.contentLabel setText:[weakSelf.eduDegreeArray objectAtIndex:index]];
                                             [weakSelf.educationalCell.contentLabel setTextColor:[UIColor colorWithRGBHex:0x4a4a4a]];
                                             weakSelf.currentEduDegreeNum = [NSNumber numberWithInt:(index + 1)];
                                             
                                         }
                                     }];
            
            break;
        }
    }
}


#pragma mark - Button Action

- (void)nextStepAction:(UIButton *)button
{
    [MBProgressHUD showInView:self.view];
    
    HXSSubscribeStudentParamModel *studentModel = [[HXSSubscribeStudentParamModel alloc] init];
    studentModel.siteNameStr = self.schoolCell.valueTextField.text;
    studentModel.entranceYearStr = self.yearCell.contentLabel.text;;
    studentModel.eduDegreeNum = [self eduDegreeCodeWithString:self.educationalCell.contentLabel.text];
    studentModel.majorNameStr = self.professionalCell.valueTextField.text;
    studentModel.dormAddressStr = self.dormitoryCell.valueTextField.text;
    
    __weak typeof(self) weakSelf = self;
    
    [[HXSBusinessLoanViewModel sharedManager] addSchoolIdentifyWithParamModel:studentModel
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
                                                                             if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(subscribeStudentNextStep)])
                                                                             {
                                                                                 [weakSelf.delegate subscribeStudentNextStep];
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
    BOOL isEnable = ([[_schoolCell.valueTextField.text trim] length] > 0
                     && [[_professionalCell.valueTextField.text trim] length] > 0
                     && [[_dormitoryCell.valueTextField.text trim] length] > 0
                     && [[_yearCell.contentLabel.text trim] length] > 0
                     && [[_educationalCell.contentLabel.text trim] length] > 0);
    
    
    return isEnable;
}


#pragma mark -  setting the input field

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


#pragma mark - Private Methods

- (NSNumber *)eduDegreeCodeWithString:(NSString *)degreeStr
{
    // "1", "博士"；"2", "硕士"；"3", "本科"；"4", "专科"；
    int code = 0;
    if ([degreeStr isEqualToString:@"博士"]) {
        code = 1;
    } else if ([degreeStr isEqualToString:@"硕士"]) {
        code = 2;
    } else if ([degreeStr isEqualToString:@"本科"]) {
        code = 3;
    } else if ([degreeStr isEqualToString:@"专科"]) {
        code = 4;
    } else {
        code = 0; // Default
    }
    
    return [NSNumber numberWithInt:code];
}


#pragma mark - getter setter

- (NSArray<UITableViewCell *> *)dataArray
{
    if(nil == _dataArray) {
        _dataArray = @[self.schoolCell,
                       self.yearCell,
                       self.educationalCell,
                       self.professionalCell,
                       self.dormitoryCell
                       ];
    }
    
    return _dataArray;
}

- (NSArray<NSString *> *)eduDegreeArray
{
    if(nil == _eduDegreeArray) {
        _eduDegreeArray = @[@"专科", @"本科", @"硕士", @"博士"];
    }
    
    return _eduDegreeArray;
}

- (HXSSubscribeInputTableViewCell *)schoolCell
{
    if(nil == _schoolCell) {
        _schoolCell = [HXSSubscribeInputTableViewCell createSubscribeInputTableViewCell];
        [_schoolCell.keyLabel setText:@"所在学校"];
        [_schoolCell.valueTextField setPlaceholder:@"请输入当前所在学校"];
        [_schoolCell.valueTextField addTarget:self
                                     action:@selector(checkInputInfoValidation)
                           forControlEvents:UIControlEventEditingChanged];
        [self settingTheInputField:_schoolCell.valueTextField withContent:self.baseInfoEntity.siteNameStr];
    }
    
    return _schoolCell;
}

- (HXSSubscribeSelectCell *)yearCell
{
    if(nil == _yearCell) {
        _yearCell = [HXSSubscribeSelectCell createSubscribeSelectCell];
        [_yearCell.titleNameLabel setText:@"入学年份"];
        [_yearCell.contentLabel   setTextColor:[UIColor colorWithRGBHex:0xdbdbdb]];
        [_yearCell.contentLabel   setText:@"请选择入学年份"];
        
        if(0 < [self.baseInfoEntity.entranceYearIntNum integerValue])
        {
            [_yearCell.contentLabel   setText:[NSString stringWithFormat:@"%@", self.baseInfoEntity.entranceYearIntNum]];
            [_yearCell.contentLabel   setTextColor:[UIColor colorWithRGBHex:0x4a4a4a]];
        }
    }
    
    return _yearCell;
}

- (HXSSubscribeSelectCell *)educationalCell
{
    if(nil == _educationalCell) {
        _educationalCell = [HXSSubscribeSelectCell createSubscribeSelectCell];
        [_educationalCell.titleNameLabel setText:@"学历层次"];
        [_educationalCell.contentLabel   setTextColor:[UIColor colorWithRGBHex:0xdbdbdb]];
        [_educationalCell.contentLabel   setText:@"请选择学历层次"];
        
        if (nil != self.baseInfoEntity.eduDegreeIntNum) {
            [_educationalCell.contentLabel   setText:[_eduDegreeArray objectAtIndex:[self.baseInfoEntity.eduDegreeIntNum integerValue]]];
            [_educationalCell.contentLabel   setTextColor:[UIColor colorWithRGBHex:0x4a4a4a]];
        }
    }
    
    return _educationalCell;
}

- (HXSSubscribeInputTableViewCell *)professionalCell
{
    if(nil == _professionalCell) {
        _professionalCell = [HXSSubscribeInputTableViewCell createSubscribeInputTableViewCell];
        [_professionalCell.keyLabel setText:@"专业名称"];
        [_professionalCell.valueTextField setPlaceholder:@"请输入您的专业"];
        [_professionalCell.valueTextField addTarget:self
                                       action:@selector(checkInputInfoValidation)
                             forControlEvents:UIControlEventEditingChanged];
        [self settingTheInputField:_professionalCell.valueTextField withContent:self.baseInfoEntity.majorNameStr];
    }
    
    return _professionalCell;
}

- (HXSSubscribeInputTableViewCell *)dormitoryCell
{
    if(nil == _dormitoryCell) {
        _dormitoryCell = [HXSSubscribeInputTableViewCell createSubscribeInputTableViewCell];
        [_dormitoryCell.keyLabel setText:@"宿舍地址"];
        [_dormitoryCell.valueTextField setPlaceholder:@"请输入您的宿舍地址 如3幢113"];
        [_dormitoryCell.valueTextField addTarget:self
                                             action:@selector(checkInputInfoValidation)
                                   forControlEvents:UIControlEventEditingChanged];
        [self settingTheInputField:_dormitoryCell.valueTextField withContent:self.baseInfoEntity.dormAddressStr];
    }
    
    return _dormitoryCell;
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
        
        [_nextStepButton setTitle:@"下一步:填写银行卡信息" forState:UIControlStateNormal];
        [_nextStepButton addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_nextStepButton setEnabled:NO];
    }
    return _nextStepButton;
}

- (UIView *)nextStepView
{
    if(nil == _nextStepView) {
        _nextStepView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, nextStepViewHeight)];
        [_nextStepView setBackgroundColor:[UIColor clearColor]];
        
        [_nextStepView addSubview:self.nextStepButton];
        
        [_nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nextStepView).offset(20);
            make.left.equalTo(_nextStepView).offset(15);
            make.right.equalTo(_nextStepView).offset(-15);
            make.height.mas_equalTo(44);
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

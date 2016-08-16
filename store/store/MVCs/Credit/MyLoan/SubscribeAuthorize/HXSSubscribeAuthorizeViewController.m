//
//  HXSSubscribeAuthorizeViewController.m
//  59dorm
//
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSSubscribeAuthorizeViewController.h"

// VC
#import "HXSWebViewController.h"
#import "HXSWalletContactViewController.h"

//view
#import "HXSSubscribeProgressCell.h"
#import "HXSSubscribeHeaderFooterView.h"
#import "HXSCustomAlertView.h"
#import "HXSAuthorizeTableViewCell.h"

//model
#import "HXSBusinessLoanViewModel.h"
#import "NSString+Verification.h"


#import "HXMyLoan.h"
#import "HXSGPSLocationManager.h"
#import <AddressBook/AddressBook.h>
#import "HXSContactManager.h"


#define HEIGHT_DEFAULT_CELL  80

static CGFloat const headerViewHeight   = 40;
static CGFloat const nextStepViewHeight = 84;

typedef NS_ENUM(NSInteger, HXSSubscribeAuthorizeSectionIndex){
    HXSSubscribeAuthorizeSectionIndexProgress             = 0,//进程
    HXSSubscribeAuthorizeSectionIndexInput                = 1,//输入
};

typedef NS_ENUM(NSInteger, HXSSubscribeAuthorizeInputIndex){
    kHXSSubscribeAuthorizeInputIndexZhima             = 0,   //芝麻信用分授权
    kHXSSubscribeAuthorizeInputIndexAddressBook       = 1,   //通讯录授权
    kHXSSubscribeAuthorizeInputIndexLocation          = 2,   //定位授权
    kHXSSubscribeAuthorizeInputIndexContracter        = 3,   //紧急联系人
    
    kHXSSubscribeAuthorizeInputIndexCount             = 4,   // 总个数
};

@interface HXSSubscribeAuthorizeViewController ()<UINavigationControllerDelegate, HXSGPSLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView                        *mainTableView;
@property (nonatomic, strong) HXSSubscribeHeaderFooterView              *headerView;
@property (nonatomic, strong) HXSSubscribeHeaderFooterView              *footerView;
@property (nonatomic, strong) UIView                                    *nextStepView;
@property (nonatomic, strong) HXSRoundedButton                          *nextStepButton;

@property (nonatomic, strong) NSArray                   *cellsArr;
@property (nonatomic, strong) HXSAuthorizeTableViewCell *zhimaCell;
@property (nonatomic, strong) HXSAuthorizeTableViewCell *addressBookCell;
@property (nonatomic, strong) HXSAuthorizeTableViewCell *locationCell;
@property (nonatomic, strong) HXSAuthorizeTableViewCell *contracterCell;

@property (nonatomic, strong) HXSUpgradeAuthStatusEntity *authStatusEntity;

@end

@implementation HXSSubscribeAuthorizeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTheMainTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self fetchAuthorizeData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [HXSGPSLocationManager instance].delegate = nil;
}


#pragma mark - create

+ (instancetype)createSubscribeAuthorizeVC
{
    HXSSubscribeAuthorizeViewController *vc = [HXSSubscribeAuthorizeViewController controllerFromXib];
    
    return vc;
}


#pragma mark - init

- (void)initTheMainTableView
{
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSSubscribeProgressCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSSubscribeProgressCell class])];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSAuthorizeTableViewCell class]) bundle:nil]
             forCellReuseIdentifier:NSStringFromClass([HXSAuthorizeTableViewCell class])];
    
    
    __weak typeof(self) weakSelf = self;
    [self.mainTableView addRefreshHeaderWithCallback:^{
        [weakSelf refreshAuthorizeData];
    }];
    
}


#pragma mark - Fetch Authorize Data

- (void)fetchAuthorizeData
{
    [MBProgressHUD showInView:self.view];
    
    [self refreshAuthorizeData];
}

- (void)refreshAuthorizeData
{
    __weak typeof(self) weakSelf = self;
    
    [[HXSBusinessLoanViewModel sharedManager] fetchAuthStatusComplete:^(HXSErrorCode code, NSString *message, HXSUpgradeAuthStatusEntity *model) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (kHXSNoError != code) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f];
            
            // Don't return, always reload table view
        }
        
        weakSelf.authStatusEntity = model;
        
        [weakSelf.mainTableView reloadData];
    }];
}


#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    
    if (HXSSubscribeAuthorizeSectionIndexInput == section) {
        rows = kHXSSubscribeAuthorizeInputIndexCount;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = HEIGHT_DEFAULT_CELL;
    
    if(indexPath.section == HXSSubscribeAuthorizeSectionIndexProgress) {
        height = subscribeProgressCellHeight;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    if(section == HXSSubscribeAuthorizeSectionIndexProgress) {
        height = headerViewHeight;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    if(section == HXSSubscribeAuthorizeSectionIndexProgress) {
        height = headerViewHeight;
    }
    
    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == HXSSubscribeAuthorizeSectionIndexProgress) {
        return self.headerView;
    }
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == HXSSubscribeAuthorizeSectionIndexProgress) {
        return self.footerView;
    }
    
    return self.nextStepView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.section == HXSSubscribeAuthorizeSectionIndexProgress) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSSubscribeProgressCell class]) forIndexPath:indexPath];
    } else if(indexPath.section == HXSSubscribeAuthorizeSectionIndexInput) {
        cell = [self.cellsArr objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == HXSSubscribeAuthorizeSectionIndexProgress) {
        HXSSubscribeProgressCell *progressCell = (HXSSubscribeProgressCell *)cell;
        [progressCell initSubscribeProgressCellWithCurrentStepIndex:kHXSSubscribeStepIndexAuthorize];
    }
    
}

- (void)setupAuthorizeBtnGoToAuthorize:(UIButton *)button
{
    [button setTitleColor:[UIColor colorWithRGBHex:0x07A9FA] forState:UIControlStateNormal];
    [button setTitle:@"去授权" forState:UIControlStateNormal];
    [button setUserInteractionEnabled:YES];
    
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor colorWithRGBHex:0x07A9FA].CGColor;
    button.layer.borderWidth = 1.0f;
}

- (void)setupAuthorizeBtnHasDoen:(UIButton *)button
{
    [button setImage:[UIImage imageNamed:@"ic_paysuccess"] forState:UIControlStateNormal];
    [button setTitle:@"已完成" forState:UIControlStateNormal];
    [button setUserInteractionEnabled:NO];
    
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor clearColor].CGColor;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
}


#pragma mark - Button Action

- (void)nextStepAction:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showInView:self.view];
    [[HXSBusinessLoanViewModel sharedManager] finishAuthorzieComplete:^(HXSErrorCode code, NSString *message, BOOL isOpen) {
        [MBProgressHUD hideHUDForView:weakSelf.view
                             animated:YES];
        
        if (kHXSNoError != code) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5];
            
            return ;
        } else  {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(subscribeAuthoruzeNextStep)]) {
                [weakSelf.delegate subscribeAuthoruzeNextStep];
            }
            
            [[HXSUserAccount currentAccount].userInfo updateUserInfo];
        }
    }];
}

- (void)onClickZhimaBtn:(UIButton *)btn
{
    HXSWebViewController * controller = [HXSWebViewController controllerFromXib];
    [controller setUrl:[NSURL URLWithString:[ApplicationSettings instance].currentZmCreditURL]];
    controller.title = @"芝麻信用";
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickAddressBookBtn:(UIButton *)btn
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        });
        return;
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        HXSCustomAlertView *alert = [[HXSCustomAlertView alloc] initWithTitle:@"提示" message:@"请到 设置->59store 中允许访问通讯录" leftButtonTitle:@"确定" rightButtonTitles:nil];
        [alert show];
        
        return;
    } else {
        NSArray *contactsArr = [HXSContactManager exportAllContactsForUserInfoAuth];
        NSDictionary *contactsInfoDic = @{@"auth_contacts_list":contactsArr};
        NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:contactsInfoDic options:0 error:nil];
        NSString *contactsInfoStr = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
        
        [MBProgressHUD showInView:self.view];
        __weak typeof(self) weakSelf = self;
        [[HXSBusinessLoanViewModel sharedManager] uploadContactsInfo:contactsInfoStr
                                                            complete:^(HXSErrorCode code, NSString *message, BOOL isSuccess) {
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                
                                                                if (kHXSNoError != code) {
                                                                    [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                                       status:message
                                                                                                   afterDelay:1.5f];
                                                                    
                                                                    return ;
                                                                }
                                                                
                                                                [weakSelf fetchAuthorizeData];
                                                            }];
        
    }
}

- (void)onClickLocatonBtn:(UIButton *)btn
{
    [MBProgressHUD showInView:self.view];
    
    [[HXSGPSLocationManager instance] setDelegate:self];
    
    [[HXSGPSLocationManager instance] startPositioning];
}

- (void)onClickContracterBtn:(UIButton *)btn
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    HXSWalletContactViewController *walletContactViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HXSWalletContactViewController class])];
    
    [self.navigationController pushViewController:walletContactViewController animated:YES];
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
    BOOL isEnable = NO;
    
    // 提交按钮
    if ((kHXSAuthorizeStatusDone == [self.authStatusEntity.zhimaAuthStatusIntNum intValue])
        && (kHXSAuthorizeStatusDone == [self.authStatusEntity.contactsAuthStatusIntNum intValue])
        && (kHXSAuthorizeStatusDone == [self.authStatusEntity.emergencyContactsStatusIntNum intValue])
        && (kHXSAuthorizeStatusDone == [self.authStatusEntity.positionStatusIntNum intValue])) {
        isEnable = YES;
    }
    
    return isEnable;
}


#pragma mark - HXSGPSLocationManagerDelegate

- (void)locationDidUpdateLatitude:(double)latitude longitude:(double)longitude
{
    __weak typeof(self) weakSelf = self;
    [[HXSBusinessLoanViewModel sharedManager] uploadLocationInfoWithLatitude:latitude
                                                                   longitude:longitude
                                                                    complete:^(HXSErrorCode code, NSString *message, BOOL isSuccess) {
                                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                        
                                                                        if (kHXSNoError != code) {
                                                                            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                                               status:message
                                                                                                           afterDelay:1.5f];
                                                                            
                                                                            return ;
                                                                        }
                                                                        
                                                                        [weakSelf fetchAuthorizeData];
                                                                        
                                                                    }];
    
    
}

- (void)locationdidFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒"
                                                                      message:@"请在iPhone的“设置-隐私-定位服务”选项中，允许59store访问你的定位服务"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"去设置"];
    
    alertView.rightBtnBlock = ^(){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=Privacy"]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy"]];
        }
    };
    
    [alertView show];
}


#pragma mark - Getter setter

- (HXSSubscribeHeaderFooterView *)headerView
{
    if(!_headerView) {
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
    if(!_footerView) {
        _footerView = [HXSSubscribeHeaderFooterView createSubscribeHeaderFooterViewWithContent:@"请填写以下信息"
                                                                                     andHeight:headerViewHeight
                                                                                   andFontSize:13
                                                                                  andTextColor:[UIColor colorWithRGBHex:0x898989]];
    }
    
    return _footerView;
}

- (NSArray *)cellsArr
{
    if (nil == _cellsArr) {
        _cellsArr = @[
                      _zhimaCell,
                      _addressBookCell,
                      _locationCell,
                      _contracterCell,
                      ];
    }
    
    return _cellsArr;
}

- (HXSAuthorizeTableViewCell *)zhimaCell
{
    if (nil == _zhimaCell) {
        _zhimaCell = [[HXSAuthorizeTableViewCell alloc] init];
        _zhimaCell.titleLabel.text = @"芝麻信用分授权";
        [_zhimaCell.authorizeBtn addTarget:self
                                    action:@selector(onClickZhimaBtn:)
                          forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _zhimaCell;
}

- (HXSAuthorizeTableViewCell *)addressBookCell
{
    if (nil == _addressBookCell) {
        _addressBookCell = [[HXSAuthorizeTableViewCell alloc] init];
        _addressBookCell.titleLabel.text = @"通讯录授权";
        [_addressBookCell.authorizeBtn addTarget:self
                                          action:@selector(onClickAddressBookBtn:)
                                forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _addressBookCell;
}

- (HXSAuthorizeTableViewCell *)locationCell
{
    if (nil == _locationCell) {
        _locationCell = [[HXSAuthorizeTableViewCell alloc] init];
        _locationCell.titleLabel.text = @"定位授权";
        [_locationCell.authorizeBtn addTarget:self
                                       action:@selector(onClickLocatonBtn:)
                             forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _locationCell;
}

- (HXSAuthorizeTableViewCell *)contracterCell
{
    if (nil == _contracterCell) {
        _contracterCell = [[HXSAuthorizeTableViewCell alloc] init];
        _contracterCell.titleLabel.text = @"填写紧急联系人";
        [_contracterCell.authorizeBtn addTarget:self
                                         action:@selector(onClickContracterBtn:)
                               forControlEvents:UIControlEventTouchUpInside];
    }

    return _contracterCell;
}

- (HXSRoundedButton *)nextStepButton
{
    if (nil == _nextStepButton) {
        _nextStepButton = [[HXSRoundedButton alloc]init];
        
        [_nextStepButton setTitle:@"下一步，填写学籍信息" forState:UIControlStateNormal];
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

@end

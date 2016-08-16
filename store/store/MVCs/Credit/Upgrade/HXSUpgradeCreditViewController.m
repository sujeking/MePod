//
//  HXSUpgradeCreditViewController.m
//  store
//
//  Created by ArthurWang on 16/2/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSUpgradeCreditViewController.h"

// Controller
#import "HXSWebViewController.h"
#import "HXSCustomTakePhotoViewController.h"

// Model
#import "HXSUpgradeModel.h"
#import "HXSMyLoanParamModel.h"
#import "HXSBusinessLoanViewModel.h"

// Views
#import "HXSPayHeaderView.h"

// Common
#import "UIButton+WebCache.h"

static NSInteger const kHeightSectionHeaderView = 40;

@interface HXSUpgradeCreditViewController () <HXSCustomTakePhotoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *cardFrontCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *cardReverseCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *cardInHandCell;

@property (weak, nonatomic) IBOutlet UILabel *limitAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *cardFrontUploadBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardReverseUploadBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardInHandUploadBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardFrontImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardReverseImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardInHandImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *upgradeBtn;

@property (nonatomic, strong) HXSUpgradeModel            *upgradeModel;
@property (nonatomic, strong) HXSUpgradeAuthStatusEntity *authStatusEntity;
@property (nonatomic, assign) HXSTakePhotoType takePhotoType;

@end

@implementation HXSUpgradeCreditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialButtons];
    
    [self initialLimitLabel];
    
    [self initialTableView];
    
    [self updateButtonsStatus];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self fetchAuthStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"提升额度";
}

- (void)initialButtons
{
    self.cardFrontUploadBtn.layer.masksToBounds = YES;
    self.cardFrontUploadBtn.layer.cornerRadius = 4.0f;
    self.cardFrontUploadBtn.layer.borderColor = [UIColor colorWithRGBHex:0x54ADF9].CGColor;
    self.cardFrontUploadBtn.layer.borderWidth = 1.0f;
    
    self.cardReverseUploadBtn.layer.masksToBounds = YES;
    self.cardReverseUploadBtn.layer.cornerRadius = 4.0f;
    self.cardReverseUploadBtn.layer.borderColor = [UIColor colorWithRGBHex:0x54ADF9].CGColor;
    self.cardReverseUploadBtn.layer.borderWidth = 1.0f;
    
    self.cardInHandUploadBtn.layer.masksToBounds = YES;
    self.cardInHandUploadBtn.layer.cornerRadius = 4.0f;
    self.cardInHandUploadBtn.layer.borderColor = [UIColor colorWithRGBHex:0x54ADF9].CGColor;
    self.cardInHandUploadBtn.layer.borderWidth = 1.0f;
}

- (void)initialLimitLabel
{
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    self.limitAmountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [creditCardInfo.totalCreditDoubleNum doubleValue]];
}

- (void)initialTableView
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([self.cardFrontCell respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.cardFrontCell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([self.cardReverseCell respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.cardReverseCell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([self.cardInHandCell respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.cardInHandCell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchAuthStatus];
    }];
    
}


#pragma mark - Setter Getter Methods

- (HXSUpgradeModel *)upgradeModel
{
    if (nil == _upgradeModel) {
        _upgradeModel = [[HXSUpgradeModel alloc] init];
    }
    
    return _upgradeModel;
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HXSPayHeaderView *header = [[HXSPayHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, kHeightSectionHeaderView)];
    header.backgroundColor = [UIColor colorWithRGBHex:0xF6FDFF];
    header.textLabel.text = @"完善以下信息，最高可获得8000元的授信额度哦~";
    header.textLabel.font = [UIFont systemFontOfSize:13.0f];
    header.textLabel.textColor = [UIColor colorWithRGBHex:0x999999];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeightSectionHeaderView;
}

#pragma mark - Target Methods

- (IBAction)onClickCardFrontUploadBtn:(id)sender
{
    [(UIButton *)sender setUserInteractionEnabled:NO];
    
    [self jumpToTakePhotoView:kHXSTakePhotoTypeCardUp];
    
    [(UIButton *)sender setUserInteractionEnabled:YES];
}

- (IBAction)onClickCardFrontImageBtn:(id)sender
{
    [self onClickCardFrontUploadBtn:sender];
}

- (IBAction)onClickCardReverseUploadBtn:(id)sender
{
    [(UIButton *)sender setUserInteractionEnabled:NO];
    
    [self jumpToTakePhotoView:kHXSTakePhotoTypeCardDown];
    
    [(UIButton *)sender setUserInteractionEnabled:YES];
}

- (IBAction)onClickCardReverseImageBtn:(id)sender
{
    [self onClickCardReverseUploadBtn:sender];
}

- (IBAction)onClickCardInHandUploadBtn:(id)sender
{
    [(UIButton *)sender setUserInteractionEnabled:NO];
    
    [self jumpToTakePhotoView:kHXSTakePhotoTypeCardHandle];
    
    [(UIButton *)sender setUserInteractionEnabled:YES];
}

- (IBAction)onClickCardInHandImageBtn:(id)sender
{
    [self onClickCardInHandUploadBtn:sender];
}

- (IBAction)onClickUpgradeBtn:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showInView:self.view];
    [self.upgradeModel upgradeCreditCard:^(HXSErrorCode status, NSString *message, NSDictionary *info) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (kHXSNoError != status) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f];
            return ;
        }
        
        // 更新账户状态
        [[HXSUserAccount currentAccount].userInfo updateUserInfo];
        
        CGFloat intervalTime = 1.5f;
        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                           status:@"提升额度申请完成"
                                       afterDelay:intervalTime];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(intervalTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
}


#pragma mark - Fetch Auth Info

- (void)fetchAuthStatus
{
    __weak typeof(self) weakSelf = self;
    
    [self.upgradeModel fetchCreditCardAuthStatus:^(HXSErrorCode status, NSString *message, HXSUpgradeAuthStatusEntity *entity) {
        [weakSelf.tableView endRefreshing];
        
        if (kHXSNoError != status) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f];
            
            return ;
        }
        
        weakSelf.authStatusEntity = entity;
        
        [self updateButtonsStatus];
    }];
}

#pragma mark Update Buttons

- (void)updateButtonsStatus
{
    // 芝麻信用授权
    if (0 < [self.authStatusEntity.idCardDirectUrlStr length]) { // null:未提交；url:已提交
        [self.cardFrontUploadBtn setHidden:YES];
        [self.cardFrontImageBtn setHidden:NO];
        
        [self.cardFrontImageBtn sd_setImageWithURL:[NSURL URLWithString:self.authStatusEntity.idCardDirectUrlStr]
                                          forState:UIControlStateNormal
                                  placeholderImage:[UIImage imageNamed:@"img_loading_head"]];
    } else {
        [self.cardFrontUploadBtn setHidden:NO];
        [self.cardFrontImageBtn setHidden:YES];
    }
    
    // 通讯录授权
    if (0 < [self.authStatusEntity.idCardBackUrlStr length]) { // null:未提交；url:已提交
        [self.cardReverseUploadBtn setHidden:YES];
        [self.cardReverseImageBtn setHidden:NO];
        
        [self.cardReverseImageBtn sd_setImageWithURL:[NSURL URLWithString:self.authStatusEntity.idCardBackUrlStr]
                                            forState:UIControlStateNormal
                                    placeholderImage:[UIImage imageNamed:@"img_loading_head"]];
    } else {
        [self.cardReverseUploadBtn setHidden:NO];
        [self.cardReverseImageBtn setHidden:YES];
    }
    
    // 紧急联系人信息提交
    if (0 < [self.authStatusEntity.idCardHandheldUrlStr length]) { // null:未提交；url:已提交
        [self.cardInHandUploadBtn setHidden:YES];
        [self.cardInHandImageBtn setHidden:NO];
        
        [self.cardInHandImageBtn sd_setImageWithURL:[NSURL URLWithString:self.authStatusEntity.idCardHandheldUrlStr]
                                           forState:UIControlStateNormal
                                   placeholderImage:[UIImage imageNamed:@"img_loading_head"]];
    } else {
        [self.cardInHandUploadBtn setHidden:NO];
        [self.cardInHandImageBtn setHidden:YES];
    }
    
    // 提交按钮
    if ((0 < [self.authStatusEntity.idCardDirectUrlStr length])
        && (0 < [self.authStatusEntity.idCardBackUrlStr length])
        && (0 < [self.authStatusEntity.idCardHandheldUrlStr length]))
    {
        [self.upgradeBtn setEnabled:YES];
    } else {
        [self.upgradeBtn setEnabled:NO];
    }
}


/**
 *  跳转到相机或者相册界面
 *
 *  @param isCamera
 */
- (void)jumpToTakePhotoView:(HXSTakePhotoType)type
{
    HXSCustomTakePhotoViewController *customTakePhotoViewController = [[HXSCustomTakePhotoViewController alloc] initWithNibName:@"HXSCustomTakePhotoViewController" bundle:nil];
    customTakePhotoViewController.delegate = self;
    customTakePhotoViewController.takePhotoType = type;
    [self presentViewController:customTakePhotoViewController animated:YES completion:nil];
    
    self.takePhotoType = type;
}


#pragma mark - HXSCustomTakePhotoViewControllerDelegate

- (void)takePhotoDoneFinishAndGetImage:(UIImage *)image
{
    HXSUploadPhotoParamModel *uploadPhotoParamModel = [[HXSUploadPhotoParamModel alloc] init];
    uploadPhotoParamModel.image = image;
    uploadPhotoParamModel.statusNum = @(1);
    switch (self.takePhotoType) {
        case kHXSTakePhotoTypeCardUp:
        {
            uploadPhotoParamModel.uploadTypeNum = @(1);
        }
            break;
        case kHXSTakePhotoTypeCardDown:
        {
            uploadPhotoParamModel.uploadTypeNum = @(2);
        }
            break;
            
        case kHXSTakePhotoTypeCardHandle:
        {
            uploadPhotoParamModel.uploadTypeNum = @(3);
        }
            break;
        default:
            break;
    }
    
    [MBProgressHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    [[HXSBusinessLoanViewModel sharedManager] uploadThePhotoWithParam:uploadPhotoParamModel
                                                             Complete:^(HXSErrorCode code, NSString *message, NSString *urlStr) {
                                                                 [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                                 
                                                                 if (code == kHXSNoError)
                                                                 {
                                                                     [weakSelf fetchAuthStatus];
                                                                 }
                                                                 else
                                                                 {
                                                                     [MBProgressHUD showInView:weakSelf.view customView:nil status:message afterDelay:3];
                                                                 }
                                                             }];
}


@end

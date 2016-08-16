//
//  HXSPersonalInfoTableViewController.m
//  store
//
//  Created by ranliang on 15/7/20.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSPersonalInfoTableViewController.h"
#import "HXSPersonal.h"

// Controllers

#import "HXSChangeSingleLineViewController.h"
#import "HXSChangePasswordViewController.h"
#import "HXSBindTelephoneController.h"
#import "HXSForgetPasswdVerifyController.h"

// Views
#import "HXSPayPasswordAlertView.h"
#import "HXSActionSheet.h"

// Model
#import "HXSSite.h"
#import "HXSPersonalInfoModel.h"
#import "HXSPayPasswordUpdateModel.h"


@interface HXSPersonalInfoTableViewController () <UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImage *avatarImage;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) HXSPersonalInfoModel *personalInfoModel;

@property (weak, nonatomic) IBOutlet UISwitch *exemptionPaymentSwitch;


@end

@implementation HXSPersonalInfoTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    
    [HXSUsageManager trackEvent:kUsageEventPersonalInfoModify parameter:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self intialDataSource];
    [self initialExemptionPaymentSwitch];
    [self.tableView reloadData];
}

#pragma mark - Initial Methods

- (void)intialDataSource
{
    HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
    HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
    NSArray *arraySection0 = [NSArray arrayWithObjects:
                              basicInfo.portrait ? basicInfo.portrait : @"未设置",
                              basicInfo.uName ? basicInfo.uName : @"未设置",
                              basicInfo.nickName ? basicInfo.nickName : @"未设置",
                              (basicInfo.phone.length > 0) ? basicInfo.phone : @"请绑定手机号", nil];
    
    BOOL hasSignPasswd = [HXSUserAccount currentAccount].userInfo.basicInfo.passwordFlag;
    BOOL hasPayPasswd = [[HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity.havePasswordIntNum boolValue];
    
    NSArray *arraySection1 = [NSArray arrayWithObjects:
                              hasSignPasswd ? @"******" : @"未设置",
                              hasPayPasswd ? @"******" : @"未设置",
                              @"", nil];
    
    self.dataSource = [NSArray arrayWithObjects:arraySection0, arraySection1, nil];
    
    return;
}

- (void)initialExemptionPaymentSwitch
{
    BOOL isOnExemptionStatus = [[HXSUserAccount currentAccount].userInfo.creditCardInfo.exemptionStatusIntNum boolValue];
    
    [self.exemptionPaymentSwitch setOn:isOnExemptionStatus];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([info[UIImagePickerControllerEditedImage] isKindOfClass:[UIImage class]]) {
        self.avatarImage = info[UIImagePickerControllerEditedImage];
    } else {
        self.avatarImage = info[UIImagePickerControllerOriginalImage];
    }
    
    [self.tableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    [self.personalInfoModel updateHeadPortrait:self.avatarImage
                                      complete:^(HXSErrorCode code, NSString *message, NSDictionary *passwordDic) {
                                          if (kHXSNoError != code) {
                                              [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                 status:message
                                                                             afterDelay:1.5f];
                                              
                                              return ;
                                          }
                                          
                                          // update user info in basic info class.
                                          [[[HXSUserAccount currentAccount] userInfo] updateUserInfo];
                                      }];
    
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self.parentViewController.navigationController popToViewController:self.parentViewController animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self.parentViewController.navigationController popToViewController:self.parentViewController animated:YES];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
    HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
    
    //add avatar in section 0 row 0
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIImageView *imageView = (UIImageView *)[cell.detailTextLabel subviewOfClassType:[UIImageView class]];
        if (imageView == nil) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        }
        
        if (self.avatarImage != nil) {
            imageView.image = self.avatarImage;
            self.avatarImage = nil;
        }
        else {
            NSString * url = [basicInfo.portrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_headsculpture"]];
        }
        
        CGRect frame = imageView.frame;
        frame.origin.y = -8.0;
        imageView.frame = frame;
        imageView.layer.cornerRadius = 36/2.0;
        imageView.clipsToBounds = YES;
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = [UIColor colorWithRGBHex:0x6BCBFC].CGColor;
        [cell.detailTextLabel addSubview:imageView];
    } else { // config the detailTextLabel
        cell.detailTextLabel.text = self.dataSource[indexPath.section][indexPath.row];
       
        if (cell.detailTextLabel.text == nil || cell.detailTextLabel.text.length < 1) {
            cell.detailTextLabel.text = @"未填写";
        }
    }
    
    if ((indexPath.section == 0) && (indexPath.row == 3)) {
        if ( ![cell.detailTextLabel.text isValidCellPhoneNumber] ) {
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 17, 0, 0);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 50;
    }
    
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footerContainer = [[UIView alloc] init];
        footerContainer.backgroundColor = [UIColor clearColor];
        
        NSString *text = @"提示：\n开启小额免密支付后，订单金额≤10元/笔，无需输入支付密码。";
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = [UIColor colorWithRGBHex:0x999999];
        label.numberOfLines = 0;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:4.0];
        
        NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0x999999],
                                     NSFontAttributeName : [UIFont systemFontOfSize:12.0],
                                     NSParagraphStyleAttributeName: style};
        

        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
        
       
        
        CGSize size = [attributeStr boundingRectWithSize:CGSizeMake(tableView.width - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        label.frame = CGRectMake(15.0, 15.0, tableView.width - 30, size.height);
        label.attributedText = attributeStr;
        
        [footerContainer addSubview:label];
        
        return footerContainer;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
    HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
    
    if (indexPath.section == 0) {
        // Modify Header Icon
        if (indexPath.row == 0) {
            [HXSUsageManager trackEvent:kUsageEventSettingPortrait parameter:nil];
            
            __weak typeof(self) weakSelf = self;
            
            HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
            
            HXSActionSheetEntity *cameroEntity = [[HXSActionSheetEntity alloc] init];
            cameroEntity.nameStr = @"拍照";
            HXSAction *cameroAction = [HXSAction actionWithMethods:cameroEntity
                                                           handler:^(HXSAction *action) {
                                                               [weakSelf showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                                                           }];
            
            [sheet addAction:cameroAction];
            
            HXSActionSheetEntity *photosEntity = [[HXSActionSheetEntity alloc] init];
            photosEntity.nameStr = @"从手机相册选择";
            HXSAction *photosAction = [HXSAction actionWithMethods:photosEntity
                                                           handler:^(HXSAction *action) {
                                                               [weakSelf showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                           }];
            
            [sheet addAction:photosAction];
            
            [sheet show];
        }
        else if (indexPath.row == 2) {
            [HXSUsageManager trackEvent:kUsageEventSettingNickname parameter:nil];
            
            [self performSegueWithIdentifier:@"HXSModifyAccountMessageSegue" sender:@(HXSModifyAccountInfoNickname)];
        }
        else if (indexPath.row == 3) {
            [HXSUsageManager trackEvent:kUsageEventModifyBindPhoneNumber parameter:nil];
            
            [self performSegueWithIdentifier:@"HXSGoToBindTelephoneSegue" sender:nil];
        }
    }
    else if (indexPath.section == 1) { // change site

        if ((indexPath.row == 1) && (basicInfo.phone.length < 1)) {
            
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                              message:@"您还未绑定过手机，请先去绑定。"
                                                                      leftButtonTitle:@"取消"
                                                                    rightButtonTitles:@"去绑定"];
            alertView.rightBtnBlock = ^{
                [self performSegueWithIdentifier:@"HXSGoToBindTelephoneSegue" sender:nil];
            };
            
            [alertView show];
            
            return;
        }
        if ((0 == indexPath.row)
            || (1 == indexPath.row)) {
            [self performSegueWithIdentifier:@"HXSModifyPasswdSegue" sender:@(indexPath.row)];
        }
    }
    
    else if (indexPath.section == 2 && indexPath.row == 1) { // change dormEntry

    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"HXSModifyAccountMessageSegue"]) {
        HXSModifyAccountInfoType type = [sender integerValue];
        
        HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
        
        NSString *textStr = nil;
        switch (type) {
            case HXSModifyAccountInfoNickname:
            {
                textStr = userAccount.userInfo.basicInfo.nickName;
            }
                break;
                
            case HXSModifyAccountInfoUsername:
            {
                textStr = userAccount.userInfo.basicInfo.uName;
            }
                break;
                
            case HXSModifyAccountInfoCellNumber:
            {
                textStr = userAccount.userInfo.basicInfo.phone;
            }
                break;
                
            default:
                break;
        }
        
        [(HXSChangeSingleLineViewController *)segue.destinationViewController setType:type];
        [(HXSChangeSingleLineViewController *)segue.destinationViewController setText:textStr];
    }
    else if ([segue.identifier isEqualToString:@"HXSModifyPasswdSegue"]) {
        HXSChangePasswordMode mode = (HXSChangePasswordMode)[sender integerValue];
        [(HXSChangePasswordViewController *)segue.destinationViewController setMode:mode];
        
        BOOL hasOldPassword = NO;
        switch (mode) {
            case HXSChangePasswordPay:
            {
                [HXSUsageManager trackEvent:kUsageEventSettingPayPasswd parameter:nil];
                
                hasOldPassword = [[HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity.havePasswordIntNum boolValue];
            }
                break;
                
            case HXSChangePasswordLogin:
            {
                [HXSUsageManager trackEvent:kUsageEventSettingLoginPasswd parameter:nil];
                
                hasOldPassword = [HXSUserAccount currentAccount].userInfo.basicInfo.passwordFlag;
            }
                break;
                
            default:
                break;
        }
        
        [(HXSChangePasswordViewController *)segue.destinationViewController setHasOldPassword:hasOldPassword];
    }
    else if ([segue.destinationViewController isKindOfClass:[HXSBindTelephoneController class]]) {
        HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
        HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
        
        HXSBindTelephoneController *vc = (HXSBindTelephoneController *)segue.destinationViewController;
        vc.isUpdate = !(basicInfo.phone.length < 1);
    }
}

- (IBAction)unwindToPersonalInfoViewController:(UIStoryboardSegue *)segue
{
    NSMutableArray *tempDataSource = [[NSMutableArray alloc] initWithArray:self.dataSource];
    NSMutableArray *section0MArr = [[NSMutableArray alloc] initWithArray:[tempDataSource objectAtIndex:0]]; // first section
    
    // update user info in basic info class.
    [[[HXSUserAccount currentAccount] userInfo] updateUserInfo];
    
    HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
    HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
    
    if ([segue.sourceViewController isKindOfClass:[HXSChangeSingleLineViewController class]]) {
        HXSChangeSingleLineViewController *changeSingleLineVC = (HXSChangeSingleLineViewController *)segue.sourceViewController;
        switch (changeSingleLineVC.type) {
            case HXSModifyAccountInfoNickname: {
                NSString *nickName = changeSingleLineVC.text;
                basicInfo.nickName = nickName;
                DLog(@"修改过的昵称是：%@", nickName);
                [section0MArr replaceObjectAtIndex:3 withObject:nickName];
                [tempDataSource replaceObjectAtIndex:0 withObject:section0MArr];
                break;
            }
            case HXSModifyAccountInfoUsername: {
                NSString *username = changeSingleLineVC.text;
                DLog(@"修改过的收货人是：%@", username);
                break;
            }
            case HXSModifyAccountInfoCellNumber: {
                NSString *cellNumber = changeSingleLineVC.text;
                DLog(@"修改过的手机号是：%@", cellNumber);
                break;
            }
                
            default:
                break;
        }
    } else if ([segue.sourceViewController isKindOfClass:[HXSChangePasswordViewController class]]) {
        BOOL hasSignPasswd = [HXSUserAccount currentAccount].userInfo.basicInfo.passwordFlag;
        BOOL hasPayPasswd = [[HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity.havePasswordIntNum boolValue];
        
        NSArray *arraySection1 = [NSArray arrayWithObjects:
                                  hasSignPasswd ? @"******" : @"未设置",
                                  hasPayPasswd ? @"******" : @"未设置",
                                  @"", nil];
        
        [tempDataSource replaceObjectAtIndex:1 withObject:arraySection1];
        
        [self initialExemptionPaymentSwitch];
    }
    
    self.dataSource = tempDataSource;
    
    [self.tableView reloadData];
    
}


#pragma mark - Target Methods

- (IBAction)exemptionPaymentChanged:(id)sender
{
    if (self.exemptionPaymentSwitch.isOn)
    {
        [HXSUsageManager trackEvent:kUsageEventModifyAvoidPassword parameter:@{@"status":@"开启"}];
        
        BOOL hasPayPasswd = [[HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity.havePasswordIntNum boolValue];
        HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
        HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
        
        if (!hasPayPasswd)
        {
            [self.exemptionPaymentSwitch setOn:NO animated:YES];
            
            if ((basicInfo.phone.length < 1)) {
                
                HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                                  message:@"您还未绑定过手机，请先去绑定。"
                                                                          leftButtonTitle:@"取消"
                                                                        rightButtonTitles:@"去绑定"];
                alertView.rightBtnBlock = ^{
                    [self performSegueWithIdentifier:@"HXSGoToBindTelephoneSegue" sender:nil];
                };
                
                [alertView show];
                
                return;
            } else {
                HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                                  message:@"您还未设置支付密码，请先设置。"
                                                                          leftButtonTitle:@"取消"
                                                                        rightButtonTitles:@"去设置"];
                alertView.rightBtnBlock = ^{
                    [self performSegueWithIdentifier:@"HXSModifyPasswdSegue" sender:@(1)]; // 1 is modifying pay passsword
                };
                
                [alertView show];
                return;
            }
        }
        
        [self enableExemptionPayment];
    }
    else
    {
        [HXSUsageManager trackEvent:kUsageEventModifyAvoidPassword parameter:@{@"status":@"关闭"}];
        
        [MBProgressHUD showInView:self.view];
        __weak typeof(self) weakSelf = self;
        [HXSPayPasswordUpdateModel updateExemptionStatus:[NSNumber numberWithBool:NO]
                                     password:nil
                                   completion:^(HXSErrorCode code, NSString *message, NSDictionary *data) {
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       if (kHXSNoError != code) {
                                           [weakSelf.exemptionPaymentSwitch setOn:YES animated:YES];
                                           [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                              status:message
                                                                          afterDelay:1.5f];
                                           return ;
                                       } else {
                                           [[HXSUserAccount currentAccount].userInfo updateUserInfo];
                                       }
                                   }];
    }
}


#pragma mark - Update Exemption Status

- (void)enableExemptionPayment
{
    __weak typeof(self) weakSelf = self;
    
    HXSPayPasswordAlertView *passwordAlertView = [[HXSPayPasswordAlertView alloc] initWithTitle:@"支付密码验证"
                                                                                        message:@""
                                                                                leftButtonTitle:@"取消"
                                                                              rightButtonTitles:@"确认"];
    
    passwordAlertView.leftBtnBlock = ^(NSString *passwordStr, NSNumber *hasSelectedExemptionBoolNum) {
        [weakSelf.exemptionPaymentSwitch setOn:NO animated:YES];
    };

    passwordAlertView.rightBtnBlock = ^(NSString *passwordStr, NSNumber *hasSelectedExemptionBoolNum) {
        [MBProgressHUD showInView:self.view];
        [HXSPayPasswordUpdateModel updateExemptionStatus:[NSNumber numberWithBool:YES]
                                     password:passwordStr
                                   completion:^(HXSErrorCode code, NSString *message, NSDictionary *data) {
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       
                                       if (kHXSPasswordAuthenticationFailedError == code) {
                                           HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                                                             message:message
                                                                                                     leftButtonTitle:@"忘记密码"
                                                                                                   rightButtonTitles:@"重试"];
                                           alertView.leftBtnBlock = ^{
                                                   [weakSelf jumpToGetPayPasswordVerifyViewController];
                                           };
                                           
                                           alertView.rightBtnBlock = ^{
                                               [weakSelf enableExemptionPayment];
                                           };
                                           
                                           [alertView show];
                                           
                                       } else if (kHXSNoError != code) {
                                           [weakSelf.exemptionPaymentSwitch setOn:NO animated:YES];
                                           [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                              status:message
                                                                          afterDelay:1.5f];
                                           return ;
                                       } else {
                                           [[HXSUserAccount currentAccount].userInfo updateUserInfo];
                                       }
                                   }];
        
    };
    
    
    [passwordAlertView show];
}

- (void)jumpToGetPayPasswordVerifyViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalInfo"
                                                         bundle:[NSBundle mainBundle]];
    HXSForgetPasswdVerifyController *passwdVc = [storyboard instantiateViewControllerWithIdentifier:@"HXSForgetPasswdVerifyController"];
    [self.navigationController pushViewController:passwdVc animated:YES];
}

#pragma mark - Private Methods

- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = sourceType;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:@"无法访问相册" afterDelay:1.0];
        } else {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:@"无法使用相机" afterDelay:1.0];
        }
    }
}

#pragma mark - Setter Getter Methods

- (HXSPersonalInfoModel *)personalInfoModel
{
    if (nil == _personalInfoModel) {
        _personalInfoModel = [[HXSPersonalInfoModel alloc] init];
    }
    
    return _personalInfoModel;
}


@end

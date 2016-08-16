//
//  HXSWalletContactViewController.m
//  store
//
//  Created by hudezhi on 15/7/24.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSWalletContactViewController.h"

#import "HXSWalletSelectContactViewController.h"
#import "HXSContactManager.h"
#import "HXSPayHeaderView.h"
#import "HXSFinanceOperationManager.h"
#import "HXSBorrowModel.h"
#import "HXSPayPasswordAlertView.h"

#define HEIGHT_HEADER_FOOTER_VIEW   50

@interface HXSWalletContactViewController ()<UITextFieldDelegate,
                                             HXSPayPasswordAlertViewDelegate,
                                             UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *firstContactLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondContactLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdContactLabel;

@property (weak, nonatomic) IBOutlet UITextField *firstContactNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondContactNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *thirdContactNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *firstContactPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondContactPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *thirdContactPhoneTextField;
@property (weak, nonatomic) IBOutlet HXSRoundedButton *submitBtn;

@property (nonatomic, assign) NSInteger editSection;


@end

@implementation HXSWalletContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self populateInformationFromManager];
    
    self.title = @"联系人信息";
    
    [self setupContactTextFields];
    [self checkWalletContactInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - override

- (void)back
{
    [self saveInformationToManager];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - private method

- (void)populateInformationFromManager
{
    HXSFinanceOperationManager *operationMgr = [HXSFinanceOperationManager sharedManager];
    
    // 59 Borrow
    if (operationMgr.borrowInfo.contactList.count > 0) {
        HXSBorrowContactInfo *contact1 = operationMgr.borrowInfo.contactList[0];
        _firstContactLabel.text = contact1.relationShip;
        _firstContactNameTextField.text = contact1.contactName;
        _firstContactPhoneTextField.text = contact1.contactPhone;
    }
    
    if (operationMgr.borrowInfo.contactList.count > 1) {
        HXSBorrowContactInfo *contact2 = operationMgr.borrowInfo.contactList[1];
        _secondContactLabel.text = contact2.relationShip;
        _secondContactNameTextField.text = contact2.contactName;
        _secondContactPhoneTextField.text = contact2.contactPhone;
    }
    
    if (operationMgr.borrowInfo.contactList.count > 2) {
        HXSBorrowContactInfo *contact3 = operationMgr.borrowInfo.contactList[2];
        _thirdContactLabel.text = contact3.relationShip;
        _thirdContactNameTextField.text = contact3.contactName;
        _thirdContactPhoneTextField.text = contact3.contactPhone;
    }
}

- (void)saveInformationToManager
{
    HXSFinanceOperationManager *operationMgr = [HXSFinanceOperationManager sharedManager];
    
    // 59 Borrow
    HXSBorrowContactInfo *contact1 = [HXSBorrowContactInfo borrowContactInfoWithName:_firstContactNameTextField.text
                                                                            phoneNum:_firstContactPhoneTextField.text
                                                                        relationShip:_firstContactLabel.text];
    HXSBorrowContactInfo *contact2 = [HXSBorrowContactInfo borrowContactInfoWithName:_secondContactNameTextField.text
                                                                            phoneNum:_secondContactPhoneTextField.text
                                                                        relationShip:_secondContactLabel.text];
    HXSBorrowContactInfo *contact3 = [HXSBorrowContactInfo borrowContactInfoWithName:_thirdContactNameTextField.text
                                                                            phoneNum:_thirdContactPhoneTextField.text
                                                                        relationShip:_thirdContactLabel.text];
    
    operationMgr.borrowInfo.contactList = @[contact1, contact2, contact3];
    
    [operationMgr save];
}

- (void)setupContactTextFields
{
    [_firstContactNameTextField addTarget:self action:@selector(checkWalletContactInfo) forControlEvents:UIControlEventEditingChanged];
    [_secondContactNameTextField addTarget:self action:@selector(checkWalletContactInfo) forControlEvents:UIControlEventEditingChanged];
    [_thirdContactNameTextField addTarget:self action:@selector(checkWalletContactInfo) forControlEvents:UIControlEventEditingChanged];
    [_firstContactPhoneTextField addTarget:self action:@selector(checkWalletContactInfo) forControlEvents:UIControlEventEditingChanged];
    [_secondContactPhoneTextField addTarget:self action:@selector(checkWalletContactInfo) forControlEvents:UIControlEventEditingChanged];
    [_thirdContactPhoneTextField addTarget:self action:@selector(checkWalletContactInfo) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)isTextFieldContainText:(UITextField *)texiField
{
    return [texiField.text trim].length > 0;
}

- (BOOL)isContactInfoValid
{
    return ([self isTextFieldContainText:_firstContactNameTextField] &&
            [self isTextFieldContainText:_secondContactNameTextField] &&
            [self isTextFieldContainText:_thirdContactNameTextField] &&
            [self isTextFieldContainText:_firstContactPhoneTextField] &&
            [self isTextFieldContainText:_secondContactPhoneTextField] &&
            [self isTextFieldContainText:_thirdContactPhoneTextField]);
    
}

- (void)checkWalletContactInfo
{
    _submitBtn.enabled = [self isContactInfoValid];
}

- (void)alertWarningMessage:(NSString *)message {
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                      message:message
                                                              leftButtonTitle:@"确定"
                                                            rightButtonTitles:nil];
    [alertView show];
}


#pragma mark - tableview delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        HXSPayHeaderView *header = [[HXSPayHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, HEIGHT_HEADER_FOOTER_VIEW)];
        header.textLabel.text = @"请填写三个联系人的信息";
        
        return header;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return HEIGHT_HEADER_FOOTER_VIEW;
    }
    
    return 0.1;
}


#pragma mark - Target Methods

- (IBAction)submitBtnPressed:(id)sender
{
    NSString *telephone1 = [_firstContactPhoneTextField.text compressBlank];
    NSString *telephone2 = [_secondContactPhoneTextField.text compressBlank];
    NSString *telephone3 = [_thirdContactPhoneTextField.text compressBlank];
    
    if([telephone1 isEqualToString:telephone2] || [telephone2 isEqualToString:telephone3] || [telephone3 isEqualToString:telephone1]) {
        [self alertWarningMessage:@"联系人号码不能重复"];
        return ;
    }
    
    [self saveInformationToManager];
    
    HXSContactInfoEntity *contactEntity = [[HXSContactInfoEntity alloc] init];
    contactEntity.parentNameStr = self.firstContactNameTextField.text;
    contactEntity.parentTelephoneStr = telephone1;
    contactEntity.roommateNameStr = self.secondContactNameTextField.text;
    contactEntity.roommateTelephoneStr = telephone2;
    contactEntity.classmateNameStr = self.thirdContactNameTextField.text;
    contactEntity.classmateTelephoneStr = telephone3;
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showInView:self.view];
    [HXSBorrowModel submitContactInfo:contactEntity
                             complete:^(HXSErrorCode code, NSString *message, NSDictionary *contactInfo) {
                                 [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                 
                                 if(weakSelf.navigationController == nil) {
                                     return;
                                 }
                                 
                                 if (code == kHXSNoError) {
                                     [weakSelf.navigationController popViewControllerAnimated:YES];
                                 }
                                 else if (code == kHXSFinanceBorrowLoanSerialNumRepeat) {
                                     if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                                         
                                         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                                         UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                             [[HXSFinanceOperationManager sharedManager] clearBorrowInfo];
                                             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                         }];
                                         
                                         [alert addAction:action];
                                         
                                         [weakSelf presentViewController:alert animated:YES completion:nil];
                                         alert.view.tintColor = [UIColor colorWithRGBHex:0x07A9FA];
                                     } else {
                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alert show];
                                     }
                                 }
                                 else {
                                     [weakSelf alertWarningMessage:message];
                                 }

                             }];
}

- (IBAction)addContanctButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)[btn superviewOfClassType:[UITableViewCell class]];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _editSection = indexPath.section;
    [self performSegueWithIdentifier:@"SelectContactSegue" sender:nil];
}


#pragma mark - backward

-(IBAction)backToContactSegue:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[HXSWalletSelectContactViewController class]]) {
        HXSContactInfo *info = ((HXSWalletSelectContactViewController *)segue.sourceViewController).contactInfo;
        switch (_editSection) {
            case 0:
                _firstContactNameTextField.text = info.name;
                _firstContactPhoneTextField.text = info.phoneNumber;
                break;
            case 1:
                _secondContactNameTextField.text = info.name;
                _secondContactPhoneTextField.text = info.phoneNumber;
                break;
            case 2:
                _thirdContactNameTextField.text = info.name;
                _thirdContactPhoneTextField.text = info.phoneNumber;
                break;
            
            default:
                break;
        }
        
        [self checkWalletContactInfo];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[HXSFinanceOperationManager sharedManager] clearBorrowInfo];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

//
//  HXSAuthorizeViewController.m
//  store
//
//  Created by hudezhi on 15/7/24.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSAuthorizeViewController.h"
#import "HXSFinanceOperationManager.h"
#import <AddressBook/AddressBook.h>
#import "HXSBorrowModel.h"
#import "HXSContactManager.h"

@implementation HXSAuthorizeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"信息授权";
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)onClickAgreeBtn:(id)sender
{
    [[HXSFinanceOperationManager sharedManager] save];
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        });
        return;
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        HXSCustomAlertView *alert = [[HXSCustomAlertView alloc] initWithTitle:@"提示" message:@"请到 设置->59store 中允许访问通讯录" leftButtonTitle:@"确定" rightButtonTitles:nil];
        [alert show];
               [[HXSFinanceOperationManager sharedManager] save];
        return;
    } else {
        [HXSLoadingView showLoadingInView:self.view];
        
        __weak typeof(self) weakSelf = self;
        HXSFinanceOperationManager *operationMgr = [HXSFinanceOperationManager sharedManager];
        
        [HXSBorrowModel submitCreditcardContactsList:operationMgr.borrowInfo.contactDictionary
                                            complete:^(HXSErrorCode code, NSString *message, NSDictionary *dict) {
                                                [HXSLoadingView closeInView:weakSelf.view];
                                                
                                                if (code == kHXSNoError) {
                                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                                } else {
                                                    [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                       status:message
                                                                                   afterDelay:1.0f];
                                                }
                                            }];
    }
    
}
@end

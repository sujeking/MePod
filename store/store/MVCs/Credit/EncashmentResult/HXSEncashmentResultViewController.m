//
//  HXSEncashmentResultViewController.m
//  store
//
//  Created by ArthurWang on 16/2/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSEncashmentResultViewController.h"

#import "HXSFinanceOperationManager.h"

@interface HXSEncashmentResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *aviableLoanLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation HXSEncashmentResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialAviableLoanLabel];
    
    [self initialConfirmBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Intial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"取现申请";
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}

- (void)initialAviableLoanLabel
{
    self.aviableLoanLabel.text = [NSString stringWithFormat:@"￥%0.2f", [self.encashmentAmountFloatNum floatValue]];
}

- (void)initialConfirmBtn
{
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 4.0f;
}


#pragma mark - Override Methods

- (void)back
{
    [[HXSFinanceOperationManager sharedManager] clearBorrowInfo];
    
    RootViewController * rootViewController = [AppDelegate sharedDelegate].rootViewController;
    if (rootViewController.selectedIndex == kHXSTabBarWallet) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [rootViewController setSelectedIndex:kHXSTabBarWallet];
        
        UIViewController *mainvc = [self.navigationController firstViewControllerOfClass:@"HXSDiscoverViewController"];
        [self.navigationController popToViewController:mainvc animated:YES];
    }
}


#pragma mark - Target Methods

- (IBAction)onClickGoBackBtn:(id)sender
{
    [self back];
}


@end

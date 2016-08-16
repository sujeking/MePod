//
//  HXSCreditPayRegisterSuccessViewController.m
//  store
//
//  Created by hudezhi on 15/7/27.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSCreditPayRegisterSuccessViewController.h"

#import "HXSUpgradeCreditViewController.h"

static NSString * const kUsageEventConfirmPayWalletAscendingLine  = @"confirm_pay_wallet_ascending_line";

@interface HXSCreditPayRegisterSuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *creditLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *limitCell;

@end

@implementation HXSCreditPayRegisterSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialTableView];
    
    [self setupCreditLimit];
    
    [self setupIntroduceLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton   = YES;
}

- (void)initialTableView
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([self.limitCell respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.limitCell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)setupCreditLimit
{
    self.creditLimitLabel.text = [NSString stringWithFormat:@"￥%0.2f", [self.creditLimitFloatNum floatValue]];
}

- (void)setupIntroduceLabel
{
    NSString *prefixStr = @"1、59钱包额度可用于花不完频道里的商品在线消费。\n2、出账日为每个月的25号，还款日为次月5号，还款日当天会从绑定的银行卡（尾号";
    NSString *cardStr = (nil == self.bankCardTailNumberStr) ? @"" : self.bankCardTailNumberStr;
    NSString *suffixStr = @"）中自动进行还款。";
    NSString *wholeStr = [NSString stringWithFormat:@"%@%@%@", prefixStr, cardStr, suffixStr];
    NSRange bandTailingNumberRange = [wholeStr rangeOfString:cardStr];
    
    NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
    [mutableAttributedStr addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:12.0f]
                                 range:NSMakeRange(0, [wholeStr length])];
    [mutableAttributedStr addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRGBHex:0x999999]
                                 range:NSMakeRange(0, [wholeStr length])];
    [mutableAttributedStr addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor redColor]
                                 range:bandTailingNumberRange];
    
    
    self.introduceLabel.attributedText = mutableAttributedStr;
}


#pragma mark - Override Methods

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Target Methods

- (IBAction)onClickGoShoppingBtn:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    RootViewController * rootViewController = [AppDelegate sharedDelegate].rootViewController;
    [rootViewController setSelectedIndex:kHXSTabBarWallet];
}

- (IBAction)onClickGoUpgradingBtn:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventConfirmPayWalletAscendingLine parameter:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HXSUpgradeCreditViewController class])];
    [self.navigationController pushViewController:vc animated:YES];
}



@end

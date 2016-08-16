//
//  HXSBorrowView.m
//  store
//
//  Created by hudezhi on 15/11/5.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSBorrowView.h"

#import "HXSWalletNotOpenView.h"
#import "HXSWalletApplicationView.h"
#import "HXSWalletUpgradingView.h"
#import "HXSWalletNormalView.h"

#import "UIView+Utilities.h"

static NSString *TipTextOpened          = @"剩余可用额度";
static NSString *TipTextDidNotOpened    = @"最高可享受额度";

static CGFloat const kMaxAmountCreditCard = 8000.00;

@interface HXSBorrowView () <HXSWalletNormalViewDelegate, HXSWalletUpgradingViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UIView *walletStatusView;

@property (weak, nonatomic) IBOutlet UILabel *tipTextLabel;

@property (nonatomic, strong) HXSUserCreditcardInfoEntity *creditCardInfo;
@property (nonatomic, weak) id<HXSBorrowViewDelegate> borrowViewDelegate;

@end

@implementation HXSBorrowView

- (void)awakeFromNib
{
    [self initialView];
}

#pragma mark - Public Methods

+ (instancetype)createBorrwViewWithDelegate:(id<HXSBorrowViewDelegate>)delegate
{
    HXSBorrowView *borrowView = [HXSBorrowView viewFromNib];
    
    borrowView.borrowViewDelegate = delegate;
    
    return borrowView;
}

- (void)updateBorrowView
{
    [self initialView];
    
    switch ([self.creditCardInfo.accountStatusIntNum intValue]) {
        case kHXSCreditAccountStatusNotOpen:
        {
            [_balanceView setCurrentValue:kMaxAmountCreditCard maxValue:kMaxAmountCreditCard];
            
            _balanceView.tipText = TipTextDidNotOpened;
            
            //未开通信用钱包
            [self creditAccountNotOpen];
            
            [self.tipView setHidden:YES];
        }
            break;
        case kHXSCreditAccountStatusOpened:
        case kHXSCreditAccountStatusNormalFreeze:
        case kHXSCreditAccountStatusAbnormalFreeze:
        {
            [_balanceView setCurrentValue:self.creditCardInfo.availableCreditDoubleNum.floatValue maxValue:self.creditCardInfo.totalCreditDoubleNum.floatValue];
            
            _balanceView.tipText = TipTextOpened;
            
            switch ([self.creditCardInfo.lineStatusIntNum intValue]) {
                case kHXSCreditLineStatusInit:
                case kHXSCreditLineStatusDone:
                {
                    [self creditAccountNormal];
                }
                    break;
                    
                    
                case kHXSCreditLineStatusChecking:
                case kHXSCreditLineStatusFailed:
                case kHXSCreditLineStatusDataNotClear:
                {
                    [self creditAccountUpgrading];
                }
                    break;
                default:
                    break;
            }
            
            [self.tipView setHidden:NO];
        }
            break;
        case kHXSCreditAccountStatusChecking:
        case kHXSCreditAccountStatusCheckFailed:
        {
            [_balanceView setCurrentValue:kMaxAmountCreditCard maxValue:kMaxAmountCreditCard];
            
            _balanceView.tipText = TipTextDidNotOpened;
            
            [self creditAccountCheck];
            
            [self.tipView setHidden:NO];
        }
            break;
            
        default:
            break;
    }
}



#pragma mark - Initial Methods

- (void)initialView
{
    //下方的提示文案
    NSString *creditNumStr = self.creditCardInfo.bankCardTailStr;
    NSString *foreBodyStr = @"还款日会从您绑定的银行卡(尾号";
    NSString *tipTextStr = [NSString stringWithFormat:@"%@%@)中自动扣除，请保留银行卡中有足够余额，以避免产生额外费用", foreBodyStr, creditNumStr];
    NSMutableAttributedString *tipTextAttributeMStr = [[NSMutableAttributedString alloc] initWithString:tipTextStr];
    [tipTextAttributeMStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(foreBodyStr.length, creditNumStr.length)];
    self.tipTextLabel.attributedText = tipTextAttributeMStr;
    
    [self.tipView setHidden:YES];
    
    for (UIView *view in [self.walletStatusView subviews]) {
        [view removeFromSuperview];
    }
    
}


#pragma mark ---- Method For Status

- (void)creditAccountNotOpen
{
    HXSWalletNotOpenView *notOpenView = [HXSWalletNotOpenView createWalletNotOpenView];
    
    [self displayStatusView:notOpenView];
}

- (void)creditAccountNormal
{
    HXSWalletNormalView *normalView = [HXSWalletNormalView createWalletNormalViewWithDelegate:self];
    
    [self displayStatusView:normalView];
}

- (void)creditAccountUpgrading
{
    HXSWalletUpgradingView *upgradingView = [HXSWalletUpgradingView createWalletUpgradingViewWithDelegate:self];
    
    [self displayStatusView:upgradingView];
}

- (void)creditAccountCheck
{
    HXSWalletApplicationView *applicationView = [HXSWalletApplicationView createWalletApplicationView];
    
    [self displayStatusView:applicationView];
}

- (void)displayStatusView:(UIView *)statusView
{
    [self.walletStatusView addSubview:statusView];
    
    [statusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.walletStatusView);
    }];
    
    [self.walletStatusView layoutIfNeeded];
}




#pragma mark - HXSWalletNormalViewDelegate, HXSWalletUpgradingViewDelegate

- (void)clickedConsumeBtn
{
    if ((nil != self.borrowViewDelegate)
        && [self.borrowViewDelegate respondsToSelector:@selector(gotoWalletView)]) {
        [self.borrowViewDelegate gotoWalletView];
    }
}

- (void)clickedEncashmentBtn
{
    if ((nil != self.borrowViewDelegate)
        && [self.borrowViewDelegate respondsToSelector:@selector(gotoEncashmentView)]) {
        [self.borrowViewDelegate gotoEncashmentView];
    }
}

- (void)clickedInstallmentBtn
{
    if ((nil != self.borrowViewDelegate)
        && [self.borrowViewDelegate respondsToSelector:@selector(gotoInsatallmentView)]) {
        [self.borrowViewDelegate gotoInsatallmentView];
    }
}

- (void)clickedUpgradeBtn
{
    if ((nil != self.borrowViewDelegate)
        && [self.borrowViewDelegate respondsToSelector:@selector(gotoUpgradeView)]) {
        [self.borrowViewDelegate gotoUpgradeView];
    }
}

- (void)clickedReuploadtn
{
    [self clickedUpgradeBtn];
}



#pragma mark - Setter Getter Mehods

- (HXSUserCreditcardInfoEntity *)creditCardInfo
{
    return [HXSUserAccount currentAccount].userInfo.creditCardInfo;
}


@end

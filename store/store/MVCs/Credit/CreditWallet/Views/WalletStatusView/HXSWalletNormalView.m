//
//  HXSWalletNormalView.m
//  store
//
//  Created by ArthurWang on 16/7/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSWalletNormalView.h"

@interface HXSWalletNormalView ()

/** 冻结*/
@property (weak, nonatomic) IBOutlet UILabel *frozenLabel;
/** 消费额度 */
@property (weak, nonatomic) IBOutlet UILabel *consumeAmountLabel;
/** 去消费 */
@property (weak, nonatomic) IBOutlet UIButton *consumeBtn;
/** 取现额度 */
@property (weak, nonatomic) IBOutlet UILabel *enchashmentTipLabel;
/** 去取现 */
@property (weak, nonatomic) IBOutlet UIButton *encashmentBtn;
/** 分期额度 */
@property (weak, nonatomic) IBOutlet UILabel *instalmentAmountLabel;
/** 去分期 */
@property (weak, nonatomic) IBOutlet UIButton *installmentBtn;

/** 提升额度view */
@property (weak, nonatomic) IBOutlet UIView *upgradeLimitView;
/** 提升额度提示 */
@property (weak, nonatomic) IBOutlet UILabel *upgradeLimitLabel;
/** 提升额度提示 */
@property (weak, nonatomic) IBOutlet UILabel *upgradeTipLabel;


@property (nonatomic, strong) HXSUserCreditcardInfoEntity *creditCardInfo;
@property (nonatomic, assign) HXSCreditAccountStatus creditAccountStatus;
@property (nonatomic, assign) HXSCreditLineStatus creditLineStatus;

@property (nonatomic, weak) id<HXSWalletNormalViewDelegate> delegate;

@end

@implementation HXSWalletNormalView


#pragma mark - Public Methods

+ (instancetype)createWalletNormalViewWithDelegate:(id<HXSWalletNormalViewDelegate>)delegate
{
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                     owner:nil
                                                   options:nil];
    
    HXSWalletNormalView *normalView = [viewArr firstObject];
    
    normalView.delegate = delegate;
    
    return normalView;
}


#pragma mark - Initial Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initialView];
}

- (void)initialView
{
    [self initialValues];
    
    [self initialStatus];
}

- (void)initialValues
{
    self.consumeAmountLabel.text = [NSString stringWithFormat:@"¥%.2f", [self.creditCardInfo.availableConsumeDoubleNum doubleValue]];
    self.enchashmentTipLabel.text = [NSString stringWithFormat:@"¥%.2f", [self.creditCardInfo.availableLoanDoubleNum doubleValue]];
    self.instalmentAmountLabel.text = [NSString stringWithFormat:@"¥%.2f", [self.creditCardInfo.availableInstallmentDoubleNum doubleValue]];
}

- (void)initialStatus
{
    [self initialFrozenLabelStatus];
    
    [self initialConsumeAndEncashmentLabelStatus];
    
    [self initialInstallmentLabelStatus];
    
    [self initialUpgradeLimitViewStatus];
}


- (void)initialFrozenLabelStatus
{
    if (kHXSCreditAccountStatusNormalFreeze == self.creditAccountStatus
               || kHXSCreditAccountStatusAbnormalFreeze == self.creditAccountStatus) {
        [self.frozenLabel setHidden:NO];
    } else {
        [self.frozenLabel setHidden:YES];
    }
}

- (void)initialConsumeAndEncashmentLabelStatus
{
    self.consumeBtn.layer.masksToBounds = YES;
    self.consumeBtn.layer.borderWidth = 1.0f;
    self.consumeBtn.layer.cornerRadius = 2.0f;
    
    self.encashmentBtn.layer.masksToBounds = YES;
    self.encashmentBtn.layer.borderWidth = 1.0f;
    self.encashmentBtn.layer.cornerRadius = 2.0f;
    
    
    if (kHXSCreditAccountStatusOpened == self.creditAccountStatus) {
        [self.frozenLabel setHidden:YES];
        self.consumeAmountLabel.textColor    = [UIColor colorWithRGBHex:0xF9A502];
        self.enchashmentTipLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
        
        self.consumeBtn.layer.borderColor = [UIColor colorWithRGBHex:0x07A9FA].CGColor;
        [self.consumeBtn setTitleColor:[UIColor colorWithRGBHex:0x07A9FA] forState:UIControlStateNormal];
        
        
        self.encashmentBtn.layer.borderColor = [UIColor colorWithRGBHex:0x07A9FA].CGColor;
        [self.encashmentBtn setTitleColor:[UIColor colorWithRGBHex:0x07A9FA] forState:UIControlStateNormal];
        
        [self.consumeBtn setEnabled:YES];
        [self.encashmentBtn setEnabled:YES];
        
        [self.consumeBtn addTarget:self
                            action:@selector(onClickConsumeBtn:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.encashmentBtn addTarget:self
                               action:@selector(onClickEncashmentBtn:)
                     forControlEvents:UIControlEventTouchUpInside];
        
    } else if (kHXSCreditAccountStatusNormalFreeze == self.creditAccountStatus
               || kHXSCreditAccountStatusAbnormalFreeze == self.creditAccountStatus) {
        [self.frozenLabel setHidden:NO];
        self.consumeAmountLabel.textColor    = [UIColor colorWithRGBHex:0xCCCCCC];
        self.enchashmentTipLabel.textColor = [UIColor colorWithRGBHex:0xCCCCCC];
        
        self.consumeBtn.layer.borderColor = [UIColor colorWithRGBHex:0xCCCCCC].CGColor;
        [self.consumeBtn setTitleColor:[UIColor colorWithRGBHex:0xCCCCCC] forState:UIControlStateNormal];
        
        self.encashmentBtn.layer.borderColor = [UIColor colorWithRGBHex:0xCCCCCC].CGColor;
        [self.encashmentBtn setTitleColor:[UIColor colorWithRGBHex:0xCCCCCC] forState:UIControlStateNormal];
        
        [self.consumeBtn setEnabled:NO];
        [self.encashmentBtn setEnabled:NO];
        
    } else {
        // Do nothing
    }
}

- (void)initialInstallmentLabelStatus
{
    self.installmentBtn.layer.masksToBounds = YES;
    self.installmentBtn.layer.borderWidth = 1.0f;
    self.installmentBtn.layer.cornerRadius = 2.0f;
    
    if (kHXSCreditAccountStatusNormalFreeze != self.creditAccountStatus
        && kHXSCreditAccountStatusAbnormalFreeze != self.creditAccountStatus
        && (kHXSCreditLineStatusDone == self.creditLineStatus)) {
        
        self.instalmentAmountLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
        
        self.installmentBtn.layer.borderColor = [UIColor colorWithRGBHex:0x07A9FA].CGColor;
        [self.installmentBtn setTitleColor:[UIColor colorWithRGBHex:0x07A9FA] forState:UIControlStateNormal];
        
        [self.installmentBtn setEnabled:YES];
        [self.installmentBtn addTarget:self
                                action:@selector(onClickInstallmentBtn:)
                      forControlEvents:UIControlEventTouchUpInside];
        
        
    } else {
        self.instalmentAmountLabel.textColor = [UIColor colorWithRGBHex:0xCCCCCC];
        
        self.installmentBtn.layer.borderColor = [UIColor colorWithRGBHex:0xCCCCCC].CGColor;
        [self.installmentBtn setTitleColor:[UIColor colorWithRGBHex:0xCCCCCC] forState:UIControlStateNormal];
        
        [self.installmentBtn setEnabled:NO];
    }
}

- (void)initialUpgradeLimitViewStatus
{
    if (kHXSCreditLineStatusDone == self.creditLineStatus) {
        [self.upgradeLimitView setHidden:YES];
    } else {
        [self.upgradeLimitView setHidden:NO];
        
        if ((kHXSCreditAccountStatusNormalFreeze == self.creditAccountStatus)
            || (kHXSCreditAccountStatusAbnormalFreeze == self.creditAccountStatus)) {
            self.upgradeLimitLabel.textColor = [UIColor colorWithRGBHex:0xCCCCCC];
            self.upgradeTipLabel.textColor = [UIColor colorWithRGBHex:0xCCCCCC];
            
            [self.upgradeLimitView setUserInteractionEnabled:NO];
        } else {
            self.upgradeLimitLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            self.upgradeTipLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
            
            [self.upgradeLimitView setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onClickUpgradeView:)];
            
            [self.upgradeLimitView addGestureRecognizer:pan];
        }
    }
}


#pragma mark - Target Methods

- (void)onClickConsumeBtn:(UIButton *)btn
{
    [btn setUserInteractionEnabled:NO];
    
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickedConsumeBtn)]) {
        [self.delegate clickedConsumeBtn];
    }
    
    [btn setUserInteractionEnabled:YES];
}

- (void)onClickEncashmentBtn:(UIButton *)btn
{
    [btn setUserInteractionEnabled:NO];
    
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickedEncashmentBtn)]) {
        [self.delegate clickedEncashmentBtn];
    }
    
    [btn setUserInteractionEnabled:YES];
}

- (void)onClickInstallmentBtn:(UIButton *)btn
{
    [btn setUserInteractionEnabled:NO];
    
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickedInstallmentBtn)]) {
        [self.delegate clickedInstallmentBtn];
    }
    
    [btn setUserInteractionEnabled:YES];
}

- (void)onClickUpgradeView:(UIGestureRecognizer *)gesture
{
    [self.upgradeLimitView setUserInteractionEnabled:NO];
    
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickedUpgradeBtn)]) {
        [self.delegate clickedUpgradeBtn];
    }
    
    [self.upgradeLimitView setUserInteractionEnabled:YES];
}


#pragma mark - Setter Getter Methods

- (HXSUserCreditcardInfoEntity *)creditCardInfo
{
    return [HXSUserAccount currentAccount].userInfo.creditCardInfo;
}

- (HXSCreditAccountStatus)creditAccountStatus
{
    return [self.creditCardInfo.accountStatusIntNum intValue];
}

- (HXSCreditLineStatus)creditLineStatus
{
    return [self.creditCardInfo.lineStatusIntNum intValue];
}


@end

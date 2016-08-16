//
//  HXSWalletUpgradingView.m
//  store
//
//  Created by ArthurWang on 16/7/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSWalletUpgradingView.h"

@interface HXSWalletUpgradingView ()

/** 冻结 */
@property (weak, nonatomic) IBOutlet UILabel *frozenLabel;
/** 消费额度 */
@property (weak, nonatomic) IBOutlet UILabel *consumeAmountLabel;
/** 去消费 */
@property (weak, nonatomic) IBOutlet UIButton *consumeBtn;
/** 取现额度 */
@property (weak, nonatomic) IBOutlet UILabel *enchashmentTipLabel;
/** 去取现 */
@property (weak, nonatomic) IBOutlet UIButton *encashmentBtn;

@property (weak, nonatomic) IBOutlet UIView *upgradeTipView;
/** 提升额度提示信息 */
@property (weak, nonatomic) IBOutlet UILabel *upgradeTipLabel;

@property (nonatomic, strong) HXSUserCreditcardInfoEntity *creditCardInfo;
@property (nonatomic, assign) HXSCreditAccountStatus creditAccountStatus;
@property (nonatomic, assign) HXSCreditLineStatus creditLineStatus;

@property (nonatomic, weak) id<HXSWalletUpgradingViewDelegate> delegate;

@end

@implementation HXSWalletUpgradingView

+ (instancetype)createWalletUpgradingViewWithDelegate:(id<HXSWalletUpgradingViewDelegate>)delegate
{
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                     owner:nil
                                                   options:nil];
    
    HXSWalletUpgradingView *upgradingView = [viewArr firstObject];
    
    upgradingView.delegate = delegate;
    
    return upgradingView;
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

- (void)drawRect:(CGRect)rect
{
    [self drawBorderLayer];
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
}

- (void)initialStatus
{
    [self initialFrozenLabelStatus];
    
    [self initialConsumeAndEncashmentLabelStatus];
    
    [self initialUpgradeTipViewStatus];
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

- (void)initialUpgradeTipViewStatus
{
    switch ([self.creditCardInfo.lineStatusIntNum intValue]) {
        case kHXSCreditLineStatusInit:
        case kHXSCreditLineStatusDone:
        {
            // Do nothing
        }
            break;

        case kHXSCreditLineStatusChecking:
        {
            [self initialUpgradeTipCheckingStatus];
        }
            break;
            
        case kHXSCreditLineStatusFailed:
        {
            [self initialUpgradeTipFailedStatus];
        }
            break;
            
        case kHXSCreditLineStatusDataNotClear:
        {
            [self initialUpgradeTipDataNotClearStatus];
        }
            break;
            
        default:
            break;
    }
    
    [self.upgradeTipLabel layoutIfNeeded];
}

- (void)initialUpgradeTipCheckingStatus
{
    self.upgradeTipLabel.text = @"您的提升额度申请已成功提交，我们的工作人员正在快马加鞭进行审核中，请您耐心等待，期间您可能会接到59工作人员的电话向您核实信息，请保持电话畅通。";
    
    // event
    [self.upgradeTipView setUserInteractionEnabled:NO];
}

- (void)initialUpgradeTipFailedStatus
{
    if (0 < [self.creditCardInfo.accountApplyDaysIntNum integerValue]) {
        NSString *previousStr = @"抱歉，您的59钱包提额申请暂未通过审核，";
        NSString *daysStr = [NSString stringWithFormat:@"%d", [self.creditCardInfo.accountApplyDaysIntNum intValue]];
        NSString *endingStr = @"天后再来申请试试吧~";
        NSString *wholeStr = [NSString stringWithFormat:@"%@%@%@", previousStr, daysStr, endingStr];
        
        NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
        [mutableAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(previousStr.length, daysStr.length)];
        
        self.upgradeTipLabel.attributedText = mutableAttributedStr;
    } else {
        self.upgradeTipLabel.text = @"抱歉，您的59钱包提额申请暂未通过审核";
    }
    
    
    // event
    [self.upgradeTipView setUserInteractionEnabled:NO];
}

- (void)initialUpgradeTipDataNotClearStatus
{
    NSString *previousStr = @"您的提升额度申请资料不够清晰和标准，请重新上传~";
    NSString *endingStr = @"点击重新上传";
    NSString *wholeStr = [NSString stringWithFormat:@"%@%@", previousStr, endingStr];
    
    NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
    [mutableAttributedStr addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRGBHex:0x07A9FA]
                                 range:NSMakeRange(previousStr.length, endingStr.length)];
    
    self.upgradeTipLabel.attributedText = mutableAttributedStr;
    
    
    // event
    [self.upgradeTipView setUserInteractionEnabled:NO];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onClickUpgradeView:)];
    
    [self.upgradeTipView addGestureRecognizer:tap];
}


#pragma mark - Target Methods

- (void)onClickConsumeBtn:(UIButton *)btn
{
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickedConsumeBtn)]) {
        [self.delegate clickedConsumeBtn];
    }
}

- (void)onClickEncashmentBtn:(UIButton *)btn
{
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickedEncashmentBtn)]) {
        [self.delegate clickedEncashmentBtn];
    }
}

- (void)onClickUpgradeView:(UIGestureRecognizer *)gesture
{
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickedReuploadtn)]) {
        [self.delegate clickedReuploadtn];
    }
}


#pragma mark - Private Methods

- (void)drawBorderLayer
{
    //View的边框为虚线
    self.upgradeTipView.backgroundColor = [UIColor colorWithRGBHex:0xF6FDFF];
    self.upgradeTipView.layer.cornerRadius = 3;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    CGRect verifyViewRect = self.upgradeTipView.bounds;
    borderLayer.bounds = verifyViewRect;
    borderLayer.position = CGPointMake(CGRectGetMidX(verifyViewRect), CGRectGetMidY(verifyViewRect));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:3].CGPath;
    borderLayer.lineWidth = 0.5;
    borderLayer.lineDashPattern = @[@3, @3];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor colorWithRGBHex:0x07A9FA].CGColor;
    [self.upgradeTipView.layer addSublayer:borderLayer];
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

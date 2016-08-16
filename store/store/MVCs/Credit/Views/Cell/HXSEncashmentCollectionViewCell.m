//
//  HXSEncashmentCollectionViewCell.m
//  store
//
//  Created by ArthurWang on 16/7/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSEncashmentCollectionViewCell.h"

// model
#import "HXSCreditCardLoanInfoModel.h"

// Views
#import "HXSLoanDetailView.h"
#import "HXSPopView.h"

static CGFloat const kMaxPeriod                   = 12.0f;
static NSInteger const kStepEncashmentAmountValue = 100;
static NSInteger const kStepPeriodVlaue           = 3;
static CGFloat const kMaxValueAvailableLoanIsZero = 0.001;

@interface HXSEncashmentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *encashmentAmountLabel;
@property (weak, nonatomic) IBOutlet UISlider *encashmentAmountSlider;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;                  // *个月
@property (weak, nonatomic) IBOutlet UISlider *encashmentPeriodSlider;
@property (weak, nonatomic) IBOutlet UILabel *monthAmountLabel;          // 月供 ￥0.00
@property (weak, nonatomic) IBOutlet UILabel *originalFeeLabel;          // 原手续费
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeLabel;           // 服务费
@property (weak, nonatomic) IBOutlet UIButton *encashmentBtn;

@property (nonatomic, weak) id<HXSEncashmentCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) NSArray *loanInfoArr;
@property (nonatomic, strong) NSNumber *periodIntNum;
@property (nonatomic, strong) NSNumber *encashmentAmountDoubleNum;

@property (nonatomic, strong) NSNumber *availableLoanDoubleNum;
@property (nonatomic, strong) HXSPopView *popView;

@end


@implementation HXSEncashmentCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.encashmentBtn.layer.masksToBounds = YES;
    self.encashmentBtn.layer.cornerRadius = 4.0f;
    
    [self.encashmentAmountSlider setThumbImage:[UIImage imageNamed:@"ic_huakuai"] forState:UIControlStateNormal];
    [self.encashmentPeriodSlider setThumbImage:[UIImage imageNamed:@"ic_huakuai"] forState:UIControlStateNormal];
}

- (void)dealloc
{
    self.loanInfoArr = nil;
    self.delegate    = nil;
}


#pragma mark - Public Methods

- (void)setupEncahmentCollectionViewCellWithLoanInfo:(NSArray *)loanInfoArr
                                            delegate:(id<HXSEncashmentCollectionViewCellDelegate>)delegate
{
    self.loanInfoArr = loanInfoArr;
    self.delegate    = delegate;
    
    self.encashmentAmountDoubleNum = self.availableLoanDoubleNum;
    
    self.periodIntNum = @6; // default
    
    self.encashmentAmountSlider.minimumValue = 0;
    self.encashmentAmountSlider.maximumValue = [self.availableLoanDoubleNum doubleValue];
    [self.encashmentAmountSlider addTarget:self
                                    action:@selector(changedEncashmentAmountValue:)
                          forControlEvents:UIControlEventValueChanged];
    
    self.encashmentPeriodSlider.minimumValue = 3;  // sort: 3 6 9 12
    self.encashmentPeriodSlider.maximumValue = kMaxPeriod;
    [self.encashmentPeriodSlider addTarget:self
                                    action:@selector(changedPeriodValue:)
                          forControlEvents:UIControlEventValueChanged];
    
    [self updateValues];
}


#pragma mark - Update Values

- (void)updateValues
{
    [self updateLabelValues];
    
    [self updateSliderValues];
}

- (void)updateLabelValues
{
    HXSCreditCardLoanInfoModel *loanInfoModel = [self searchLoanInfo];
    
    // set values
    self.encashmentAmountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [self.encashmentAmountDoubleNum doubleValue]];
    
    self.periodLabel.text = [NSString stringWithFormat:@"%@个月", self.periodIntNum];
    
    self.monthAmountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [loanInfoModel.intallmentAmountDoubleNum doubleValue]];
    
    self.serviceFeeLabel.text = [NSString stringWithFormat:@"￥%0.2f", [loanInfoModel.intallmentServiceFeeDoubleNum doubleValue]];
    
    NSString *originalFeeStr = [NSString stringWithFormat:@"￥%0.2f", [loanInfoModel.intallmentOriginalFeeDoubleNum doubleValue]];
    NSMutableAttributedString *priceAttributedStr = [[NSMutableAttributedString alloc] initWithString:originalFeeStr];
    [priceAttributedStr addAttribute:NSStrikethroughStyleAttributeName
                               value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)
                               range:NSMakeRange(0, [originalFeeStr length])];
    [priceAttributedStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:10]
                               range:NSMakeRange(0, [originalFeeStr length])];
    [priceAttributedStr addAttribute:NSForegroundColorAttributeName
                               value:[UIColor colorWithRGBHex:0x999999]
                               range:NSMakeRange(0, [originalFeeStr length])];
    
    self.originalFeeLabel.attributedText = priceAttributedStr;
}

- (void)updateSliderValues
{
    self.encashmentAmountSlider.value = [self.encashmentAmountDoubleNum doubleValue];
    
    self.encashmentPeriodSlider.value = [self.periodIntNum integerValue];
}


#pragma mark - Target Methods

- (IBAction)onClickMinusBtn:(id)sender
{
    [sender setUserInteractionEnabled:NO];
    
    CGFloat changeValue = [self.encashmentAmountDoubleNum doubleValue] - kStepEncashmentAmountValue;
    
    if (0.0 > changeValue) {
        changeValue = kMaxValueAvailableLoanIsZero;
    }
    
    self.encashmentAmountDoubleNum = [NSNumber numberWithDouble:changeValue];
    
    [self updateValues];
    
    [sender setUserInteractionEnabled:YES];
}

- (IBAction)onClickPlusBtn:(id)sender
{
    [sender setUserInteractionEnabled:NO];
    
    CGFloat changeValue = [self.encashmentAmountDoubleNum doubleValue] + kStepEncashmentAmountValue;
    
    if ([self.availableLoanDoubleNum doubleValue] < changeValue) {
        changeValue = [self.availableLoanDoubleNum doubleValue];
    }
    
    self.encashmentAmountDoubleNum = [NSNumber numberWithDouble:changeValue];
    
    [self updateValues];
    
    [sender setUserInteractionEnabled:YES];
}

- (IBAction)onClickDetailBtn:(id)sender
{
    HXSCreditCardLoanInfoModel *loanInfoModel = [self searchLoanInfo];
    HXSLoanDetailView *detailView = [HXSLoanDetailView createLoanDetailViewWithServiceFee:loanInfoModel.intallmentServiceFeeDoubleNum
                                                                                   amount:loanInfoModel.intallmentAmountDoubleNum];
    
    [detailView.loanAgreementBtn addTarget:self
                                    action:@selector(onClickLoanAgreementBtn:)
                          forControlEvents:UIControlEventTouchUpInside];
    
    HXSPopView *popView = [[HXSPopView alloc] initWithView:detailView];
    
    [popView show];
    
    self.popView = popView;
}

- (void)changedEncashmentAmountValue:(UISlider *)slider
{
    NSInteger value = (NSInteger)slider.value;
    NSInteger remainder = value % kStepEncashmentAmountValue;
    NSInteger times = value / kStepEncashmentAmountValue;
    
    CGFloat changedValue = 0.0;
    if (0 < remainder) {
        changedValue = (times + 1.0) * kStepEncashmentAmountValue;
    } else {
        changedValue = times * kStepEncashmentAmountValue;
    }
    
    self.encashmentAmountDoubleNum = [NSNumber numberWithDouble:changedValue];
    
    [self updateLabelValues];
}

- (void)changedPeriodValue:(UISlider *)slider
{
    NSInteger value = (NSInteger)slider.value;
    NSInteger remainder = value % kStepPeriodVlaue;
    NSInteger times = value / kStepPeriodVlaue;
    
    CGFloat changedValue = 0.0;
    if (0 < remainder) {
        changedValue = (times + 1.0) * kStepPeriodVlaue;
    } else {
        changedValue = times * kStepPeriodVlaue;
    }
    
    self.periodIntNum = [NSNumber numberWithDouble:changedValue];
    
    [self updateLabelValues];
}

- (IBAction)onClickEncashmentBtn:(id)sender
{
    [sender setUserInteractionEnabled:NO];
    
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(didSelectLoanInfo:)]) {
        [self.delegate didSelectLoanInfo:[self searchLoanInfo]];
    }
    
    [sender setUserInteractionEnabled:YES];
}

- (void)onClickLoanAgreementBtn:(UIButton *)button
{
    [button setUserInteractionEnabled:NO];
    
    __weak typeof(self) weakSelf = self;
    [self.popView closeWithCompleteBlock:^{
        if ((nil != weakSelf.delegate)
            && [weakSelf.delegate respondsToSelector:@selector(didSelectLoanAgreement)]) {
            [weakSelf.delegate didSelectLoanAgreement];
        }
    }];
    
    
    [button setUserInteractionEnabled:YES];
}


#pragma mark - Private Methods

- (HXSCreditCardLoanInfoModel *)searchLoanInfo
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"intallmentAllDoubleNum = %@ AND intallmentNumberIntNum = %@",
                              self.encashmentAmountDoubleNum, self.periodIntNum];
    NSArray *modelArr = [self.loanInfoArr filteredArrayUsingPredicate:predicate];
    
    return [modelArr firstObject];
}


#pragma mark - Setter Getter

- (NSNumber *)availableLoanDoubleNum
{
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    if (kMaxValueAvailableLoanIsZero < [creditCardInfo.availableLoanDoubleNum doubleValue]) {
        _availableLoanDoubleNum = creditCardInfo.availableLoanDoubleNum;
    } else {
        _availableLoanDoubleNum = [NSNumber numberWithDouble:kMaxValueAvailableLoanIsZero];
    }

    
    return _availableLoanDoubleNum;
}

@end

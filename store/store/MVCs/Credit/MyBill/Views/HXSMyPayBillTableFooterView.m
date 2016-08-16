//
//  HXSMyPayBillTableFooterView.m
//  store
//
//  Created by J006 on 16/2/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyPayBillTableFooterView.h"

@interface HXSMyPayBillTableFooterView()

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;//提示:
@property (weak, nonatomic) IBOutlet UILabel *tips1stLabel;//1.
@property (weak, nonatomic) IBOutlet UILabel *tips2ndLabel;//2.

@end

@implementation HXSMyPayBillTableFooterView

#pragma mark init

+ (id)myNewPayBillTableFooterView
{    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

- (void)awakeFromNib
{
}

- (void)initTheViewWithMyPayBillListEntity:(HXSMyPayBillListEntity *)entity
{
    if(!entity)
        return;
    switch (entity.billTypeNum)
    {
        case HXSMyBillConsumeTypeNext:
        {
            [_tipsLabel setHidden:NO];
            [_tips1stLabel setHidden:NO];
            [_tips1stLabel setText:@"出账日(每月25日)至当前产生的账单将暂时出现在这里"];
            [_tips2ndLabel setHidden:YES];
            break;
        }
        case HXSMyBillConsumeTypeHistoy:
        {
            [_tipsLabel setHidden:YES];
            [_tips1stLabel setHidden:YES];
            [_tips2ndLabel setHidden:YES];
            break;
        }
        case HXSMyBillConsumeTypeCurrent:
        {
            [_tipsLabel setHidden:NO];
            [_tips1stLabel setHidden:NO];
            [_tips1stLabel setText:@"1、账单生成日为每月25日。"];
            [_tips2ndLabel setHidden:NO];
            NSString *bankTailNumStr = [[HXSUserAccount currentAccount].userInfo creditCardInfo].bankCardTailStr;
            if(!bankTailNumStr)
                bankTailNumStr = @"";
            [self updateTheTips2WithTailNum:bankTailNumStr];
            break;
        }
    }
}


#pragma mark - private funnction

/**
 *第二条提示文案的更新
 */
- (void)updateTheTips2WithTailNum:(NSString *)tailStr
{
    NSString *tailNumber  = tailStr;
    NSString *cardNumber = ( 0 < tailNumber.length) ? tailNumber : @"";
    NSString *prevStringBack = @"2、还款日（";
    NSString *prevStringTail = @"2、还款日（每月5日）会从您绑定的银行卡（尾号";
    NSString *timeDate = @"每月5日";
    NSString *tipTextStr = [NSString stringWithFormat:@"2、还款日（%@）会从您绑定的银行卡（尾号%@）中自动扣除，请保持银行卡中有足够的余额，以免产生额外费用。", timeDate, cardNumber];
    NSMutableAttributedString *tipTextAttributeMStr = [[NSMutableAttributedString alloc] initWithString:tipTextStr];
    [tipTextAttributeMStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(prevStringBack.length, timeDate.length)];
    if(![tailStr isEqualToString:@""])
        [tipTextAttributeMStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(prevStringTail.length, cardNumber.length)];
    _tips2ndLabel.attributedText = tipTextAttributeMStr;
}

@end

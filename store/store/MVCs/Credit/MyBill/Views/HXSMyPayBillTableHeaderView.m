//
//  HXSMyNewPayBillTableHeaderView.m
//  store
//
//  Created by J006 on 16/2/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyPayBillTableHeaderView.h"

@interface HXSMyPayBillTableHeaderView()

@property (weak, nonatomic) IBOutlet UIView               *topView;
/**当前订单头日期 */
@property (weak, nonatomic) IBOutlet UILabel              *billHeaderDateLabel;
/**已逾期图片或者已还完 */
@property (weak, nonatomic) IBOutlet UIImageView          *outofDateImageView;
/**合计数字 */
@property (weak, nonatomic) IBOutlet UILabel              *totalCostLabel;
/**合计字样  */
@property (weak, nonatomic) IBOutlet UILabel              *totalTitleLabel;

@end

@implementation HXSMyPayBillTableHeaderView

+ (id)myPayBillTableHeaderView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

- (void)awakeFromNib
{
}


#pragma mark - init

- (void)initTheViewWithEntity:(HXSMyPayBillListEntity *)entity
{
    if(!entity)
        return;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[entity.billTimeNum doubleValue]];
    NSString *time = [formatter stringFromDate:date];
    [_billHeaderDateLabel setText:time];
    [_totalCostLabel setText:[NSString stringWithFormat:@"¥%.2f", [entity.billAmountNum doubleValue]]];
    [self setTheOutofDateImageWithType:entity.billStatusNum];

}

- (void)setTheOutofDateImageWithType:(HXSMyBillConsumeStatus)status
{
    [_outofDateImageView setHidden:NO];
    switch (status) {
        case kHXSMyBillConsumeStatusNotPay:
        {
            [_totalTitleLabel setText:@"合计"];
            [_outofDateImageView setHidden:YES];
            break;
        }
        case kHXSMyBillConsumeStatusPayed:
        {
            [_totalTitleLabel setText:@"合计"];
            [_outofDateImageView setImage:[UIImage imageNamed:@"ic_bill_finished"]];
            break;
        }
        case kHXSMyBillConsumeStatusDelay:
        {
            [_totalTitleLabel setText:@"合计(含逾期费)"];
            [_outofDateImageView setImage:[UIImage imageNamed:@"ic_bill_overdue"]];
            break;
        }
    }
}

@end

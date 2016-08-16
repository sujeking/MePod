//
//  HXSMyPayBillCell.m
//  store
//
//  Created by J006 on 16/2/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyPayBillCell.h"

@interface HXSMyPayBillCell ()

@property (weak, nonatomic) IBOutlet UIImageView      *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel          *billNameLabel;
@property (weak, nonatomic) IBOutlet UILabel          *billDateLabel;
@property (weak, nonatomic) IBOutlet UILabel          *billCostLabel;


@end

@implementation HXSMyPayBillCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


#pragma mark - init

- (void)initMyPayBillCellWithEntity:(HXSMyPayBillDetailEntity *)entity
{

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:entity.urlStr]
                          placeholderImage:[UIImage imageNamed:@"ic_defaulticon_loading"]];
    
    if(entity.textStr) {
        [_billNameLabel setText:entity.textStr];
    }
    
    if(entity.timeStrNum) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[entity.timeStrNum doubleValue]];
        NSString *time = [formatter stringFromDate:date];
        [_billDateLabel setText:time];
    }
    
    if(entity.amountNum) {
        [_billCostLabel setText:[NSString stringWithFormat:@"¥%.2f",[entity.amountNum doubleValue]]];
    }
}


@end

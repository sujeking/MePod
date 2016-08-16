//
//  HXSPrintSettingPrintReduceCell.m
//  store
//
//  Created by J006 on 16/3/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintSettingPrintReduceCell.h"

@interface HXSPrintSettingPrintReduceCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation HXSPrintSettingPrintReduceCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    
    _contentLabel.layer.masksToBounds = YES;
    _contentLabel.layer.cornerRadius  = 3.0f;
    _contentLabel.layer.borderWidth   = 1.0f;
}


#pragma mark - init

- (void)setupCellWithPrintEntity:(HXSPrintSettingEntity *)entity
                          status:(HXSPrintSettingButtonStatus)status
{
    NSString *content = [NSString stringWithFormat:@"%@ ¥%.2f",entity.printNameStr,[entity.unitPriceNum doubleValue]];
    [_contentLabel setText:content];
    
    [self updateStatus:status];
}

- (void)setupCellWithReduceEntity:(HXSPrintSettingReducedEntity *)entity
                           status:(HXSPrintSettingButtonStatus)status
{
    [_contentLabel setText:entity.reduceedNameStr];
    
    [self updateStatus:status];
}

- (void)updateStatus:(HXSPrintSettingButtonStatus)status
{
    _currentStatus = status;
    
    switch (status)
    {
        case kHXSPrintSettingButtonStatusNormal:
        {
            [_contentLabel.layer setBorderColor:[UIColor colorWithRGBHex:0xCCCCCC].CGColor];
            [_contentLabel setBackgroundColor:[UIColor whiteColor]];
            [_contentLabel setTextColor:[UIColor colorWithRGBHex:0x666666]];
            break;
        }
        case kHXSPrintSettingButtonStatusSelected:
        {
            [_contentLabel.layer setBorderColor:[UIColor colorWithRGBHex:0x07A9FA].CGColor];
            [_contentLabel setBackgroundColor:[UIColor whiteColor]];
            [_contentLabel setTextColor:[UIColor colorWithRGBHex:0x07A9FA]];
            break;
        }
        case kHXSPrintSettingButtonStatusUnable:
        {
            [_contentLabel.layer setBorderColor:[UIColor colorWithRGBHex:0xCCCCCC].CGColor];
            [_contentLabel setBackgroundColor:[UIColor whiteColor]];
            [_contentLabel setTextColor:[UIColor colorWithRGBHex:0xCCCCCC]];
            break;
        }
    }
}

@end

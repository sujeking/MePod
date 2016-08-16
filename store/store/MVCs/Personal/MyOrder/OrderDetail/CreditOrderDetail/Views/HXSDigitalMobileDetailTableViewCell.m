//
//  HXSDigitalMobileDetailTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/3/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileDetailTableViewCell.h"

@interface HXSDigitalMobileDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;  // "￥0.00"
@property (weak, nonatomic) IBOutlet UILabel *numberLabel; // "x1"
@property (weak, nonatomic) IBOutlet UILabel *amountLabel; // "￥0.00"


@end

@implementation HXSDigitalMobileDetailTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Public Methods

- (void)setupCellWithOrderItem:(HXSOrderItem *)orderItem
{
    // 名称
    self.nameLabel.text = orderItem.name;
    
    // 规格
    self.specificationLabel.text = orderItem.specificationsStr;
    
    // 单价
    self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [orderItem.price floatValue]];
    
    // 个数
    self.numberLabel.text = [NSString stringWithFormat:@"x%ld", [orderItem.quantity longValue]];
    
    // 合计
    self.amountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [orderItem.amount floatValue]];
}

@end

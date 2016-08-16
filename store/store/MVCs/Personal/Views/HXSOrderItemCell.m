//
//  HXSOrderItemCell.m
//  store
//
//  Created by ranliang on 15/5/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSOrderItemCell.h"

#import "HXSBoxOrderEntity.h"
#import "HXSStoreCartItemEntity.h"
#import "HXSBoxOrderModel.h"

@interface HXSOrderItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalPriceLabel;


@end

@implementation HXSOrderItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

-(void)configWithOrderItem:(HXSOrderItem *)item
{
    self.nameLabel.text = item.name;
    self.unitPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [item.price floatValue]];
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", (long)[item.quantity integerValue]];
    self.subtotalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [item.amount floatValue]];
    
}

- (void)configWithOrderRewardItem:(HXSOrderItem *)item
{
    self.nameLabel.text = item.name;
    
    NSString *priceStr = [NSString stringWithFormat:@"￥%0.2f", [item.price doubleValue]];
    NSMutableAttributedString *priceAttStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [priceAttStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, priceStr.length)];
    [priceAttStr addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, priceStr.length)];
    [priceAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, priceStr.length)];
    [priceAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, priceStr.length)];
    
    self.unitPriceLabel.attributedText = priceAttStr;
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", (long)[item.quantity integerValue]];
    self.subtotalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [item.amount floatValue]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setBoxItem:(HXSBoxOrderItemModel *)boxItem
{
    self.nameLabel.text = boxItem.nameStr;
    self.unitPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [boxItem.priceDoubleNum floatValue]];
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", (long)[boxItem.quantityNum intValue]];
    self.subtotalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [boxItem.amountDoubleNum floatValue]];
}

- (void)setStoreItem:(HXSStoreCartItemEntity *)storeItem {
    _storeItem = storeItem;
    self.nameLabel.text = storeItem.nameStr;
    self.unitPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [storeItem.priceNum floatValue]];
    self.countLabel.text = [NSString stringWithFormat:@"x%ld", (long)[storeItem.quantityNum intValue]];
    self.subtotalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [storeItem.amountNum floatValue]];
}
@end

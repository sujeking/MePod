//
//  HXSDormCheckoutFoodCell.m
//  store
//
//  Created by hudezhi on 15/9/21.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSDormCheckoutFoodCell.h"

@interface HXSDormCheckoutFoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation HXSDormCheckoutFoodCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setItem:(HXSDormCartItem *)item
{
    [self.foodImageView sd_setImageWithURL:[NSURL URLWithString:item.imageMedium] placeholderImage:[UIImage imageNamed:@"img_kp_list"]];
    
    _nameLabel.text = item.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥ %0.2f", [item.price doubleValue]];
    _countLabel.text = [NSString stringWithFormat:@"x%i", [item.quantity intValue]];
    _amountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [item.amount doubleValue]];
}

- (void)setPromotionItems:(HXSCartsItem *)item
{
    [self.foodImageView sd_setImageWithURL:[NSURL URLWithString:item.imageMediumStr] placeholderImage:[UIImage imageNamed:@"img_kp_list"]];
    
    self.nameLabel.text = item.nameStr;

    NSString *priceStr = [NSString stringWithFormat:@"￥%0.2f", [item.OriginPrice doubleValue]];
    
    NSMutableAttributedString *priceAttStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [priceAttStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, priceStr.length)];
    [priceAttStr addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, priceStr.length)];
    [priceAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, priceStr.length)];
    [priceAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, priceStr.length)];
    
    self.priceLabel.attributedText = priceAttStr;


    self.countLabel.text = [NSString stringWithFormat:@"x%i", [item.quantityNum intValue]];
    self.amountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [item.amountNum doubleValue]];

    self.countLabel.text = [NSString stringWithFormat:@"x%i", [item.quantityNum intValue]];
    self.amountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [item.amountNum doubleValue]];

    self.countLabel.text = [NSString stringWithFormat:@"x%i", [item.quantityNum intValue]];
    self.amountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [item.amountNum doubleValue]];

    self.countLabel.text = [NSString stringWithFormat:@"x%i", [item.quantityNum intValue]];
    self.amountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [item.amountNum doubleValue]];

}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end

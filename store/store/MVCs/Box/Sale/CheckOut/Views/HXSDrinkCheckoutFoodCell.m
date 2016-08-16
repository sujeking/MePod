//
//  HXSDrinkCheckoutFoodCell.m
//  store
//
//  Created by hudezhi on 15/11/24.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSDrinkCheckoutFoodCell.h"

@interface HXSDrinkCheckoutFoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

@end

@implementation HXSDrinkCheckoutFoodCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFoodItem:(HXSDrinkCartItemEntity *)foodItem
{
    NSString *imageUrl = [foodItem.imageMediumStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.foodImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"img_kp_list"]];
    
    _foodNameLabel.text = foodItem.nameStr;
    _priceLabel.text = [NSString stringWithFormat:@"￥%0.02f", [foodItem.priceNum floatValue]];
    _quantityLabel.text = [NSString stringWithFormat:@"x%d", [foodItem.quantityNum intValue]];
    _totalAmountLabel.text = [NSString stringWithFormat:@"￥%0.02f", [foodItem.amountNum floatValue]];
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end

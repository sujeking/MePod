//
//  HXSDigitalMobileTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileTableViewCell.h"

#import "HXSDigitalMobileItemListEntity.h"

@interface HXSDigitalMobileTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowPriceLabel;           // should be "￥0.00"

@end

@implementation HXSDigitalMobileTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}


#pragma mark - Public Methods

- (void)setupCellWithEntity:(HXSDigitalMobileItemListEntity *)itemListEntity
{
    // 图片
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:itemListEntity.iamgeURLStr]
                          placeholderImage:[UIImage imageNamed:@"img_kp_3c"]];
    
    // 名字
    self.itemNameLabel.text = itemListEntity.nameStr;
    
    // 售价
    self.lowPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [itemListEntity.lowPriceFloatNum floatValue]];
}

@end

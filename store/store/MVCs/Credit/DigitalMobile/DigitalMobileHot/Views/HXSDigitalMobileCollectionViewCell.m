//
//  HXSDigitalMobileCollectionViewCell.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileCollectionViewCell.h"

#import "HXSDigitalMobileItemListEntity.h"

@interface HXSDigitalMobileCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLoanPriceLabel;        // should be "￥0.00"

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payNowBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;

@end

@implementation HXSDigitalMobileCollectionViewCell

- (void)awakeFromNib
{
    self.buyBtn.layer.masksToBounds = YES;
    self.buyBtn.layer.cornerRadius = 4.0f;
    
    if (320 == SCREEN_WIDTH) {
        self.payNowBottomConstraint.constant = 1;
        self.titleTopConstraint.constant     = 1;
        self.imageTopConstraint.constant     = 1;
    }
}


#pragma mark - Public Methods

- (void)setupCellWithEntity:(HXSDigitalMobileItemListEntity *)entity
{
    // 图片
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:entity.iamgeURLStr]
                          placeholderImage:[UIImage imageNamed:@"img_kp_3c"]];
    
    // 名字
    self.itemNameLabel.text = entity.nameStr;
    
    // 最低价
    self.lowLoanPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [entity.lowPriceFloatNum floatValue]];
}

@end

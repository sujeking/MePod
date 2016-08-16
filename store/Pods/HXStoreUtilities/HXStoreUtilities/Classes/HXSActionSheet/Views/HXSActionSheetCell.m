//
//  HXSActionSheetCell.m
//  store
//
//  Created by ArthurWang on 15/12/8.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSActionSheetCell.h"

#import "HXSActionSheetEntity.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "HXMacrosUtils.h"

@implementation HXSActionSheetCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}


#pragma mark - Public Methods

- (void)setupWithEntity:(HXSActionSheetEntity *)entity
{
    [self.payTypeImageView sd_setImageWithURL:[NSURL URLWithString:entity.iconURLStr]
                             placeholderImage:nil];
    
    [self.payNameLabel setText:entity.nameStr];
    
    // 有促销信息时显示促销信息，否则显示描述信息
    if (0 < [entity.promotionStr length]) {
        [self.payDetailLabel setHidden:NO];
        self.payNameLabelCenterConstraint.constant = -6;
        self.payDetailLabel.textColor = UIColorFromRGB(0xF54642);
        self.payDetailLabel.text = entity.promotionStr;
    } else if (0 < [entity.descriptionStr length]) {
        [self.payDetailLabel setHidden:NO];
        self.payNameLabelCenterConstraint.constant = -6;
        self.payDetailLabel.textColor = UIColorFromRGB(0xCCCCCC);
        self.payDetailLabel.text = entity.descriptionStr;
    } else {
        [self.payDetailLabel setHidden:YES];
        self.payNameLabelCenterConstraint.constant = 0;
    }
    
    
    [self layoutIfNeeded];
}


@end

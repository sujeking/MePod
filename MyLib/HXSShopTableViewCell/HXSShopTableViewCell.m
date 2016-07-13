//
//  HXSShopTableViewCell.m
//  aaaaaa
//
//  Created by  黎明 on 16/7/11.
//  Copyright © 2016年 suzw. All rights reserved.
//

#import "HXSShopTableViewCell.h"

@interface HXSShopTableViewCell()

@property (nonatomic, weak) IBOutlet UIView *iconView;

@end

@implementation HXSShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self.iconView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.iconView.layer setBorderWidth:3.0f];
    [self.iconView.layer setCornerRadius:CGRectGetWidth(self.iconView.bounds)/2];
    [self.iconView.layer setMasksToBounds:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

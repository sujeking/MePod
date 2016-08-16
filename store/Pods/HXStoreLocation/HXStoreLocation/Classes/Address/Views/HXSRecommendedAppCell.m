//
//  HXSRecommendedAppCell.m
//  store
//
//  Created by ranliang on 15/6/29.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSRecommendedAppCell.h"

#import "HXSRecommendedApp.h"
#import "UIImageView+WebCache.h"

@interface HXSRecommendedAppCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation HXSRecommendedAppCell

- (void)configWithModel:(HXSRecommendedApp *)model
{
    self.titleLabel.text = model.title;
    self.descriptionLabel.text = model.desc;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:[UIImage imageNamed:@"img_kp_list"]];
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end

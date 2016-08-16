//
//  HXSCommunityNitifacationCell.m
//  store
//
//  Created by  黎明 on 16/4/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityNitifacationCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation HXSCommunityNitifacationCell

- (void)awakeFromNib
{

    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setcornerRadius];
}

/**
 *  设置圆角
 */
- (void)setcornerRadius
{
    self.useIconImageView.layer.cornerRadius = self.useIconImageView.frame.size.height/2;
    self.useIconImageView.layer.masksToBounds = YES;
    
    
    CAShapeLayer *shapeLayer                     = [CAShapeLayer layer];
    UIBezierPath *path                           = [UIBezierPath bezierPathWithRoundedRect:self.noticeBgView.bounds
                                                                              cornerRadius:5];
    shapeLayer.path                              = path.CGPath;
    self.noticeBgView.layer.mask   = shapeLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initMsgContent:(NSString *)msgContent andMsgIconUrl:(NSString *)msgIconUrl
{
    if (msgContent.length == 0) {
        return;
    }
    
    self.MsgContentLabel.text = msgContent;
    [self.MsgContentLabel setAdjustsFontSizeToFitWidth:YES];
    
    [self.useIconImageView sd_setImageWithURL:[NSURL URLWithString:msgIconUrl]
                             placeholderImage:[UIImage imageNamed:@"img_headsculpture_small"]];
}

@end

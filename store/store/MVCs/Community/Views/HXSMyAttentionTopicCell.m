//
//  HXSMyAttentionTopicCell.m
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyAttentionTopicCell.h"


@implementation HXSMyAttentionTopicCell

- (void)awakeFromNib
{
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setFollowedTopicEntitys:(NSArray *)followedTopicEntitys
{
    NSInteger followedCount = [followedTopicEntitys count];
    
    [self.itamsScrollView setContentSize:CGSizeMake(108*followedCount, 0)];
    
    for (UIView *view in self.itamsScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    
    for (int i = 0; i < followedCount; i ++) {
        
        HXSTopic *topicEntity = followedTopicEntitys[i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(100+8)+8, 0, 100, 70)];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:5];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        shapeLayer.path = path.CGPath;
        
        imageView.layer.mask = shapeLayer;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:topicEntity.bigImageStr]];
        
        imageView.tag = i;
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopicTitleItem:)];
        
        [imageView addGestureRecognizer:tapGestureRecognizer];
        
        [self.itamsScrollView addSubview:imageView];
    }

}



- (void)setup
{
    self.itamsScrollView.scrollsToTop = NO;
    self.itamsScrollView.layer.borderWidth = 0;
}

/**
 *  更多按钮点击
 *
 *  @param sender
 */
- (IBAction)loadMoreButtonClick:(id)sender
{
    if (self.loadMoreBlock) {
        self.loadMoreBlock();
    }
}

/**
 *  话题标题点击事件
 *
 *  @param sender
 */
- (void)tapTopicTitleItem:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *)[sender view];
    
    if (self.loadTopicList) {
    
        self.loadTopicList(imageView.tag);
    }
    
}



@end

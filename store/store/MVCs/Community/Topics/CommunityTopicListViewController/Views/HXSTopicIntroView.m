//
//  HXSTopicIntroView.m
//  store
//
//  Created by  黎明 on 16/4/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTopicIntroView.h"


#define followColor     [UIColor colorWithR:32 G:170 B:247 A:1]
#define unfollowColor   [UIColor whiteColor]
@implementation HXSTopicIntroView

-(void)awakeFromNib
{
    [self setupSubViews];
}

/**
 *  设置子控件
 */
- (void)setupSubViews
{
    self.followTopicButton.layer.cornerRadius = 2;
    self.followTopicButton.layer.masksToBounds = YES;
}



- (void)setIsFollowThisTopic:(BOOL)isFollowThisTopic
{
    if (isFollowThisTopic) {
        self.followTopicButton.layer.borderWidth = 0.5;
        self.followTopicButton.layer.borderColor = [[UIColor colorWithR:222 G:222 B:222 A:1] CGColor];
        [self.followTopicButton setBackgroundColor:unfollowColor];
        [self.followTopicButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.followTopicButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.followTopicButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [self.followTopicButton setBackgroundColor:followColor];
        [self.followTopicButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.followTopicButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.followTopicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.followTopicButton.layer.borderColor = [[UIColor colorWithR:245 G:246 B:247 A:0] CGColor];
        
    }
}


@end

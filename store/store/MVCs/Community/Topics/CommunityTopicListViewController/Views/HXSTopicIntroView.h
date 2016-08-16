//
//  HXSTopicIntroView.h
//  store
//
//  Created by  黎明 on 16/4/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSTopicIntroView : UIView

/**
 *  是否关注该话题
 */
@property (nonatomic, assign) BOOL isFollowThisTopic;

/**
 *  话题图标
 */
@property (weak, nonatomic) IBOutlet UIImageView  *topicIconImageView;
/**
 *  话题简介
 */
@property (weak, nonatomic) IBOutlet UILabel      *topicIntroLabel;
/**
 *  关注/取消关注 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton      *followTopicButton;

@end

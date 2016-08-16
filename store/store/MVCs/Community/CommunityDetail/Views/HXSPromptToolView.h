//
//  HXSPromptToolView.h
//  store
//
//  Created by  黎明 on 16/4/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPost.h"
/**
 *  帖子详情提示按钮工具页面【点赞、评论、分享 按钮】
 */
@interface HXSPromptToolView : UIView

//点赞view
@property (nonatomic, weak) IBOutlet UIView      *likeView;
@property (nonatomic, weak) IBOutlet UIImageView *likeIconImageView;
@property (nonatomic, weak) IBOutlet UILabel     *likeNumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeWidthConstraint;
//回复view
@property (nonatomic, weak) IBOutlet UIView      *replyView;
@property (nonatomic, weak) IBOutlet UIImageView *replyIconImageView;
@property (nonatomic, weak) IBOutlet UILabel     *replyNumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyWidthConstraint;

//分享view
@property (nonatomic, weak) IBOutlet UIView      *shareView;
@property (nonatomic, weak) IBOutlet UIImageView *shareIconImageView;
@property (nonatomic, weak) IBOutlet UILabel     *shareNumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareWidthConstraint;

//分享帖子回调
@property (nonatomic, copy) void (^shareTheCommunity)();
//点赞
@property (nonatomic, copy) void (^likeTheCommunity)();
//评论
@property (nonatomic, copy) void (^commentTheCommunity)();

@property (nonatomic, copy) NSNumber *shareCount;
@property (nonatomic, copy) NSNumber *commentCount;
@property (nonatomic, copy) NSNumber *likeCount;

@property (nonatomic, strong) HXSPost *postEntity;

@end

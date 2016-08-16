//
//  HXSHXSCommunityFootrCell.h
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPost.h"
/**
 *  帖子底部  【时间  点赞，评论，分享】
 */
@interface HXSCommunityFootrCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteButtonWithContain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteButtonWithTrailing;

/**
 *  点赞回调
 */
@property (nonatomic, copy) void (^likeActionBlock)();
/**
 *  回复回调
 */
@property (nonatomic, copy) void (^replyActionBlock)();
/**
 *  分享回调
 */
@property (nonatomic, copy) void (^shareActionBlock)();

/**
 *  删除帖子回调
 */
@property (nonatomic, copy) void (^deleteActionBlock)();


@property (nonatomic, strong)HXSPost *postEntity;
// 是否需要删除按钮
@property (nonatomic, assign) BOOL isNeedDeleteButton;
@end

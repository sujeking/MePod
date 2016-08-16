//
//  HXSCommunittyItemReplyItemTitleTableViewCell.h
//  store
//
//  Created by  黎明 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPost.h"
#import "TTTAttributedLabel.h"

@protocol HXSCommunittyItemReplyItemTitleTableViewCellDelegate <NSObject>

@optional

/**
 *  复制回复
 *
 *  @param commentEntity
 */
- (void)copyTheContentWithComment:(HXSComment *)commentEntity;

/**
 *  举报回复
 *
 *  @param commentEntity
 */
- (void)reportTheContentWithComment:(HXSComment *)commentEntity;

@end

/**
 *  回复人的cell 【头像，名称，时间，回复按钮】
 */
@interface HXSCommunittyItemReplyItemTitleTableViewCell : UITableViewCell<TTTAttributedLabelDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *userProfileImageView;      //用户头像
@property (nonatomic, weak) IBOutlet UILabel     *userNickNameLabel;         //用户昵称
@property (nonatomic, weak) IBOutlet UILabel     *replyTimeLabel;            //回复时间
@property (nonatomic, weak) IBOutlet UIButton    *replyOrDeleteButton;       //回复/删除按钮
@property (nonatomic, weak) IBOutlet TTTAttributedLabel     *replyContentLabel;         //回复内容

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyContentLabelConstraint;//回复内容高度约束

@property (nonatomic, copy) void (^replyActionBlock)();    //回复按钮点击回调block
@property (nonatomic, copy) void (^deleteCommentActionBlock)();         //删除按钮点击回调block
@property (nonatomic, copy) void (^loadCommentUserCenterActionBlock)();       //进入评论人中心


@property (nonatomic, strong) HXSComment *commentEntity; //回复信息

@property (nonatomic, weak) id<HXSCommunittyItemReplyItemTitleTableViewCellDelegate> delegate;

+ (CGFloat)getCellHeightWithCommentText:(NSString *)contentText;
@end

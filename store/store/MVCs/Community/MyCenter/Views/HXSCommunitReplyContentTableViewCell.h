//
//  HXSCommunitReplyContentTableViewCell.h
//  store
//  "我的回复"和"回复我的"内容
//  Created by J006 on 16/4/20.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSCommunityCommentEntity.h"

@protocol HXSCommunitReplyContentTableViewCellDelegate <NSObject>

@optional
/**
 *  跳转到他人中心
 */
- (void)confirmJumpToCenter:(HXSCommunityCommentUser *)user;

@end

@interface HXSCommunitReplyContentTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HXSCommunitReplyContentTableViewCellDelegate> delegate;

- (void)initCommunitReplyContentTableViewCellWithEntity:(HXSCommunityCommentEntity *)commentEntity;

@end

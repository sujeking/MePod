//
//  HXSCommunitCommentTopicTableViewCell.h
//  store
//  回复内容的话题类型
//  Created by J006 on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSCommunityCommentEntity.h"

typedef NS_ENUM(NSInteger, CommunitCommentTopicTableViewCellType)
{
    kCommunitCommentTopicTableViewCellTypeMyReply     = 0,
    kCommunitCommentTopicTableViewCellTypeReplyForMe  = 1,
};

@protocol HXSCommunitCommentTopicTableViewCellDelegate <NSObject>

@optional
/**
 *  跳转到话题
 */
- (void)confirmJumpToTopic:(HXSCommunityCommentEntity *)entity;

/**
 *  确定删除
 */
- (void)confirmDelete:(HXSCommunityCommentEntity *)entity;

/**
 *  确认回复
 */
- (void)confirmReply:(HXSCommunityCommentEntity *)entity;

@end

@interface HXSCommunitCommentTopicTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HXSCommunitCommentTopicTableViewCellDelegate> delegate;

- (void)initCommunitCommentTopicTableViewCellWithEntity:(HXSCommunityCommentEntity *)commentEntity
                                            andWithType:(CommunitCommentTopicTableViewCellType)type;

@end

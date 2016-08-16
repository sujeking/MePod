//
//  HXSCommunitReplyTopicTableViewCell.h
//  store
//  "我的回复"与"回复我的"中帖子原始内容和帖子主人
//  Created by J006 on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSCommunityCommentEntity.h"

@interface HXSCommunitReplyTopicTableViewCell : UITableViewCell

- (void)initCommunitReplyTopicTableViewCellWithEntity:(HXSCommunityCommentEntity *)commentEntity;

@end

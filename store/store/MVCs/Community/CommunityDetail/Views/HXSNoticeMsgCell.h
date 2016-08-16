//
//  HXSNoticeMsgCell.h
//  store
//
//  Created by  黎明 on 16/4/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSCommunityMessage;

@interface HXSNoticeMsgCell : UITableViewCell


/** 用户头像 */
@property (nonatomic, weak) IBOutlet UIImageView *userProfileImageView;
/** 被回复帖子缩略图 */
@property (nonatomic, weak) IBOutlet UIImageView *communityShotImageView;
/** 用户名 */
@property (nonatomic, weak) IBOutlet UILabel *userProfileNameLabel;
/** 回复内容 */
@property (nonatomic, weak) IBOutlet UILabel *replyMsgLabel;
/** 回复时间 */
@property (nonatomic, weak) IBOutlet UILabel *replyTimeLabel;
/** 被回复内容缩略文字 */
@property (nonatomic, weak) IBOutlet UILabel *communityShotContentLabel;

@property(nonatomic, strong) HXSCommunityMessage *communityMessage;

@end

//
//  HXSCommunityContentCell.h
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPost.h"

@protocol HXSCommunityContentTextCellDelegate <NSObject>

@optional

/**
 *  复制帖子
 *
 *  @param postEntity 
 */
- (void)copyTheContentWithEntity:(HXSPost *)postEntity;

/**
 *  举报帖子
 *
 *  @param postEntity
 */
- (void)reportTheContentWithEntity:(HXSPost *)postEntity;

/**
 *  删除帖子
 *
 *  @param postEntity postEntity
 */
- (void)deleteTheContentWithEntity:(HXSPost *)postEntity;

@end

/**
 *  帖子主题 【内容，文字  图片】
 */
@interface HXSCommunityContentTextCell : UITableViewCell

@property (nonatomic, weak) id<HXSCommunityContentTextCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//帖子内容Label
/*
 选择内容
 */
@property (nonatomic,copy) void (^selectCommunityItem)();
/**
 *  进入该话题列表
 */
@property (nonatomic,copy) void (^loadCommunityTopicList)(NSInteger index);

@property (nonatomic, strong) HXSPost *postEntity;

/**
 *  根据内容返回cell的高度
 *
 *  @param contentText
 *
 *  @return
 */
+ (CGFloat)getCellHeightWithText:(NSString *)contentText;

@end

//
//  HXSCommunityMyCenterTableDelegate.h
//  store
//
//  Created by J006 on 16/5/5.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HXSCommunitCommentType)
{
    kHXSCommunitCommentTypeMyReply     = 0,//我的回复
    kHXSCommunitCommentTypeReplyToMe   = 1,//回复我的
};

@interface HXSCommunityMyCenterTableDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>

/**
 *  初始化
 *
 *  @param tableView
 *  @param superViewController 
 *  @param HXSCommunitCommentType
 */
- (void)initWithTableView:(UITableView *)tableView
      superViewController:(UIViewController *)superViewController
              andWithType:(HXSCommunitCommentType)type;

/**
 *  刷新读取
 */
- (void)reload;
/**
 *  获取"我的回复"
 *
 *  @param isNew 是否是第一次
 *  @param isHeaderRefresher 是否是下拉刷新
 */
- (void)fetchMyRepliesNetworkingIsNew:(BOOL)isNew isHeaderRefresher:(BOOL)isHeaderRefresher;
/**
 *  网络请求回复我的
 *
 *  @param isNew
 *  @param isHeaderRefresher 是否是下拉刷新
 */
- (void)fetchRepliesForMeNetworkingIsNew:(BOOL)isNew isHeaderRefresher:(BOOL)isHeaderRefresher;

@end

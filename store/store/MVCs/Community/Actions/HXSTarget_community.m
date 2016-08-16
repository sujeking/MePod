//
//  HXSTarget_community.m
//  store
//
//  Created by ArthurWang on 16/5/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTarget_community.h"

/** 跳转社区话题详情页面 */
#import "HXSCommunityTopicListViewController.h"

/** 跳转帖子详情页面 */
#import "HXSCommunityDetailViewController.h"

@implementation HXSTarget_community

/** 跳转社区话题详情页面 */
// hxstore://community/topic/detail?topic_id=123&topic_title=话题标题
- (UIViewController *)Action_topicdetail:(NSDictionary *)paramsDic
{
    NSString *topicIDStr = [paramsDic objectForKey:@"topic_id"];
    NSString *titleStr   = [paramsDic objectForKey:@"topic_title"];
    
    HXSCommunityTopicListViewController *topicListVC = [HXSCommunityTopicListViewController createCommunityTopicListVCWithTopicID:topicIDStr title:[titleStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] delegate:nil];
    
    return topicListVC;
}

/** 跳转帖子详情页面 */
// hxstore://community/post/detail?post_id=123
- (UIViewController *)Action_postdetail:(NSDictionary *)paramsDic
{
    NSString *postIDStr = [paramsDic objectForKey:@"post_id"];
    
    HXSCommunityDetailViewController *detailVC = [HXSCommunityDetailViewController createCommunityDetialVCWithPostID:postIDStr
                                                                                                           replyLoad:NO
                                                                                                                 pop:nil];
    
    return detailVC;
}

@end

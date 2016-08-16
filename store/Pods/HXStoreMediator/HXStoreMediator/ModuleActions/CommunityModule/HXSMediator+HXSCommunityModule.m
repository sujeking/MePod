//
//  HXSMediator+HXSCommunityModule.m
//  store
//
//  Created by ArthurWang on 16/5/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMediator+HXSCommunityModule.h"

static NSString *kHXSMediatorTargetCommunity   = @"community";

static NSString *kHXSMediatorActionTopicDetial = @"topic_detail";
static NSString *kHXSMediatorActionPostDetial  = @"post_detail";

@implementation HXSMediator (HXSCommunityModule)

/** hxstore://community/topic/detail?topic_id=123&topic_title=话题标题 */
/** 跳转社区话题详情页面 */
- (UIViewController *)HXSMediator_topicDetailViewControllerWithParams:(NSDictionary *)params
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetCommunity
                                                    action:kHXSMediatorActionTopicDetial
                                                    params:params];
    
    return viewController;
}

/** hxstore://community/post/detail?post_id=123 */
/** 跳转帖子详情页面 */
- (UIViewController *)HXSMediator_postDetailViewControllerWithParams:(NSDictionary *)params
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetCommunity
                                                    action:kHXSMediatorActionPostDetial
                                                    params:params];
    
    return viewController;
}

@end

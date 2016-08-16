//
//  HXSTarget_community.h
//  store
//
//  Created by ArthurWang on 16/5/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSTarget_community : NSObject

/** 跳转社区话题详情页面 */
// hxstore://community/topic/detail?topic_id=123&topic_title=话题标题
- (UIViewController *)Action_topicdetail:(NSDictionary *)paramsDic;

/** 跳转帖子详情页面 */
// hxstore://community/post/detail?post_id=123
- (UIViewController *)Action_postdetail:(NSDictionary *)paramsDic;

@end

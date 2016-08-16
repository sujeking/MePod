//
//  HXSCommunityTopicsModel.h
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSTopic.h"

@interface HXSCommunityTopicsModel : NSObject

/**
 *  获取话题列表
 *
 *  @param block 
 */
+(void)getCommmutityTopicList:(void (^)(HXSErrorCode code, NSString *message, NSArray *followTopics,NSArray *unFollowTopics))block;


/**
 *  关注话题
 *
 *  @param topicsArr 关注的话题数组
 *  @param block
 */
+(void)commmutityFollowTopics:(NSArray *)topicsArr
                     complete:(void(^)(HXSErrorCode code, NSString *message,NSDictionary *dictionary))block;


/**
 *  关注或者取消话题
 *
 *  @param topic_id    话题id
 *  @param followOrNot 关注还是取消 0取消 1关注
 *  @param block
 */
+(void)followTopicWithTopicId:(NSString *)topic_id
                  followOrNot:(NSNumber *)followOrNot
                     complete:(void(^)(HXSErrorCode code, NSString * message, HXSTopic * topic))block;

/**
 *  判断话题关注状态
 *
 *  @param topic_id 话题id
 *  @param block    
 */
+(void)getTopicInfoWithTopicId:(NSString *)topic_id
                      complete:(void(^)(HXSErrorCode code, NSString * message, HXSTopic * topic))block;


//获取推荐的话题【4月27新增】
+ (void)getCommunityRecommendTopicWithComplete:(void(^)(HXSErrorCode code, NSString * message, NSArray * posts))block;
@end

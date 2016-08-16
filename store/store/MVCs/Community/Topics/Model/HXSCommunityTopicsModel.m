//
//  HXSCommunityTopicsModel.m
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityTopicsModel.h"

@implementation HXSCommunityTopicsModel
// 获取话题列表
+(void)getCommmutityTopicList:(void (^)(HXSErrorCode code, NSString *message, NSArray *followTopics,NSArray *unFollowTopics))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[HXSUserAccount currentAccount].strToken forKey:@"token"];

    [HXStoreWebService getRequest:HXS_COMMUNITY_TOPIC_LIST
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data){
                       
                       if(kHXSNoError == status){
                          DLog(@"------社区 获取话题列表 %@",data);
                           NSMutableArray *followArray = [NSMutableArray array];
                           NSMutableArray *unFollowArray = [NSMutableArray array];
                           
                           NSArray *dataArr = [data objectForKey:@"follow_topics"];
                           if(dataArr){
                               for(NSDictionary *dic in dataArr){
                                   HXSTopic *topicItem = [HXSTopic objectFromJSONObject:dic];
                                   topicItem.isFollowedIntNum = @(HXSTopicFollowTypeFollowed);
                                   [followArray addObject:topicItem];
                               }
                           }
                           dataArr = [data objectForKey:@"un_follow_topics"];
                           if(dataArr){
                               for(NSDictionary *dic in dataArr){
                                   HXSTopic *topicItem = [HXSTopic objectFromJSONObject:dic];
                                   topicItem.isFollowedIntNum = @(HXSTopicFollowTypeUnFollowed);
                                   [unFollowArray addObject:topicItem];
                               }
                           }
                           
                           block(status,msg,followArray,unFollowArray);
                           
                       }else{
                           block(status,msg,nil,nil);
                       }
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil,nil);
    }];
    }

// 关注话题
+(void)commmutityFollowTopics:(NSArray *)topicsArr
                     complete:(void(^)(HXSErrorCode code, NSString *message,NSDictionary *dictionary))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[HXSUserAccount currentAccount].strToken forKey:@"token"];
    NSString *topic_ids = @"";
    for(HXSTopic *topic in topicsArr){
        topic_ids = [topic_ids stringByAppendingString:[NSString stringWithFormat:@"%@,",topic.idStr]];
    }
    topic_ids = [topic_ids substringWithRange:NSMakeRange(0, topic_ids.length  - 1)];
    [dic setObject:topic_ids forKey:@"topic_ids"];
    
    [HXStoreWebService postRequest:HXS_COMMUNITY_TOPIC_FOLLOW
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
            block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];
}


// 关注或者取消话题
+(void)followTopicWithTopicId:(NSString *)topic_id followOrNot:(NSNumber *)followOrNot complete:(void(^)(HXSErrorCode code, NSString * message, HXSTopic * topic))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:topic_id forKey:@"topic_id"];
    [dic setObject:followOrNot forKey:@"type"];
    
    [HXStoreWebService postRequest:HXS_COMMUNITY_TOPIC_FOLLOW_ONE
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        DLog(@"------社区 关注或者取消话题 %@",data);
                        
                        HXSTopic *topicItem = [HXSTopic objectFromJSONObject:data];
                        block(status,msg,topicItem);
                        
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                         block(status,msg,nil);
                    }];
}

// 判断话题关注状态
+(void)getTopicInfoWithTopicId:(NSString *)topic_id complete:(void(^)(HXSErrorCode code, NSString * message, HXSTopic * topic))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:topic_id forKey:@"topic_id"];
    
    [HXStoreWebService getRequest:HXS_COMMUNITY_TOPIC_INVALID
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        DLog(@"------社区 获取话题状态 %@",data);
        
        HXSTopic *topicItem = [HXSTopic objectFromJSONObject:data];
        block(status,msg,topicItem);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

//获取推荐话题
+ (void)getCommunityRecommendTopicWithComplete:(void(^)(HXSErrorCode code, NSString * message, NSArray * posts))block
{
    [HXStoreWebService getRequest:HXS_COMMUNITY_RECOMMENDED_TOPIC
                parameters:nil
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       DLog(@"------推荐的话题 %@",data);
                       if(kHXSNoError == status){
                           
                           NSMutableArray *resultArray = [NSMutableArray array];
                           if(DIC_HAS_ARRAY(data, @"topics")){
                               NSArray *arr = [data objectForKey:@"topics"];
                               for(NSDictionary *dic in arr ){
                                   
                                   HXSTopic *topicItem = [HXSTopic objectFromJSONObject:dic];

                                   [resultArray addObject:topicItem];
                               }
                           }
                           block(status,msg,resultArray);
                           
                       }else{
                           block(status,msg,nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status,msg,nil);
                   }];
    
}


@end


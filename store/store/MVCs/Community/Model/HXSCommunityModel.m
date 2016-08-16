//
//  HXSCommunityModel.m
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityModel.h"
#import "HXSPost+PostH5.h"
#import "HXSPost.h"

//每页请求的数量
NSInteger const PageNum = 20;

@implementation HXSCommunityModel

/**
 *  获取关注的话题
 */
-(void)getTopicOfConcern
{
    
}

// 获取热门帖子
+ (void)getCommunityHotPostsWithTopicId:(NSString *)topic_id
                                siteId:(NSString *)site_id
                                  page:(NSNumber *)page
                               complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * posts, NSString *shareLinkStr))block {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:topic_id forKey:@"topic_id"];
    [dic setObject:site_id forKey:@"site_id"];
    [dic setObject:page forKey:@"page"];
    [dic setObject:@(PageNum) forKey:@"page_size"];
    
    [HXStoreWebService getRequest:HXS_COMMUNITY_POST_HONT
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       DLog(@"------社区 热门帖子 %@",data);
                       
                       if(kHXSNoError == status){
                           
                           NSMutableArray *resultArray = [NSMutableArray array];
                           if(DIC_HAS_ARRAY(data, @"posts")){
                               NSArray *arr = [data objectForKey:@"posts"];
                               for(NSDictionary *dic in arr ){
                                   HXSPost *temp = [HXSPost objectFromJSONObject:dic];
                                   temp.siteIdStr = [NSString stringWithFormat:@"%@",dic[@"site_id"]];
                                   temp.postTypeIntNum = dic[@"type"];
                                   temp.detailLinkStr = dic[@"detail_link"];
                                   temp.firstImgUrlStr = dic[@"first_img"];
                                   temp.postTitleStr = dic[@"post_title"];
                                   temp.circleNameStr = dic[@"circle_name"];
                                   [resultArray addObject:temp];
                               }
                           }

                           NSString *shareLinkStr = nil;
                           if (DIC_HAS_STRING(data, @"share_link")) {
                               shareLinkStr = data[@"share_link"];
                           }

                           
                           block(status,msg,resultArray,shareLinkStr);
                       
                       }else{
                           block(status,msg,nil,nil);
                       }
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil,nil);
    }];
}

// 获取推荐帖子列表
+ (void)getCommunityRecommendPostsWithTopicId:(NSString *)topic_id
                                      siteId:(NSString *)site_id
                                        page:(NSNumber *)page
                                    complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * posts))block{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:topic_id forKey:@"topic_id"];
    [dic setObject:site_id forKey:@"site_id"];
    [dic setObject:page forKey:@"page"];
    [dic setObject:@(PageNum) forKey:@"page_size"];
    
    [HXStoreWebService getRequest:HXS_COMMUNITY_POST_RECOMMEND
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       DLog(@"------社区 推荐帖子 %@",data);
                       
                       if(kHXSNoError == status){
                           
                           NSMutableArray *resultArray = [NSMutableArray array];
                           if(DIC_HAS_ARRAY(data, @"posts")){
                               NSArray *arr = [data objectForKey:@"posts"];
                               for(NSDictionary *dic in arr ){
                                   HXSPost *temp = [HXSPost objectFromJSONObject:dic];
                                   temp.siteIdStr = [NSString stringWithFormat:@"%@",dic[@"site_id"]];
                                   temp.postTypeIntNum = dic[@"type"];
                                   temp.detailLinkStr = dic[@"detail_link"];
                                   temp.firstImgUrlStr = dic[@"first_img"];
                                   temp.postTitleStr = dic[@"post_title"];
                                   temp.circleNameStr = dic[@"circle_name"];
                                   [resultArray addObject:temp];
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


// 获取全部帖子列表
+ (void)getCommunityAllPostsWithTopicId:(NSString *)topic_id
                                siteId:(NSString *)site_id
                                  page:(NSNumber *)page
                               complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * posts, NSString *topicShareLinkStr))block {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:topic_id forKey:@"topic_id"];
    [dic setObject:site_id forKey:@"site_id"];
    [dic setObject:page forKey:@"page"];
    [dic setObject:@(PageNum) forKey:@"page_size"];
    
    [HXStoreWebService getRequest:HXS_COMMUNITY_POST_ALL
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       DLog(@"------社区 全部帖子 %@",data);
                       
                       if(kHXSNoError == status){
                           
                           NSMutableArray *resultArray = [NSMutableArray array];
                           if(DIC_HAS_ARRAY(data, @"posts")){
                               NSArray *arr = [data objectForKey:@"posts"];
                               for(NSDictionary *dic in arr ){
                                   HXSPost *temp = [HXSPost objectFromJSONObject:dic];
                                   temp.siteIdStr = [NSString stringWithFormat:@"%@",dic[@"site_id"]];
                                   temp.postTypeIntNum = dic[@"type"];
                                   temp.detailLinkStr = dic[@"detail_link"];
                                   temp.firstImgUrlStr = dic[@"first_img"];
                                   temp.postTitleStr = dic[@"post_title"];
                                   temp.circleNameStr = dic[@"circle_name"];
                                   [resultArray addObject:temp];
                               }
                           }
                           NSString *shareLinkStr = nil;
                           if (DIC_HAS_STRING(data, @"share_link")) {
                               shareLinkStr = data[@"share_link"];
                           }
                           
                           block(status,msg,resultArray,shareLinkStr);
                           
                       } else {
                           block(status,msg,nil,nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status,msg,nil,nil);
                   }];

}

// 获取关注话题的帖子列表
+ (void)getCommunityFollowPostsWithPage:(NSNumber *)page
                              complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * posts))block{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:page forKey:@"page"];
    [dic setObject:@(PageNum) forKey:@"page_size"];
    [HXStoreWebService getRequest:HXS_COMMUNITY_POST_FOLLOW
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       DLog(@"------社区 关注话题帖子 %@",data);
                       
                       if(kHXSNoError == status){
                           
                           NSMutableArray *resultArray = [NSMutableArray array];
                           if(DIC_HAS_ARRAY(data, @"posts")){
                               NSArray *arr = [data objectForKey:@"posts"];
                               for(NSDictionary *dic in arr ){
                                   HXSPost *temp = [HXSPost objectFromJSONObject:dic];
                                   temp.siteIdStr = [NSString stringWithFormat:@"%@",dic[@"site_id"]];
                                   temp.postTypeIntNum = dic[@"type"];
                                   temp.detailLinkStr = dic[@"detail_link"];
                                   temp.firstImgUrlStr = dic[@"first_img"];
                                   temp.postTitleStr = dic[@"post_title"];
                                   temp.circleNameStr = dic[@"circle_name"];
                                   [resultArray addObject:temp];
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


// 根据帖子列表类型获取帖子列表
+ (void)getCommunityPostListWithType:(HXSPostListType)type
                            topicId:(NSString *)topic_id
                             siteId:(NSString *)site_id
                              userId:(NSNumber *)userId
                               page:(NSNumber *)page
                            complete:(void (^)(HXSErrorCode, NSString *, NSArray *, NSString *))block {
    switch (type) {
        case HXSPostListTypeHot:  // 热门
        {
            [[self class]getCommunityHotPostsWithTopicId:topic_id siteId:site_id page:page complete:^(HXSErrorCode code, NSString *message, NSArray *posts, NSString *shareLink) {
                block(code,message,posts,shareLink);
            }];
        }
            break;
        case HXSPostListTypeRecommend: // 推荐
        {
             [[self class]getCommunityRecommendPostsWithTopicId:topic_id siteId:site_id page:page complete:^(HXSErrorCode code, NSString *message, NSArray *posts) {
                 block(code,message,posts,nil);
             }];
        }
            break;
        case HXSPostListTypeAll: // 全部
        {
            [[self class]getCommunityAllPostsWithTopicId:topic_id siteId:site_id page:page complete:^(HXSErrorCode code, NSString *message, NSArray *posts, NSString *shareLink) {
                block(code,message,posts,shareLink);
            }];
        }
            break;
        case HXSPostListTypeOther: //他人的帖子
        {
            [[self class] fetchCommuntiyUsersPostWithUserID:[userId stringValue] andPage:page andPageSize:@(PageNum) complete:^(HXSErrorCode code, NSString *message, NSArray *postsArray) {
                block(code, message, postsArray,nil);
            }];
        }
            break;
        default:
        {
            //关注的话题
           [[self class]getCommunityFollowPostsWithPage:page complete:^(HXSErrorCode code, NSString *message, NSArray *posts) {
               block(code,message,posts,nil);
           }];
        }
            break;
    }

}
// 获取帖子详情
+ (void)getCommunityPostDetialWithPostId:(NSString *)post_id complete:(void(^)(HXSErrorCode code, NSString * message, HXSPost * post))block{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:post_id forKey:@"post_id"];
    
    [HXStoreWebService getRequest:HXS_COMMUNITY_POST_DETIAL
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        DLog(@"------社区 获取帖子详情 %@",data);
        if(kHXSNoError == status){
            
            NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithDictionary:data[@"post"]];
            NSArray *commentArray = data[@"comment_list"];
            NSArray *likeArray = data[@"like_list"];
            
            [postDict setObject:commentArray forKey:@"comment_list"];
            [postDict setObject:likeArray forKey:@"like_list"];
            
            HXSPost *temp = [HXSPost objectFromJSONObject:postDict];

            block(status,msg,temp);
        }else{
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

+ (void)fetchCommuntiyUsersPostWithUserID:(NSString *)userId
                                  andPage:(NSNumber *)page
                              andPageSize:(NSNumber *)pageSize
                                 complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * postsArray))block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userId forKey:@"user_id"];
    [dic setObject:[page stringValue] forKey:@"page"];
    [dic setObject:[pageSize stringValue] forKey:@"page_size"];
    
    [HXStoreWebService getRequest:HXS_COMMUNITY_POST_USER
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status)
                       {
                           block(status, msg, nil);
                           return ;
                       }
                       NSMutableArray<HXSPost *> *array;
                       NSArray *dataArray = [data objectForKey:@"posts"];
                       for (NSDictionary *dic in dataArray)
                       {
                           if(!array)
                               array = [[NSMutableArray alloc]init];
                           HXSPost *entity = (HXSPost *)[HXSPost objectFromJSONObject:dic];
                           [array addObject:entity];
                       }
                       if(array)
                       {
                           block(status,msg,array);
                       }
                       else
                       {
                           block(status,msg,nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

+ (void)communityDeletePostWithPostId:(NSString *)post_id complete:(void(^)(HXSErrorCode code, NSString * message, NSNumber * result_status))block{
    
    NSDictionary *dic = @{@"post_id":post_id};
    
    [HXStoreWebService postRequest:HXS_COMMUNITY_POST_DELETE
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(kHXSNoError == status){
            NSNumber *resultStatus = [data objectForKey:@"result_status"];
            block(status,msg,resultStatus);
        }else{
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
 }



+ (void)getCommunityNewMsgComplete:(void(^)(HXSErrorCode code, NSString * message, NSDictionary * resultDict))block;
{
    [HXStoreWebService getRequest:HXS_COMMUNITY_MESSAGE_NEW
                 parameters:[NSDictionary new]
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       
                        if (status == kHXSNoError)
                        {
                            block(status,msg,data);
                        }
                        
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status,msg,nil);
                   
                   }];
}


@end

//
//  HXSCommunityTagModel.m
//  store
//
//  Created by 格格 on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityTagModel.h"
#import "HXSPost.h"

@implementation HXSCommunityTagModel

// 点赞
+(void)communityAddLikeWithPostId:(NSString *)post_id complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block{
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:post_id forKey:@"post_id"];
    
    [HXStoreWebService postRequest:HXS_COMMUNITY_LIKE_ADD
                 parameters:diction
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];
}

+ (void)communityAddShareWithPostId:(NSString *)post_id
                           complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block
{
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:post_id forKey:@"post_id"];
    
    [HXStoreWebService postRequest:HXS_COMMUNITY_SHARE_ADD
                 parameters:diction
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        
                        block(status,msg,data);
                        
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status,msg,data);
                    }];
}

// 评论帖子
+(void)communityAddCommentWithPostId:(NSString *)post_id content:(NSString *)content complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary*dic))block{
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:post_id forKey:@"post_id"];
    [diction setObject:content forKey:@"content"];
    
    [HXStoreWebService postRequest:HXS_COMMUNITY_COMMENT_ADD
                 parameters:diction
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];
}

+(void)communityAddCommentWithPostId:(NSString *)post_id
                             content:(NSString *)content
                     commentedUserId:(NSNumber *)commentedUserId
                    commentedContent:(NSString *)commentedContent
                            complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block
{
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:post_id forKey:@"post_id"];
    [diction setObject:content forKey:@"content"];
    [diction setObject:commentedUserId forKey:@"commented_user_id"];
    [diction setObject:commentedContent forKey:@"commented_content"];
    
    [HXStoreWebService postRequest:HXS_COMMUNITY_COMMENT_ADD
                 parameters:diction
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];

}








// 获取评论列表
+(void)getCommunityCommentListWithPostId:(NSString *)post_id page:(NSNumber *)page complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *comments))block{
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:post_id forKey:@"post_id"];
    [diction setObject:page forKey:@"page"];
    [diction setObject:@(20) forKey:@"page_size"];
    
    [HXStoreWebService getRequest:HXS_COMMUNITY_COMMENT_LIST
                parameters:diction
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        if(kHXSNoError == status){
            
            DLog(@"社区-评论列表：%@",data);
            NSMutableArray *resultArray = [NSMutableArray array];
            NSArray *arr = [data objectForKey:@"comment_list"];
            if(arr){
                for(NSDictionary *dic in arr){
                    
                    HXSComment *temp = [HXSComment objectFromJSONObject:dic];
                    [resultArray addObject:temp];
                }
            }
            block(status,msg,resultArray);
        
        }else{
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
    }];
}

@end

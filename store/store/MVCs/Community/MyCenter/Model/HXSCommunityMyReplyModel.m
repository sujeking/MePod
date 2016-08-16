//
//  HXSCommunityMyReplyModel.m
//  store
//
//  Created by J006 on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityMyReplyModel.h"

@implementation HXSCommunityMyReplyModel

- (void)fetchMyRepliesWithPageSize:(NSNumber *)pageSizeNum
              andWithLastCommentID:(NSString *)lastCommentID
                          Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXSCommunityCommentEntity *> *entityArray))block
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[pageSizeNum stringValue] forKey:@"page_size"];
    if(lastCommentID)
    {
        [dic setObject:lastCommentID forKey:@"last_comment_id"];
    }
    
    [HXStoreWebService getRequest:HXS_COMMUNITY_MYCOMMENTS
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status)
                       {
                           block(status, msg, nil);
                           return ;
                       }
                       NSMutableArray<HXSCommunityCommentEntity *> *array;
                       NSArray *dataArray = [data objectForKey:@"comments"];
                       for (NSDictionary *dic in dataArray)
                       {
                           if(!array)
                               array = [[NSMutableArray alloc]init];
                           HXSCommunityCommentEntity *entity = [self createCommunitCommentsEntityEntityWithData:dic];
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

- (void)deleteTheCommentWithCommentId:(NSString *)commentID
                            andPostId:(NSString *)postID
                             Complete:(void (^)(HXSErrorCode code, NSString *message, NSString *statusStr))block;
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:commentID forKey:@"comment_id"];
    [dic setObject:postID forKey:@"post_id"];
    [HXStoreWebService postRequest:HXS_COMMUNITY_DELCOMMENT
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status)
                       {
                           block(status, msg, nil);
                           return ;
                       }
                       NSNumber *statusNum = [data objectForKey:@"result_status"];
                       if(statusNum)
                       {
                           block(status,msg,[statusNum stringValue]);
                       }
                       else
                       {
                           block(status,msg,nil);
                       }
                       
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

- (void)fetchRepliesForMeWithPageSize:(NSNumber *)pageSizeNum
                 andWithLastCommentID:(NSString *)lastCommentID
                             Complete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXSCommunityCommentEntity *> *entityArray))block
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[pageSizeNum stringValue] forKey:@"page_size"];
    if(lastCommentID)
    {
        [dic setObject:lastCommentID forKey:@"last_comment_id"];
    }
    
    [HXStoreWebService getRequest:HXS_COMMUNITY_COMMENTSFORME
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status)
                       {
                           block(status, msg, nil);
                           return ;
                       }
                       NSMutableArray<HXSCommunityCommentEntity *> *array;
                       NSArray *dataArray = [data objectForKey:@"comments"];
                       for (NSDictionary *dic in dataArray)
                       {
                           if(!array)
                               array = [[NSMutableArray alloc]init];
                           HXSCommunityCommentEntity *entity = [self createCommunitCommentsEntityEntityWithData:dic];
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

#pragma mark private methords

- (HXSCommunityCommentEntity *)createCommunitCommentsEntityEntityWithData:(NSDictionary *)dic
{
    HXSCommunityCommentEntity *entity = [[HXSCommunityCommentEntity alloc] initWithDictionary:dic error:nil];
    
    if (nil != entity)
    {
        if(entity.postOwner)
        {
            entity.postOwner.userType = kHXSCommunityCommentUserTypeOwner;
        }
        if(entity.commentUser)
        {
            entity.commentUser.userType = kHXSCommunityCommentUserTypeCommenter;
        }
        if(entity.commentedUser)
        {
            entity.commentedUser.userType = kHXSCommunityCommentUserTypeCommented;
        }
    }
    
    return entity;
}

@end

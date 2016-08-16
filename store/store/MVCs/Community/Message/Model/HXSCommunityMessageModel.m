//
//  HXSCommunityMessageModel.m
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityMessageModel.h"

@implementation HXSCommunityMessageModel

+(void)getCommunityUserMessageWithLastMessageId:(NSString *)last_message_id
                                           page:(NSNumber *)page
                                       complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * messages))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:last_message_id forKey:@"last_message_id"];
    [dic setObject:page forKey:@"page"];
    [dic setObject:@(20) forKey:@"page_size"];
    
    [HXStoreWebService getRequest:HXS_COMMUNITY_USER_MESSAGE
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        if(kHXSNoError == status ){
            DLog(@"社区----用户收到的消息列表")
            NSMutableArray *resultArray= [NSMutableArray array];
            NSArray *arr = [data objectForKey:@"messages"];
            if(arr){
                for(NSDictionary *dic in arr){
                    HXSCommunityMessage *temp = [HXSCommunityMessage objectFromJSONObject:dic];
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


+(void)readCommunityUserMessageWithLastMessageId:(NSString *)last_message_id
                                        complete:(void (^)(HXSErrorCode, NSString *, NSDictionary *))block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:last_message_id forKey:@"message_id"];
    
    [HXStoreWebService postRequest:HXS_COMMUNITY_USER_MESSAGE_READ
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        if(kHXSNoError == status ){
            block(status,msg,data);
        }else{
            block(status,msg,nil);
        }

        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
         block(status,msg,nil);
    }];
 
}


@end

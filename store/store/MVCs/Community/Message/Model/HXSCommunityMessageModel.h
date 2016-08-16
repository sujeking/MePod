//
//  HXSCommunityMessageModel.h
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSCommunityMessage.h"

@interface HXSCommunityMessageModel : NSObject

/**
 *  获取用户收到的消息列表
 *
 *  @param last_message_id 最后一条消息id //可选:分页时,若传last_message_id,page可不传 否则page需传
 *  @param page
 *  @param block
 */
+(void)getCommunityUserMessageWithLastMessageId:(NSString *)last_message_id
                                           page:(NSNumber *)page
                                       complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * messages))block;

//确认消息已读
+(void)readCommunityUserMessageWithLastMessageId:(NSString *)last_message_id
                                       complete:(void(^)(HXSErrorCode code, NSString * message, NSDictionary *resultDict))block;


@end

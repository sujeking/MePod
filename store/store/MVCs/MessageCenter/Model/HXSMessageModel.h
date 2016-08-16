//
//  HXSMessageModel.h
//  store
//
//  Created by ArthurWang on 15/7/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

// status
#define MESSAGE_STATUS_UNREADED        0
#define MESSAGE_STATUS_READED          1
#define MESSAGE_STATUS_DELETED         2

@interface HXSMessageModel : NSObject

@property (nonatomic, strong) NSNumber *readedTotalCountNumer;
@property (nonatomic, strong) NSNumber *unreadedtotalCountNumer;


#pragma mark - Public Methods

- (void)fetchNewMessageWithStatus:(BOOL)hasReaded
                         complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *messageInfo))block;

- (void)loadMoreMessageWithStatus:(BOOL)hasReaded
                         complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *messageInfo))block;

- (void)updateMessageStatusWithMessageID:(NSString *)messageIDStr
                                complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *messageInfo))block;

- (void)deleteMessageWithMessageID:(NSString *)messageIDStr
                          complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *messageInfo))block;

- (void)readAllMessages:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *messageInfo))block;

// unread mesage

+ (void)fetchUnreadMessage;

@end

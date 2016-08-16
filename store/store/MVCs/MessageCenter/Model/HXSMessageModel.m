//
//  HXSMessageModel.m
//  store
//
//  Created by ArthurWang on 15/7/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSMessageModel.h"

#import "HXSMessage.h"
#import "HXSMessageAction.h"

// list
#define KEY_LIST_TOKEN          @"token"
#define KEY_LIST_MESSAGE_STATUS @"message_status"
#define KEY_LIST_NUM_PER_PAGE   @"num_per_page"
#define KEY_LIST_PAGE           @"page"

// read
#define KEY_READ_MESSAGE_ID    @"message_id"

// delete
#define KEY_DELETE_MESSAGE_ID  @"message_id"

#define NUMBER_PER_PAGE    10


@interface HXSMessageModel ()

@property (nonatomic, assign) int readedPage;
@property (nonatomic, assign) int totoalReadedPage;
@property (nonatomic, assign) int unreadedPage;
@property (nonatomic, assign) int totoalUnreadedPage;


@end


@implementation HXSMessageModel


#pragma mark - Public Methods

- (void)fetchNewMessageWithStatus:(BOOL)hasReaded
                         complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *messageInfo))block
{
    NSNumber *pageNum = nil;
    
    if (hasReaded) {
        self.readedPage = 1;
        pageNum = [NSNumber numberWithInt:self.readedPage];
    } else {
        self.unreadedPage = 1;
        pageNum = [NSNumber numberWithInt:self.unreadedPage];
    }
    
    [self fetchMessageWithStatus:hasReaded
                            page:pageNum
                       isRefresh:YES
                        complete:block];
    
}

- (void)loadMoreMessageWithStatus:(BOOL)hasReaded
                         complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *messageInfo))block
{
    NSNumber *pageNum = nil;
    
    if (hasReaded) {
        self.readedPage++;
        if (self.readedPage > self.totoalReadedPage) {
            self.readedPage = self.totoalReadedPage;
            block(kHXSNoError, nil, nil);
            return;
        }
        pageNum = [NSNumber numberWithInt:self.readedPage];
    } else {
        self.unreadedPage++;
        if (self.unreadedPage > self.totoalUnreadedPage) {
            self.unreadedPage = self.totoalUnreadedPage;
            block(kHXSNoError, nil, nil);
            return;
        }
        pageNum = [NSNumber numberWithInt:self.unreadedPage];
    }
    
    [self fetchMessageWithStatus:hasReaded
                            page:pageNum
                       isRefresh:NO
                        complete:block];
}

- (void)updateMessageStatusWithMessageID:(NSString *)messageIDStr
                                complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *messageInfo))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObject:messageIDStr forKey:KEY_READ_MESSAGE_ID];
    
    [HXStoreWebService postRequest:HXS_USER_MESSAGE_READ
                 parameters:paramDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (status == kHXSNoError) {
                            block(kHXSNoError, msg, data);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
    
    
}

- (void)deleteMessageWithMessageID:(NSString *)messageIDStr
                          complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *messageInfo))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObject:messageIDStr forKey:KEY_READ_MESSAGE_ID];
    
    [HXStoreWebService postRequest:HXS_USER_MESSAGE_DELETE
                 parameters:paramDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (status == kHXSNoError) {
                            block(kHXSNoError, msg, data);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}


#pragma mark - Private Methods

- (void)fetchMessageWithStatus:(BOOL)hasReaded
                          page:(NSNumber *)pageNum
                     isRefresh:(BOOL)isRefresh
                      complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *messageInfo))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:(hasReaded ? MESSAGE_STATUS_READED : MESSAGE_STATUS_UNREADED)], KEY_LIST_MESSAGE_STATUS,
                              [NSNumber numberWithInt:NUMBER_PER_PAGE], KEY_LIST_NUM_PER_PAGE,
                              pageNum, KEY_LIST_PAGE, nil];
    
    [HXStoreWebService getRequest:HXS_USER_MESSAGE_LIST
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (status == kHXSNoError) {
                           [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                               if (isRefresh) {
                                   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %d", hasReaded ? MESSAGE_STATUS_READED : MESSAGE_STATUS_UNREADED];
                                   [HXSMessage MR_deleteAllMatchingPredicate:predicate];
                               }
                               
                               NSArray *messageArr = [data objectForKey:@"list"];
                               if (![messageArr isKindOfClass:[NSArray class]]) {
                                   messageArr = nil;
                               }
                               [HXSMessage MR_importFromArray:messageArr];
                               
                               // update totoal pages
                               int totalPage = [[data objectForKey:@"total_pages"] intValue];
                               if (hasReaded) {
                                   self.totoalReadedPage = totalPage;
                                   self.readedTotalCountNumer = [data objectForKey:@"total_count"];
                               } else {
                                   self.totoalUnreadedPage = totalPage;
                                   self.unreadedtotalCountNumer = [data objectForKey:@"total_count"];
                               }
                           }];
                           
                           NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %d", hasReaded ? MESSAGE_STATUS_READED : MESSAGE_STATUS_UNREADED];
                           NSArray *messageArr = [HXSMessage MR_findAllSortedBy:@"createTime" ascending:NO withPredicate:predicate];
                           
                           block(kHXSNoError, msg, messageArr);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

- (void)readAllMessages:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *messageInfo))block
{
    NSDictionary *paramDic = [[NSDictionary alloc] init];
    
    [HXStoreWebService postRequest:HXS_USER_MESSAGE_READ_ALL
                 parameters:paramDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, data);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, data);
                    }];
}



// unread message

+ (void)fetchUnreadMessage
{
    NSDictionary *paramDic = [[NSDictionary alloc] init];
    
    [HXStoreWebService getRequest:HXS_USER_MESSAGE_UNREAD_NUM
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError == status) {
                           NSNumber *unreadNum = [data objectForKey:@"message_num"];
                           
                           if ((nil != unreadNum)
                               && [unreadNum isKindOfClass:[NSNumber class]]) {
                               [[NSUserDefaults standardUserDefaults] setObject:unreadNum
                                                                         forKey:USER_DEFAULT_UNREAD_MESSGE_NUMBER];
                               [[NSUserDefaults standardUserDefaults] synchronize];
                               
                               [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessagehasUpdated
                                                                                   object:nil];
                           }
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       // Do nothing
                   }];
}







@end

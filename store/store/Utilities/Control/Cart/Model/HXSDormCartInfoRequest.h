//
//  HXSDormCartInfoRequest.h
//  store
//
//  Created by chsasaw on 14/11/29.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HXSDormCartInfoRequest : NSObject

@property (nonatomic, strong) NSNumber * sessionId;

- (void)getCartInfoWithToken:(NSString *)token
                     shop_id:(NSNumber *)shopIDIntNum
                    complete:(void (^)(HXSDormCartInfoRequest *req, HXSErrorCode code, NSString * message, NSDictionary * cartInfo))block;

- (void)getCartBriefWithToken:(NSString *)token
                      shop_id:(NSNumber *)shopId
                     complete:(void (^)(HXSDormCartInfoRequest *req, HXSErrorCode code, NSString * message, NSDictionary * cartInfo))block;

- (void)addItemWithToken:(NSString *)token
                 shop_id:(NSNumber *)shopIDIntNum
                     rid:(NSNumber *)rid
                quantity:(int)quantity
                complete:(void (^)(HXSDormCartInfoRequest *req, HXSErrorCode code, NSString * message, NSDictionary * cartInfo))block;

- (void)updateInfoWithToken:(NSString *)token
               shop_id:(NSNumber *)shopIDIntNum
                     itemId:(NSNumber *)itemId
                   quantity:(int)quantity
                   complete:(void (^)(HXSDormCartInfoRequest *req, HXSErrorCode code, NSString * message, NSDictionary * cartInfo))block;

- (void)clearCartWithToken:(NSString *)token
              shop_id:(NSNumber *)shopIDIntNum
                  complete:(void (^)(HXSDormCartInfoRequest *req, HXSErrorCode code, NSString * message, NSDictionary * cartInfo))block;

@end
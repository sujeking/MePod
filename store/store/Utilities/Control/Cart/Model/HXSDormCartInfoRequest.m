//
//  HXSDormCartInfoRequest.m
//  store
//
//  Created by chsasaw on 14/11/29.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSDormCartInfoRequest.h"

@implementation HXSDormCartInfoRequest

- (void)getCartInfoWithToken:(NSString *)token
                     shop_id:(NSNumber *)shopIDIntNum
                    complete:(void (^)(HXSDormCartInfoRequest *req, HXSErrorCode, NSString *, NSDictionary *))block
{
    if (token == nil || shopIDIntNum == nil)
    {
        block(self, kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:shopIDIntNum forKey:@"shop_id"];
    
    [self get:HXS_NIGHT_CAT_CART_INFO parameters:dic complete:block];
}

- (void)getCartBriefWithToken:(NSString *)token
                 shop_id:(NSNumber *)shopId
                     complete:(void (^)(HXSDormCartInfoRequest *req, HXSErrorCode, NSString *, NSDictionary *))block
{
    if (token == nil || shopId == nil)
    {
        block(self, kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:shopId forKey:@"shop_id"];
    
    [self get:HXS_NIGHT_CAT_CART_BRIEF parameters:dic complete:block];
}

- (void)addItemWithToken:(NSString *)token
                 shop_id:(NSNumber *)shopIDIntNum
                     rid:(NSNumber *)rid
                quantity:(int)quantity
                complete:(void (^)(HXSDormCartInfoRequest *, HXSErrorCode, NSString *, NSDictionary *))block
{
    if (token == nil || shopIDIntNum == nil)
    {
        block(self, kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    if(rid != nil) {
        [dic setObject:rid forKey:@"rid"];
    }
    [dic setObject:[NSNumber numberWithInt:quantity] forKey:@"quantity"];
    [dic setObject:shopIDIntNum forKey:@"shop_id"];
    
    [self post:HXS_NIGHT_CAT_CART_ADD parameters:dic complete:block];
}

- (void)updateInfoWithToken:(NSString *)token
                    shop_id:(NSNumber *)shopIDIntNum
                     itemId:(NSNumber *)itemId
                   quantity:(int)quantity
                   complete:(void (^)(HXSDormCartInfoRequest *req, HXSErrorCode, NSString *, NSDictionary *))block
{
    if (token == nil || itemId == nil || quantity < 0 || shopIDIntNum == nil)
    {
        block(self, kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    if(itemId != nil) {
        [dic setObject:itemId forKey:@"item_id"];
    }
    [dic setObject:[NSNumber numberWithInt:quantity] forKey:@"quantity"];
    [dic setObject:shopIDIntNum forKey:@"shop_id"];

    [self post:HXS_NIGHT_CAT_CART_UPDATE parameters:dic complete:block];
}

- (void)clearCartWithToken:(NSString *)token
              shop_id:(NSNumber *)shopIDIntNum
                  complete:(void (^)(HXSDormCartInfoRequest *req, HXSErrorCode, NSString *, NSDictionary *))block
{
    if (token == nil || shopIDIntNum == nil)
    {
        block(self, kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:shopIDIntNum forKey:@"shop_id"];
    
    [self post:HXS_NIGHT_CAT_CART_CLEAR parameters:dic complete:block];
}

- (void)get:(NSString *)strUrl parameters:(NSDictionary *)parameters complete:(void (^)(HXSDormCartInfoRequest *req, HXSErrorCode, NSString *, NSDictionary *))block
{
    [HXStoreWebService getRequest:strUrl
                parameters:parameters
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           block(self, kHXSNoError, msg, data);
                       }else {
                           block(self, status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(self, status, msg, nil);
                   }];
}

- (void)post:(NSString *)strUrl parameters:(NSDictionary *)parameters complete:(void (^)(HXSDormCartInfoRequest *req, HXSErrorCode, NSString *, NSDictionary *))block
{
    [HXStoreWebService postRequest:strUrl
                 parameters:parameters
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == kHXSNoError) {
                            block(self, kHXSNoError, msg, data);
                        }else {
                            block(self, status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(self, status, msg, nil);
                    }];
    
}

@end
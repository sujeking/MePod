//
//  HXSDormItemsRequest.m
//  store
//
//  Created by chsasaw on 15/2/6.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSDormItemsRequest.h"
#import "HXSDormCategory.h"
#import "HXSDormItem.h"

@interface HXSDormItemsRequest ()

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation HXSDormItemsRequest

- (void)getDormItemListWithToken:(NSString *)token
                          shopId:(NSNumber *)shopIDIntNum
                        complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * items))block
{
    if (token == nil || shopIDIntNum == nil) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:shopIDIntNum forKey:@"shop_id"];
    
    self.task = [HXStoreWebService getRequest:HXS_NIGHT_CAT_ITEMS
                            parameters:dic
                              progress:nil
                               success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           NSMutableArray * cates = [NSMutableArray array];
                           if(DIC_HAS_ARRAY(data, @"categories")) {
                               for(NSDictionary * dic in [data objectForKey:@"categories"]) {
                                   if((NSNull *)dic == [NSNull null]) {
                                       continue;
                                   }
                                   NSArray *goodsItemsArray = dic[@"items"];
                                   
                                   for (NSDictionary *goodItemDict in goodsItemsArray) {
                                       HXSDormItem *item = [[HXSDormItem alloc] initWithDictionary:goodItemDict];
                                       if (item) {
                                           [cates addObject:item];
                                       }
                                   }
                                   
                               }
                           }
                           
                           block(kHXSNoError, msg, cates);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

- (void)fetchGoodsCategoryListWith:(NSNumber *)categoryId
                            shopId:(NSNumber *)shopId
                      categoryType:(NSNumber *)type
                          starPage:(NSNumber *)page
                        numPerPage:(NSNumber *)num_per_page
                          complete:(void (^)(HXSErrorCode, NSString *, NSArray *))block
{
    if (nil == categoryId) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:categoryId   forKey:@"category_id"];
    [dict setValue:shopId       forKey:@"shop_id"];
    [dict setValue:page         forKey:@"page"];
    [dict setValue:num_per_page forKey:@"num_per_page"];
    [dict setValue:type         forKey:@"category_type"];
    
    [HXStoreWebService getRequest:HXS_SHOP_ITEMS
                parameters:dict
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {

                    if(status == kHXSNoError) {
                        
                        NSMutableArray * cates = [NSMutableArray array];
                        if(DIC_HAS_ARRAY(data, @"items")) {
                            for(NSDictionary * dic in [data objectForKey:@"items"]) {
                                if((NSNull *)dic == [NSNull null]) {
                                    continue;
                                }
                                HXSDormItem * item = [[HXSDormItem alloc] initWithDictionary:dic];
                                if(item) {
                                    [cates addObject:item];
                                }
                            }
                        }
                        
                        block(kHXSNoError, msg, cates);
        
                    }}
                   failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
    }];
}

- (void)cancel
{
    if (nil != self.task) {
        [self.task cancel];
        
        self.task = nil;
    }
}

@end

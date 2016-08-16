//
//  HXSRecommendedGamesRequest.m
//  store
//
//  Created by ranliang on 15/6/29.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSRecommendedGamesRequest.h"
#import "HXSRecommendedApp.h"

@implementation HXSRecommendedGamesRequest

- (void)requestWithToken:(NSString *)token
           completeBlock:(void (^)(HXSErrorCode, NSString *, NSArray *))block
{
    if (token == nil)
    {
        block(kHXSParamError, @"token不存在", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@0 forKey:SYNC_DEVICE_TYPE];
    
    [HXStoreWebService getRequest:HXS_RECOMMENDED_GAMES
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (data[@"apps"]) {
                           NSMutableArray *mutableArray = [NSMutableArray array];
                           for (NSDictionary *dict in data[@"apps"]) {
                               HXSRecommendedApp *app = [[HXSRecommendedApp alloc] initWithDict:dict];
                               [mutableArray addObject:app];
                           }
                            block(kHXSNoError, msg, mutableArray);
                       } else {
                            block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

@end

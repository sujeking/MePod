//
//  HXSLaunchAdRequest.m
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSLaunchAdRequest.h"

@implementation HXSLaunchAdRequest

- (void)requestWithCityID:(NSNumber *)cityIDIntNum
                   siteID:(NSNumber *)siteIDIntNum
            completeBlock:(void (^)(HXSErrorCode errorcode, NSString * msg, NSDictionary * data))block
{
    NSDictionary *dic = @{@"city_id": cityIDIntNum,
                          @"site_id": siteIDIntNum,
                          };
    
    [HXStoreWebService getRequest:HXS_LAUNCHAD_INFO
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(kHXSNoError, msg, data);
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
    
}

@end

//
//  HXSRecommendedGamesRequest.h
//  store
//
//  Created by ranliang on 15/6/29.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXStoreWebService.h"

@interface HXSRecommendedGamesRequest : NSObject

- (void)requestWithToken:(NSString *)token
           completeBlock:(void (^)(HXSErrorCode errorcode, NSString * msg, NSArray* data))block;

@end

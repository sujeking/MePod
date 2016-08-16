//
//  HXSUpdateTokenRequest.h
//  store
//
//  Created by chsasaw on 14/10/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXStoreWebServiceErrorCode.h"

@interface HXSUpdateTokenRequest : NSObject

+ (HXSUpdateTokenRequest *) currentRequest;

- (void)startUpdateTokenWithDeviceId:(NSString *)deviceId
                              siteId:(NSNumber *)siteId
                              userId:(NSNumber *)userId
                            complete:(void (^)(HXSErrorCode errorcode, NSString * msg, NSString * token))block;

@end
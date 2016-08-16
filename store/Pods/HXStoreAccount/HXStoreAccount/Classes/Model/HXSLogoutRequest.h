//
//  HXSLogoutRequest.h
//  store
//
//  Created by chsasaw on 14/10/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSLogoutRequest : NSObject

- (void)startRequest:(NSNumber *)userID token:(NSString *)token;

@end
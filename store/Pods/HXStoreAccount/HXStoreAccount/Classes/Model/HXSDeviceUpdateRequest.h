//
//  HXSDeviceUpdateRequest.h
//  store
//
//  Created by chsasaw on 14/11/21.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSDeviceUpdateRequest : NSObject

+ (HXSDeviceUpdateRequest *) currentRequest;

- (void)setDeviceToken:(NSString *)deviceToken;
- (void)setGetuiPushId:(NSString *)getuiPushId;

- (void)startUpdate;

@end
//
//  HXSGexinSdkManager.h
//  store
//
//  Created by chsasaw on 14/10/24.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GeTuiSdk.h"


@interface HXSGexinSdkManager : NSObject<GeTuiSdkDelegate>

+ (HXSGexinSdkManager *)sharedInstance;

@property (copy, nonatomic) NSString *appKey;
@property (copy, nonatomic) NSString *appSecret;
@property (copy, nonatomic) NSString *appID;
@property (copy, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;

@property (assign, nonatomic) int lastPayloadIndex;

- (void)startSdk;
- (void)stopSdk;

- (void)setDeviceToken:(NSString *)aToken data:(NSData *)deviceData;
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

- (void)setAlias:(NSString *)alias;

@end

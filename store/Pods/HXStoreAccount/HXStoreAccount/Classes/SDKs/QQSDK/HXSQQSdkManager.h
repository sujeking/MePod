//
//  HXSQQSdkManager.h
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXMacrosEnum.h"
#import "HXSAccountManager.h"

typedef void (^HXSShareCallbackBlock)(HXSShareResult shareResult, NSString * msg);

@interface HXSQQSdkManager : NSObject

@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSDate   *expirationDate;

@property (assign) id <HXSThirdAccountDelegate> delegate;
@property (nonatomic, copy) HXSShareCallbackBlock shareCallBack;

+ (HXSQQSdkManager *) sharedManager;

- (BOOL)handleOpenURL:(NSURL *)url;

- (BOOL)isQQInstalled;
- (BOOL)isLoggedIn;
- (void)logIn;
- (void)logOut;

// Share To QQ
- (void)shareToQQWithTitle:(NSString *)title text:(NSString *)text image:(NSString *)imageUrl url:(NSString *)url callback:(HXSShareCallbackBlock)callback;
- (void)shareToZoneWithTitle:(NSString *)title text:(NSString *)text image:(NSString *)imageUrl url:(NSString *)url callback:(HXSShareCallbackBlock)callback;

@end
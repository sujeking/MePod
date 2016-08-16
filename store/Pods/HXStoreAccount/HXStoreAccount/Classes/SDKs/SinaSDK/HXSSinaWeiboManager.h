//
//  HXSSinaWeiboManager.h
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

#import "HXMacrosEnum.h"
#import "HXSAccountManager.h"

typedef void (^HXSShareCallbackBlock)(HXSShareResult shareResult, NSString * msg);

@interface HXSSinaWeiboManager : NSObject<WeiboSDKDelegate, WBHttpRequestDelegate>

@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSDate   *expirationDate;

@property (assign) id <HXSThirdAccountDelegate> delegate;
@property (nonatomic, copy) HXSShareCallbackBlock shareCallBack;

+ (HXSSinaWeiboManager *) sharedManager;

- (BOOL)handleOpenURL:(NSURL *)url;

- (BOOL)isLoggedIn;
- (void)logIn;
- (void)logOut;

- (void)shareToWeiboWithText:(NSString *)text image:(UIImage *)image callback:(HXSShareCallbackBlock)callBack;

@end

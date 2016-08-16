//
//  HXSRenrenManager.h
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RennSDK/RennSDK.h>

#import "HXMacrosEnum.h"

@protocol HXSThirdAccountDelegate <NSObject>

@optional

- (void) thirdAccountDidLogin:(HXSAccountType)type;
- (void) thirdAccountDidLogout:(HXSAccountType)type;
- (void) thirdAccountLoginCancelled:(HXSAccountType)type;
- (void) thirdAccountLoginFailed:(HXSAccountType)type;
- (void) thirdAccountTokenInvalid:(HXSAccountType)type;

@end

@interface HXSRenrenManager : NSObject<RennLoginDelegate>

@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *userID;

@property (nonatomic, weak) id<HXSThirdAccountDelegate> delegate;

+ (HXSRenrenManager *) sharedManager;

- (BOOL)handleOpenURL:(NSURL *)url;

- (BOOL)isLoggedIn;
- (void)logIn;
- (void)logOut;

@end
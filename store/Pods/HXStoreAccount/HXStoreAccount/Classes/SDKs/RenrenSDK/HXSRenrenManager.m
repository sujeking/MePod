//
//  HXSRenrenManager.m
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSRenrenManager.h"

#import "HXMacrosUtils.h"

//renren
#define kRennAppid      @"209521"
#define kRennApiKey     @"3536c3f7e9684a929305fa8135fd2f02"
#define kRennAppSecret  @"3f6a2141373e4aa1a5975cc91f942721"

static HXSRenrenManager * renren_instance = nil;

@implementation HXSRenrenManager

+ (HXSRenrenManager *) sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (renren_instance == nil) renren_instance = [[HXSRenrenManager alloc] init];
    });
    return renren_instance;
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        [RennClient initWithAppId:kRennAppid apiKey:kRennApiKey secretKey:kRennAppSecret];
        [RennClient setScope:@"read_user_blog read_user_photo read_user_status read_user_album read_user_comment read_user_share publish_blog publish_share send_notification photo_upload status_update create_album publish_comment publish_feed operate_like"];
    }
    
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [RennClient  handleOpenURL:url];
}

- (BOOL)isLoggedIn {
    return [RennClient isLogin];
}

- (void)logIn {
    [RennClient loginWithDelegate:self];
}

- (void)logOut {
    [RennClient logoutWithDelegate:nil];
}

#pragma mark - delegate
- (void)rennLoginSuccess
{
    DLog(@"登录成功");
    self.accessToken = [RennClient accessToken].accessToken;
    self.userID = [RennClient uid];
    if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountDidLogin:)]) {
        [self.delegate thirdAccountDidLogin:kHXSRenrenAccount];
    }
}

- (void)rennLogoutSuccess
{
    DLog(@"注销成功");
    self.accessToken = nil;
    if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountDidLogout:)]) {
        [self.delegate thirdAccountDidLogout:kHXSRenrenAccount];
    }
}

- (void)rennLoginCancelded {
    if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountLoginCancelled:)]) {
        [self.delegate thirdAccountLoginCancelled:kHXSRenrenAccount];
    }
}

- (void)rennLoginDidFailWithError:(NSError *)error {
    if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountLoginFailed:)]) {
        [self.delegate thirdAccountLoginFailed:kHXSRenrenAccount];
    }
}

- (void)rennLoginAccessTokenInvalidOrExpired:(NSError *)error {
    if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountTokenInvalid:)]) {
        [self.delegate thirdAccountTokenInvalid:kHXSRenrenAccount];
    }
}

@end

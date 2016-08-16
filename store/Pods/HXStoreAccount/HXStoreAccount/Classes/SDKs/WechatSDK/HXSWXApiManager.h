//
//  HXSWXApiManager.h
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

#import "HXMacrosEnum.h"
#import "HXSAccountManager.h"

typedef void (^HXSShareCallbackBlock)(HXSShareResult shareResult, NSString * msg);

typedef enum : NSInteger {
    HXSWechatPayStatusSuccess = 0,
    HXSWechatPayStatusFailed  = -1,
    HXSWechatPayStatusExit    = -2,
    
    HXSWechatPayStatusParamError = 100,
} HXSWechatPayStatus;

@class HXSOrderActivitInfo, HXSOrderInfo;

@protocol HXSWechatPayDelegate <NSObject>

@required
- (void)wechatPayCallBack:(HXSWechatPayStatus)status message:(NSString *)message result:(NSDictionary *)result;

@end

@interface HXSWXApiManager : NSObject<WXApiDelegate>

@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSDate   *expirationDate;
@property (copy, nonatomic) NSString *refresh_token;

@property (assign) id <HXSThirdAccountDelegate> delegate;
@property (nonatomic, assign) id<HXSWechatPayDelegate> wechatPayDelegate;
@property (nonatomic, copy) HXSShareCallbackBlock shareCallBack;

+ (HXSWXApiManager *) sharedManager;

- (BOOL)handleOpenURL:(NSURL *)url;

- (BOOL)isWechatInstalled;
- (BOOL)isLoggedIn;
- (void)logIn;
- (void)logOut;

- (void)shareAppToWeixinFriends:(BOOL)isTimeLine callback:(HXSShareCallbackBlock)callback;
- (void)shareToWeixinWithTitle:(NSString *)title text:(NSString *)text image:(UIImage *)image url:(NSString *)url timeLine:(BOOL)isTimeLine  callback:(HXSShareCallbackBlock)callback;

// box
- (void)shareAppToWeixinFriends:(BOOL)isTimeLine
               withActivityInfo:(HXSOrderActivitInfo *)shareInfoEntity
                          image:(UIImage *)image
                       callback:(HXSShareCallbackBlock)callback;
- (void)shareAppToWeixin:(BOOL)isTimeLine
        withActivityInfo:(HXSOrderActivitInfo *)shareInfo
                   image:(UIImage *)image
                callback:(HXSShareCallbackBlock)callback;

// pay
- (void)wechatPay:(HXSOrderInfo *)orderInfo delegate:(id)delegate;

@end
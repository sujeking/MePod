//
//  HXSDeviceUpdateRequest.m
//  store
//
//  Created by chsasaw on 14/11/21.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSDeviceUpdateRequest.h"

#import "HXMacrosDefault.h"
#import "HXAppDeviceHelper.h"
#import "HXSUserAccount.h"
#import "HXStoreWebService.h"

#define UPDATE_DEVICE_TOKEN         @"device_token"
#define UPDATE_GETUI_PUSH_ID        @"getui_pushid"

@implementation HXSDeviceUpdateRequest

static HXSDeviceUpdateRequest * device_update_instance = nil;

+ (HXSDeviceUpdateRequest *)currentRequest
{
    @synchronized (self)
    {
        if (device_update_instance == nil)
        {
            device_update_instance = [[HXSDeviceUpdateRequest alloc] init];
        }
    }
    
    return device_update_instance;
}

- (id)init
{
    if(self = [super init]) {
        if(![[NSUserDefaults standardUserDefaults] objectForKey:UPDATE_DEVICE_FINISHED]) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UPDATE_DEVICE_FINISHED];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    return self;
}

- (void)setDeviceToken:(NSString *)deviceToken
{
    //先保存在本地，获取所有信息后调用startUpdate
    NSString *currentToken = [[NSUserDefaults standardUserDefaults] objectForKey:UPDATE_DEVICE_TOKEN];
    BOOL updateFinish = [[NSUserDefaults standardUserDefaults] boolForKey:UPDATE_DEVICE_FINISHED];
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:UPDATE_DEVICE_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(currentToken == nil || ![currentToken isEqualToString:deviceToken] || !updateFinish) {
        [self startUpdate];
    }
}

- (void)setGetuiPushId:(NSString *)getuiPushId
{
    //先保存在本地，获取所有信息后调用startUpdate
    NSString *currentPushId = [[NSUserDefaults standardUserDefaults] objectForKey:UPDATE_GETUI_PUSH_ID];
    BOOL updateFinish = [[NSUserDefaults standardUserDefaults] boolForKey:UPDATE_DEVICE_FINISHED];
    
    [[NSUserDefaults standardUserDefaults] setObject:getuiPushId forKey:UPDATE_GETUI_PUSH_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(currentPushId == nil || ![currentPushId isEqualToString:getuiPushId] || !updateFinish) {
        [self startUpdate];
    }
}

- (void)startUpdate
{
    //有可能调用多次
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UPDATE_DEVICE_FINISHED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doStartUpdate) object:nil];
    
    [self performSelector:@selector(doStartUpdate) withObject:nil afterDelay:2.0];
}

- (void)doStartUpdate
{
    NSString * deviceId = [HXAppDeviceHelper uniqueDeviceIdentifier];
    NSString * deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:UPDATE_DEVICE_TOKEN];
    NSString * getuiPushId = [[NSUserDefaults standardUserDefaults] objectForKey:UPDATE_GETUI_PUSH_ID];
    if (deviceId == nil || ![HXSUserAccount currentAccount].strToken)
    {
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:deviceId forKey:SYNC_DEVICE_ID];
    if (deviceToken != nil)
        [dic setObject:deviceToken forKey:SYNC_DEVICE_TOEKN];
    if (getuiPushId != nil)
        [dic setObject:getuiPushId forKey:@"getui_client_id"];
    [dic setObject:[NSNumber numberWithFloat:[HXAppDeviceHelper iosVersion]] forKey:SYNC_SYSTEM_VERSION];
    [dic setObject:[HXSUserAccount currentAccount].strToken forKey:@"token"];
    
    [HXStoreWebService postRequest:HXS_DEVICE_UPDATE
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == kHXSNoError) {
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UPDATE_DEVICE_FINISHED];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        // Do nothing
                    }];
}

@end
//
//  HXSSettingsModel.m
//  store
//
//  Created by ArthurWang on 15/8/14.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSSettingsModel.h"

@implementation HXSSettingsModel


#pragma mark - Public Methods

- (void)fetchReceivePushStatus:(NSString *)deviceIDStr
                      complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *pushStatusDic))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              deviceIDStr, @"device_id", nil];
    
    [HXStoreWebService postRequest:HXS_DEVICE_RECEIVE_PUSH_STATUS
                 parameters:paramDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (status == kHXSNoError) {
                            block(kHXSNoError, msg, data);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

- (void)updateReceivePushStatusWithDeviceID:(NSString *)deviceIDStr
                                     status:(NSNumber *)status
                                   complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *pushStatusDic))block
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              deviceIDStr, @"device_id",
                              status, @"receive_status", nil];
    
    [HXStoreWebService postRequest:HXS_DEVICE_RECEIVE_PUSH_UPDATE
                 parameters:paramDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (status == kHXSNoError) {
                            block(kHXSNoError, msg, data);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

@end

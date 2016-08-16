//
//  HXSSettingsModel.h
//  store
//
//  Created by ArthurWang on 15/8/14.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSSettingsModel : NSObject

- (void)fetchReceivePushStatus:(NSString *)deviceIDStr
                      complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *pushStatusDic))block;

- (void)updateReceivePushStatusWithDeviceID:(NSString *)deviceIDStr
                                     status:(NSNumber *)status
                                   complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *pushStatusDic))block;

@end

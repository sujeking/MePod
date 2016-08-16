//
//  HXSPayPasswordUpdateModel.h
//  store
//
//  Created by hudezhi on 15/8/6.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSPayPasswordUpdateModel : NSObject

@property(nonatomic) NSString *oldPasswd;
@property(nonatomic) NSString *passwd;

- (void)updatePayPassWord:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block;

// 免密支付修改
+ (void)updateExemptionStatus:(NSNumber *)status
                     password:(NSString *)passwordStr
                   completion:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *data))block;

@end

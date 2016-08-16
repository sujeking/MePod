//
//  HXSElemeConfirmOrderModel.h
//  store
//
//  Created by hudezhi on 15/8/29.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSElemeContactInfo.h"
#import "HXStoreWebService.h"

@interface HXSElemeConfirmOrderModel : NSObject

+ (void)getElemeContactInfo:(void (^)(HXSErrorCode code, NSString *message, HXSElemeContactInfo *contactInfo))completion;

+ (void)updateElemeContactInfo:(HXSElemeContactInfo *)info
                    completion:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *contactInfo))completion;

@end

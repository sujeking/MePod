//
//  HXSElemeConfirmOrderModel.m
//  store
//
//  Created by hudezhi on 15/8/29.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSElemeConfirmOrderModel.h"

#import "HXSMediator+LocationModule.h"
#import "HXStoreWebService.h"
#import "HXMacrosUtils.h"

@implementation HXSElemeConfirmOrderModel

+ (void)getElemeContactInfo:(void (^)(HXSErrorCode code, NSString *message, HXSElemeContactInfo *contactInfo))completion
{
    NSDictionary *paramDic = @{};
    
    NSNumber *siteIDIntNum = [[HXSMediator sharedInstance] HXSMediator_currentSiteID];
    if ([siteIDIntNum integerValue] > 0) {
        paramDic = @{@"site_id": siteIDIntNum};
    }
    
    [HXStoreWebService getRequest:HXS_ELEME_ADDRESS
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       DLog(@"--------------- HXS_ELEME_ADDRESS success: %@", data);
                       if (status == kHXSNoError) {
                           HXSElemeContactInfo *info = [[HXSElemeContactInfo alloc] initWithDictionary:data];
                           completion(status, msg, info);
                       } else {
                           completion(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       completion(status, msg, nil);
                   }];

}

+ (void)updateElemeContactInfo:(HXSElemeContactInfo *)info completion:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *contactInfo))completion
{
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              info.userName, @"user_name",
                              info.userPhone, @"user_phone",
                              info.userAddress, @"user_address",
                              @(info.siteId), @"site_id", nil];
    
    [HXStoreWebService postRequest:HXS_ELEME_ADDRESS_UPDATE
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       DLog(@"--------------- HXS_ELEME_ADDRESS success: %@", data);
                    completion(status, msg, nil);
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       completion(status, msg, nil);
                   }];
}

@end

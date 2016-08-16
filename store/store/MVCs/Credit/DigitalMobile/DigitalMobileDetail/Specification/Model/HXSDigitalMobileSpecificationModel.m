//
//  HXSDigitalMobileSpecificationModel.m
//  store
//
//  Created by ArthurWang on 16/3/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileSpecificationModel.h"

@implementation HXSDigitalMobileSpecificationModel

- (void)fetchItemParamWithItemID:(NSNumber *)itemIDIntNum
                        complete:(void (^)(HXSErrorCode status, NSString *message, HXSDigitalMobileSpecificationEntity *entity))block
{
    NSDictionary *parameterDic = @{@"item_id": itemIDIntNum};
    
    [HXStoreWebService getRequest:HXS_TIP_ITEM_PARAM
                parameters:parameterDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       HXSDigitalMobileSpecificationEntity *entity = [HXSDigitalMobileSpecificationEntity createSpecificationEntityWithDic:data];
                       
                       block(status, msg, entity);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

@end

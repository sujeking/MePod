//
//  HXSDigitalMobileParamModel.m
//  store
//
//  Created by ArthurWang on 16/3/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileParamModel.h"

@implementation HXSDigitalMobileParamModel

- (void)fetchItemAllSKUWithItemID:(NSNumber *)itemIDIntNum
                         complete:(void (^)(HXSErrorCode status, NSString *message, HXSDigitalMobileParamEntity *paramEntity))block
{
    NSDictionary *parameter = @{@"item_id":itemIDIntNum};
    
    [HXStoreWebService getRequest:HXS_TIP_ITEM_ALL_SKU
                parameters:parameter
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       HXSDigitalMobileParamEntity *entity = [HXSDigitalMobileParamEntity createDigitailMobileParamEntityWithDic:data];
                       
                       block(status, msg, entity);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

@end

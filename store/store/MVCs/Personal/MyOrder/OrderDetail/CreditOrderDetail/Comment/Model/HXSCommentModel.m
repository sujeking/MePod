//
//  HXSCommentModel.m
//  store
//
//  Created by 沈露萍 on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommentModel.h"

@implementation HXSCommentModel

- (void)postCommentWithOrderSn:(NSString *)orderSnStr
                    starsLevel:(NSNumber *)starsLevelIntNum
                       content:(NSString *)contentStr
                     productId:(NSString *)productIDIntNum
                      complete:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *data))block
{
    NSDictionary *paramDict = @{
                                @"score":           starsLevelIntNum,
                                @"content":         contentStr,
                                @"product_id":      productIDIntNum,
                                @"order_sn":        orderSnStr,
                                };
    
    [HXStoreWebService postRequest:HXS_TIP_SAVE_COMMENT
                 parameters:paramDict
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, data);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, data);
                    }];
    
}

@end

//
//  HXSCommentModel.h
//  store
//
//  Created by 沈露萍 on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCommentModel : NSObject

- (void)postCommentWithOrderSn:(NSString *)orderSnStr
                    starsLevel:(NSNumber *)starsLevelIntNum
                       content:(NSString *)contentStr
                     productId:(NSString *)productIDIntNum
                      complete:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *data))block;

@end

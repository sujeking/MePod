//
//  HXSMyOrderRequest.h
//  store
//
//  Created by chsasaw on 14/12/8.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSMyOrderRequest : NSObject

- (void)getMyOrderListWithToken:(NSString *)token
                           page:(int)page
                           type:(int)type
                       complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * orders)) block;





@end
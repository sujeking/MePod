//
//  HXSLaunchAdRequest.h
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HXSLaunchAdRequest : NSObject

- (void)requestWithCityID:(NSNumber *)cityIDIntNum
                   siteID:(NSNumber *)siteIDIntNum
            completeBlock:(void (^)(HXSErrorCode errorcode, NSString * msg, NSDictionary * data))block;

@end
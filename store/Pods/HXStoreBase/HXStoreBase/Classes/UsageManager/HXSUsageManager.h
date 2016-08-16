//
//  HXSUsageManager.h
//  store
//
//  Created by hudezhi on 15/9/11.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSUsageManager : NSObject

//+ (HXSUsageManager *)instance;

+ (void)trackEvent:(NSString *)eventID parameter:(NSDictionary *)param;

@end

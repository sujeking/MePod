//
//  HXSRecommendedApp.h
//  store
//
//  Created by ranliang on 15/6/29.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSRecommendedApp : NSObject

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

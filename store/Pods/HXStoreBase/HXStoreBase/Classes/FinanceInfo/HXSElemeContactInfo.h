//
//  HXSElemeContactInfo.h
//  store
//
//  Created by hudezhi on 15/8/29.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSElemeContactInfo : NSObject <NSCoding>

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *userAddress;
@property (nonatomic, assign) NSInteger siteId;
//@property (nonatomic, copy) NSString *siteName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

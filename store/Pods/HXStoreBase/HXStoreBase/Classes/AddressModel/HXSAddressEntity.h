//
//  HXSAddressEntity.h
//  store
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSAddressEntity : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSNumber *provinceId;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSNumber *cityId;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSNumber *countyId;
@property (strong, nonatomic) NSString *county;
@property (strong, nonatomic) NSNumber *townId;
@property (strong, nonatomic) NSString *town;
@property (strong, nonatomic) NSNumber *siteId;
@property (strong, nonatomic) NSString *site;
@property (strong, nonatomic) NSNumber *dormentryId;
@property (strong, nonatomic) NSString *dormentry;
@property (strong, nonatomic) NSString *dormitory;
@property (strong, nonatomic) NSString *postcode;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

- (NSMutableDictionary *)getDictionary;
- (NSString *)getAddressCode;
- (NSString *)getAddressName;
@end

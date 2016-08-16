//
//  HXSCity.h
//  store
//
//  Created by chsasaw on 14/10/28.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCity : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSNumber * city_id;
@property (nonatomic, copy) NSString * spell_short;
@property (nonatomic, copy) NSString * spell_all;

// 2.0 新增 
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic, copy) NSString * sectionTitle;//排序时使用 首字母

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)encodeAsDic;

@end
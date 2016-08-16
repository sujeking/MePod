//
//  HXSBuildingEntry.h
//  store
//
//  Created by ArthurWang on 15/9/1.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSBuildingEntry : NSObject

@property (nonatomic, strong) NSString *nameStr;            // "东区"
@property (nonatomic, strong) NSString *buildingNameStr;    // "D1"
@property (nonatomic, strong) NSNumber *dormentryIDNum;

@property (nonatomic, assign) BOOL hasOpened; // YES 表示至少一个店已经开通  NO 表示都没有开通


- (id)initWithDictionary:(NSDictionary *)dic;

- (NSDictionary *)encodeAsDic;

@end

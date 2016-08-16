//
//  HXSBoxEntry.h
//  store
//
//  Created by ArthurWang on 15/8/11.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSBoxEntry : NSObject

@property (nonatomic, strong) NSNumber *boxID;
@property (nonatomic, strong) NSString *roomStr;
@property (nonatomic, strong) NSString *boxCodeStr;

- (id)initWithDictionary:(NSDictionary *)dic;

- (NSDictionary *)encodeAsDic;

@end

//
//  HXSZone.h
//  store
//
//  Created by chsasaw on 14/10/28.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSZone : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSMutableArray * sites;

- (id) initWithDictionary:(NSDictionary *)dic;
- (NSDictionary *)encodeAsDic;

@end

//
//  NSMutableDictionary+Safety.h
//  store
//
//  Created by ArthurWang on 15/7/31.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Safety)

- (void)setObjectExceptNil:(id)anObject forKey:(id<NSCopying>)aKey;

@end

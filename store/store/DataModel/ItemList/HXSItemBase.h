//
//  HXSItemBase.h
//  store
//
//  Created by chsasaw on 14/10/29.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSClickEvent.h"

#define ITEM_TYPE_BASE              @"base"
#define ITEM_TYPE_ENTRY             @"entry"
#define ITEM_TYPE_SLIDE             @"slide"
#define ITEM_TYPE_CARD              @"card"

@interface HXSItemBase : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSNumber * imageWidth;
@property (nonatomic, copy) NSNumber * imageHeight;
@property (nonatomic, copy) NSString * itemType;
@property (nonatomic, assign) int order;

@property (nonatomic, strong) HXSClickEvent * clickEvent;

+ (HXSItemBase *)itemWithLocalDic:(NSDictionary *)dic;
+ (HXSItemBase *)itemWithServerDic:(NSDictionary *)dic itemType:(NSString *)itemType;

- (id) initWithLocalDic:(NSDictionary *)dic;
- (id) initWithServerDic:(NSDictionary *)dic;

- (NSMutableDictionary *) encodeAsLocalDic;

- (CGSize)getImageSize;

@end
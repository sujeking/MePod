//
//  HXSCartsItem.m
//  store
//
//  Created by  黎明 on 16/3/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCartsItem.h"

@implementation HXSCartsItem

+ (id)initWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {

        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"item_id"]) {
        self.itemIdNum = value;
    }

    if ([key isEqualToString:@"origin_price"]) {
        self.OriginPrice = value;
    }
    
    
    if ([key isEqualToString:@"image_medium"]) {
        self.imageMediumStr = value;
    }

    if ([key isEqualToString:@"amount"]) {
        self.amountNum = value;
    }

    if ([key isEqualToString:@"dormentryId"]) {
        self.dormentryIdNum = value;
    }

    if ([key isEqualToString:@"errorInfo"]) {
        self.errorInfoStr = value;
    }

    if ([key isEqualToString:@"imageBig"]) {
        self.imageBigStr = value;
    }

    if ([key isEqualToString:@"imageMedium"]) {
        self.imageMediumStr = value;
    }

    if ([key isEqualToString:@"imageSmall"]) {
        self.imageSmallStr = value;
    }

    if ([key isEqualToString:@"errorInfo"]) {
        self.errorInfoStr = value;
    }

    if ([key isEqualToString:@"name"]) {
        self.nameStr = value;
    }

    if ([key isEqualToString:@"ownerUserId"]) {
        self.ownerUserIdNum = value;
    }
    
    if ([key isEqualToString:@"price"]) {
        self.priceNum = value;
    }
    
    if ([key isEqualToString:@"quantity"]) {
        self.quantityNum = value;
    }

    if ([key isEqualToString:@"rid"]) {
        self.ridNum = value;
    }
    
    if ([key isEqualToString:@"sessionNumber"]) {
        self.sessionNumberNum = value;
    }

    if ([key isEqualToString:@"order"]) {
        self.orderNum = value;
    }
}


@end

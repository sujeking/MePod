//
//  NSString+HXSOrderPayType.h
//  store
//
//  Created by ArthurWang on 15/12/10.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXMacrosEnum.h"

@interface NSString (HXSOrderPayType)

+ (NSString *)payTypeStringWithPayType:(HXSOrderPayType)orderPayType amount:(NSNumber *)amount;

+ (NSString *)payTypeStringWithPayType:(HXSOrderPayType)orderPayType;

+ (NSString *)orderTypeNameStringWithOrderType:(HXSOrderType)orderType;

+ (NSString *)storeOrderStatusDescWithType:(NSInteger)type payStatus:(NSInteger)payStatus refundStatusMsg:(NSString *)refundMsg;

@end

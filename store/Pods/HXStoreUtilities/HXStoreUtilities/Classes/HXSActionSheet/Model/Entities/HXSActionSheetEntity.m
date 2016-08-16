//
//  HXSActionSheetEntity.m
//  store
//
//  Created by ArthurWang on 15/12/8.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSActionSheetEntity.h"

@implementation HXSActionSheetEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"payTypeIntNum",       @"pay_type",
                             @"nameStr",             @"name",
                             @"iconURLStr",          @"icon",
                             @"descriptionStr",      @"description",
                             @"promotionStr",        @"promotion", nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (NSArray *)createActionSheetEntityWithPaymentArr:(NSArray *)paymentArr
{
    return [HXSActionSheetEntity arrayOfModelsFromDictionaries:paymentArr error:nil];
}

@end

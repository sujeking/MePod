//
//  HXSPrintCartEntity.m
//  store
//
//  Created by 格格 on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintCartEntity.h"

@implementation HXSPrintCartEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *cartMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"totalAmountDoubleNum",   @"total_amount",
                                 @"deliveryAmountDoubleNum",@"delivery_amount",
                                 @"documentAmountDoubleNum",@"document_amount",
                                 @"couponCodeStr",          @"coupon_code",
                                 @"couponDiscountDoubleNum",@"coupon_discount",
                                 @"sendTypeIntNum",         @"send_type",
                                 @"deliveryTypeIntNum",     @"delivery_type",
                                 @"expectStartTimeLongNum", @"expect_start_time",
                                 @"expectEndTimeLongNum",   @"expect_end_time",
                                 @"expectTimeNameStr",      @"expect_time_name",
                                 @"pickAddressStr",         @"pick_address",
                                 @"pickTimeStr",            @"pick_time_string",
                                 @"shopIdIntNum",           @"shop_id",
                                 @"openAdIntNum",           @"open_ad",
                                 @"printIntNum",            @"print_num",
                                 @"printPagesIntNum",       @"print_pages",
                                 @"docTypeNum",             @"doc_type",
                                 @"freeAmountDoubleNum",    @"free_amount",
                                 @"adPageNumIntNum",        @"ad_page_num",
                                 @"couponHadNum",           @"coupon_had",
                                 @"itemsArray",             @"items",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:cartMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSPrintCartEntity alloc] initWithDictionary:object error:nil];
}

- (NSDictionary *)printCartDictionary
{
    // 转化json
    NSMutableArray *itemsArray = [NSMutableArray array];
    for(HXSMyPrintOrderItem *temp in self.itemsArray){
        [itemsArray addObject:[temp itemDictionary]];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:itemsArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = @{
                          @"doc_type":self.docTypeNum
                          ,@"coupon_code":self.couponCodeStr
                          ,@"send_type":self.sendTypeIntNum
                          ,@"delivery_type":self.deliveryTypeIntNum
                          ,@"expect_start_time":self.expectStartTimeLongNum
                          ,@"expect_end_time":self.expectEndTimeLongNum
                          ,@"expect_time_name":self.expectTimeNameStr
                          ,@"items":jsonStr
                          };
    return dic;
}

@end

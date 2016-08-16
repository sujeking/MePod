//
//  HXSPrintOrderInfo.m
//  store
//
//  Created by 格格 on 16/3/28.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintOrderInfo.h"

#import "HXMacrosUtils.h"
#import "NSString+HXSOrderPayType.h"

@implementation HXSPrintOrderInfo

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *orderMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"freeAmountDoubleNum",       @"free_amount",
                                  @"docAmountDoubleNum",        @"doc_amount",
                                  @"adPageNumIntNum",           @"ad_page_num",
                                  @"orderSnLongNum",            @"order_sn",
                                  @"statusIntNum",              @"status",
                                  @"typeIntNum",                @"type",
                                  @"sourceIntNum",              @"source",
                                  @"paytypeIntNum",             @"paytype",
                                  @"payTradeNoStr",             @"pay_trade_no",
                                  @"printTypeIntNum",           @"print_type",
                                  @"refundStatusCodeNum",       @"refund_status_code",
                                  @"refundStatusMsgStr",        @"refund_status_msg",
                                  @"printIntNum",               @"print_num",
                                  @"printAmountDoubleNum",      @"print_amount",
                                  @"printPagesIntNum",          @"print_pages",
                                  @"deliveryAmountDoubleNum",   @"delivery_amount",
                                  @"discountDoubleNum",         @"discount",
                                  @"couponDiscountDoubleNum",   @"coupon_discount",
                                  @"orderAmountDoubleNum",      @"item_amount",
                                  @"addTimeLongNum",            @"add_time",
                                  @"confirmTimeLongNum",        @"confirm_time",
                                  @"sendTimeLongNum",           @"send_time",
                                  @"addressStr",                @"address",
                                  @"phoneStr",                  @"phone",
                                  @"dormContactStr",            @"dorm_contact",
                                  @"sendTypeIntNum",            @"send_type",
                                  @"deliveryTypeIntNum",        @"delivery_type",
                                  @"expectStartTimeLongNum",    @"expect_start_time",
                                  @"expectEndTimeLongNum",      @"expect_end_time",
                                  @"deliveryDescStr",           @"delivery_desc",
                                  @"remarkStr",                 @"remark",
                                  @"attachStr",                 @"attach",
                                  @"cancelReasonStr",           @"cancel_reason",
                                  @"payTimeLongNum",            @"paytime",
                                  @"payAmountDoubleNum",        @"order_amount",
                                  @"itemsArr",                  @"items",
                                  nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:orderMapping];
}

+(instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSPrintOrderInfo alloc] initWithDictionary:object error:nil];
}

- (NSString *)getPayType
{
    if (0.0 >= self.orderAmountDoubleNum.doubleValue) {
        return @"无";
    }
    
    return [NSString payTypeStringWithPayType:self.paytypeIntNum.intValue];
}

- (CGFloat)getCancleResonLabelHeight{
    NSString *str  = [NSString stringWithFormat:@"取消理由：%@",self.cancelReasonStr];
     CGSize titleSize = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    if(ceilf(titleSize.height) <= 13)
        return 0;
    return ceilf(titleSize.height) - 13;
}

@end

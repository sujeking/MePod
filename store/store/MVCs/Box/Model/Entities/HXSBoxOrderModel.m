//
//  HXSBoxOrderModel.m
//  store
//
//  Created by 格格 on 16/6/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxOrderModel.h"
#import "HXSOrderInfo.h"

/*************************************************************************/
@implementation HXSBoxPromotionItemModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"title"  :@"titleStr",
                              @"type"   :@"typeNum",
                              @"link"   :@"linkStr",
                              @"scheme" :@"schemeStr",
                              @"params" :@"paramsDic"
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

@end

/*************************************************************************/
@implementation HXSBoxOrderItemModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"item_id"            :@"itemIdNum",
                              @"name"               :@"nameStr",
                              @"quantity"           :@"quantityNum",
                              @"price"              :@"priceDoubleNum",
                              @"origin_price"       :@"originPriceDoubleNum",
                              @"stock"              :@"stockNum",
                              @"has_stock"          :@"hasStock",
                              @"sales"              :@"salesNum",
                              @"amount"             :@"amountDoubleNum",
                              @"sales_range"        :@"salesRangeNum",
                              @"cate_id"            :@"cateIdNum",
                              @"tip"                :@"tipStr",
                              @"image_thumb"        :@"imageThumbStr",
                              @"images"             :@"imagesArr",
                              @"image_medium"       :@"imageMediumStr",
                              @"description"        :@"descriptionStr",
                              @"description_title"  :@"descriptionTitleStr",
                              @"description_content":@"descriptionContentStr",
                              @"promotion_id"       :@"promotionIdNum",
                              @"promotion_label"    :@"promotionLabelStr",
                              @"promotions"         :@"promotionsArr"
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSBoxOrderItemModel alloc] initWithDictionary:object error:nil];
}

@end

/*************************************************************************/

@implementation HXSBoxOrderPayItemModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"orderId"    :@"orderIdStr",
                              @"type"       :@"typeNum",
                              @"source"     :@"sourceNum",
                              @"status"     :@"statusNum",
                              @"refund_status":@"refundStatusNum",
                              @"amount"       :@"amountDoubleNum",
                              @"payer_id"     :@"payerIdStr",
                              @"payer_type"   :@"payerTypeNum",
                              @"out_id"       :@"outIdStr",
                              @"out_payer_id" :@"outPayerIdStr",
                              @"remark"       :@"remarkStr",
                              @"update_time"  :@"updateTimeNum",
                              @"name"         :@"nameStr"
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

@end

/*************************************************************************/

@implementation HXSBoxDiscountInfoItemModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"discount_title":@"discountTitleStr",
                              @"discount"      :@"discountDoubleNum"
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

@end

/*************************************************************************/
@implementation HXSBoxActivityModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"action"     :@"actionStr",
                              @"title"      :@"titleStr",
                              @"text"       :@"textStr",
                              @"url"        :@"urlStr",
                              @"image_url"  :@"imageUrlStr",
                              @"share_btn"  :@"shareBtnStr"
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

@end

@implementation HXSBoxOrderModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"order_id"           :@"orderIdStr",
                              @"order_status"       :@"orderStatusNum",
                              @"order_pay_status"   :@"orderPayStatusNum",
                              @"pay_amount"         :@"payAmountDoubleNum",
                              @"order_amount"       :@"orderAmountDoubleNum",
                              @"coupon_amount"      :@"couponAmountDoubleNum",
                              @"item_count"         :@"itemCountNum",
                              @"buyer_address"      :@"buyerAddressStr",
                              @"delivery"           :@"deliveryStr",
                              @"buyer_phone"        :@"buyerPhoneStr",
                              @"buyer_remark"       :@"buyerRemarkStr",
                              @"biz_type"           :@"bizTypeNum",
                              @"is_deleted"         :@"isDeleted",
                              @"sub_status"         :@"subStatusNum",
                              @"refund_status"      :@"refundStatusNum",
                              @"source"             :@"sourceNum",
                              @"update_time"        :@"updateTimeNum",
                              @"create_time"        :@"createTimeNum",
                              @"delivery_fee"       :@"deliveryFeeDoubleNum",
                              @"seller_id"          :@"sellerIdStr",
                              @"seller_name"        :@"sellerNameStr",
                              @"seller_phone"       :@"sellerPhoneStr",
                              @"seller_address"     :@"sellerAddressStr",
                              @"seller_siteId"      :@"sellerSiteIdNum",
                              @"seller_dormentry_id":@"sellerDormentryIdNum",
                              @"seller_shop_id"     :@"sellerShopIdNum",
                              @"buyer_id"           :@"buyerIdStr",
                              @"buyer_name"         :@"buyerNameStr",
                              @"buyer_expect_time"  :@"buyerExpectTimeStr",
                              @"evaluate_score"     :@"evaluateScoreNum",
                              @"evaluation"         :@"evaluationStr",
                              @"device_id"          :@"deviceIdStr",
                              @"extension"          :@"extensionStr",
                              @"items"              :@"itemsArr",
                              @"order_pay"          :@"orderPayArr",
                              @"discount_info"      :@"discountInfoArr",
                              @"activities"         :@"activitiesArr",
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}


+ (instancetype)objectFromJSONObject:(NSDictionary *)object;
{
    return [[HXSBoxOrderModel alloc] initWithDictionary:object error:nil];
}

- (NSString *)refundStatusMsg{
    switch (self.refundStatusNum.intValue) {
        case 1:
            return @"退款中";
            break;
        case 2:
            return @"已退款";
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)getStatus {
    
    HXSBoxOrderPayItemModel *payItem = [self.orderPayArr objectAtIndex:0];
    
    switch (self.orderStatusNum.intValue) {
        case 0:
            if(payItem.typeNum.intValue != 0 && self.orderStatusNum.intValue == 0) {
                return @"未支付";
            }
            
            return @"已下单";
            break;
        case 1:
            return @"配货中";
            break;
        case 2:
            return @"已完成";
            break;
        case 3:
            return @"等待处理";
            break;
        case 4:
            return @"已完成";
            break;
        case 5:
            return @"订单取消";
            break;
        case 11:
            return @"等待支付";
            break;
        default:
            break;
    }
    
    return @"未知状态";
}

- (NSString *)getPayType
{
    if (0.001 >= [self.orderAmountDoubleNum floatValue]) {
        return @"无";
    }
    HXSBoxOrderPayItemModel *payItem = [self.orderPayArr objectAtIndex:0];

    return [NSString payTypeStringWithPayType:payItem.typeNum.intValue];
}

- (NSArray *)changeActivitiesArrToOld{
    NSMutableArray *arr = [NSMutableArray array];
    for(HXSBoxActivityModel *temp in self.activitiesArr){
        HXSOrderActivitInfo *activeInfo = [[HXSOrderActivitInfo alloc]init];
        activeInfo.action = temp.actionStr;
        activeInfo.title = temp.titleStr;
        activeInfo.text = temp.actionStr;
        activeInfo.url = temp.urlStr;
        activeInfo.imageUrl = temp.imageUrlStr;
        activeInfo.shareBtnImgUrl = temp.shareBtnStr;
        [arr addObject:activeInfo];
    }
    return arr;
}

@end

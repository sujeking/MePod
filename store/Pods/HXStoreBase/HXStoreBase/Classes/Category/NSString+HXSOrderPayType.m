//
//  NSString+HXSOrderPayType.m
//  store
//
//  Created by ArthurWang on 15/12/10.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "NSString+HXSOrderPayType.h"

@implementation NSString (HXSOrderPayType)

+ (NSString *)payTypeStringWithPayType:(HXSOrderPayType)orderPayType amount:(NSNumber *)amount
{
    
    NSString *payTypeStr = [self payTypeStringWithPayType:orderPayType];
    payTypeStr = (0.0 >= [amount floatValue]) ? @"无" : payTypeStr;
    return payTypeStr;
}

// 0表示现金，1表示支付宝，2表示微信支付 3表示信用钱包
+ (NSString *)payTypeStringWithPayType:(HXSOrderPayType)orderPayType
{
    NSString *payTypeStr = @"";
    
    switch (orderPayType) {
        case kHXSOrderPayTypeCash:
        {
            payTypeStr = @"货到付款";
        }
            break;
            
        case kHXSOrderPayTypeZhifu:
        {
            payTypeStr = @"支付宝";
        }
            break;
            
        case kHXSOrderPayTypeWechat://对用户端来说2和6都是微信支付，只做显示处理
        {
            payTypeStr = @"微信";
        }
            break;
            
        case kHXSOrderPayTypeBaiHuaHua:
        {
            payTypeStr = @"59钱包";
        }
            break;
            
        case kHXSOrderPayTypeAlipayScan:
        {
            payTypeStr = @"货到付款 - 扫码付";
        }
            break;
            
        case kHXSOrderPayTypeWechatScan:
        {
            payTypeStr = @"货到付款－微信刷卡";
        }
            break;
            
        case kHXSOrderPayTypeWechatApp://对用户端来说2和6都是微信支付，只做显示处理
        {
            payTypeStr = @"微信";
        }
            break;
            
        case kHXSOrderPayTypeCreditCard:
        {
            payTypeStr = @"59钱包";
        }
            break;
            
        case kHXSOrderPayTypeBestPay:
        {
            payTypeStr = @"翼支付";
        }
            break;
            
        default:
            payTypeStr = @"无";
            break;
    }
    
    return payTypeStr;
}

+ (NSString *)orderTypeNameStringWithOrderType:(HXSOrderType)orderType
{
    NSString * orderTypeName = @"59订单";
    
    switch (orderType) {
        case kHXSOrderTypeNormal:
            orderTypeName = @"商品";
            break;
            
        case kHXSOrderTypeGroupPurchase:
            orderTypeName = @"团购";
            break;
            
        case kHXsOrderTypeBook:
            orderTypeName = @"预定";
            break;
            
        case kHXSOrderTypeChinaMoble:
            orderTypeName = @"中国移动项目";
            break;
            
        case kHXSOrderTypeDorm:
            orderTypeName = @"夜猫店";
            break;
            
        case kHXSOrderTypeBox:
            orderTypeName = @"零食盒";
            break;
            
        case kHXSOrderTypeEleme:
            orderTypeName = @"饿了么";
            break;
            
        case kHXSOrderTypeDrink:
            orderTypeName = @"饮品店";
            break;
            
        case kHXSOrderTypePrint:
            orderTypeName = @"打印店";
            break;
            
        case kHXSOrderTypeCharge:
            orderTypeName = @"分期商城";
            break;
            
        case kHXSOrderTypeInstallment:
            orderTypeName = @"分期商城";
            break;
            
        case kHXSOrderTypeEncashment:
            orderTypeName = @"取现";
            break;
            
        case kHXSOrderTypeStore:
            orderTypeName = @"云超市";
            break;
            
        case kHXSOrderTypeNewBox:
            orderTypeName = @"零食盒";
            break;
            
        case kHXSOrderTypeOneDream:
            orderTypeName = @"一元夺宝";
            break;
            
        default:
            break;
    }

    return orderTypeName;
}

+ (NSString *)storeOrderStatusDescWithType:(NSInteger)type payStatus:(NSInteger)payStatus refundStatusMsg:(NSString *)refundMsg{
    
    switch (type) {
        case HXSStoreOrderStatusCreated: {
            if (payStatus == 0) {
                return @"未支付";
            }
            return @"已下单";
            break;
        }
        case HXSStoreOrderStatusReceived: {
            return @"已接单";
            break;
        }
        case HXSStoreOrderStatusDeliveried: {
            return @"已送达";
            break;
        }
        case HXSStoreOrderStatusCompleted: {
            return @"已完成";
            break;
        }
        case HXSStoreOrderStatusCancel: {
            if (refundMsg && refundMsg.length > 0) {
                return [NSString stringWithFormat:@"已取消 (%@)", refundMsg];
            }else {
                return @"已取消";
            }
            break;
        }
        case HXSStoreOrderStatusDistributing: {
            return @"配送中";
            break;
        }
    }
    return @"未知状态";
}
@end

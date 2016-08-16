//
//  HXSPrintOrderInfo.h
//  store
//
//  Created by 格格 on 16/3/28.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"
#import "HXSMyPrintOrderItem.h"

@interface HXSPrintOrderInfo : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *freeAmountDoubleNum; // 福利纸总价
@property (nonatomic, strong) NSNumber *docAmountDoubleNum; // 文档优惠前价格. 用于显示订单详情的订单金额
@property (nonatomic, strong) NSNumber *adPageNumIntNum; // 订单免费打印的张数
@property(nonatomic, strong) NSString *orderSnLongNum; // 订单号
@property(nonatomic, strong) NSNumber *statusIntNum;   // 订单状态？？？ 0表示未支付(下单成功)，1表示已确认(需要店长确认)，2表示已送出(用户端夜猫店、饮品店显示已完成，分期购配货中)，3表示待发货(分期购订单)，4表示已完成，5表示失败(已取消)，
@property(nonatomic, strong) NSNumber *typeIntNum;     //  0表示便利店(废弃)，1表示团购订单(废弃)，2表示预定订单(废弃)，3表示中国移动项目(废弃)，4表示夜猫店 5表示零食盒 6表示饿了么  7表示饮品店 8打印店订单 9表示充值订单 10表示分期购订单 11取现订单
@property(nonatomic, strong) NSNumber *sourceIntNum;  // 订单来源平台, 0:网站; 1:手机网页(微信); 2:shop端快速下单(废弃); 3:iOS  4:android 5饿了么平台  6到店付
@property(nonatomic, strong) NSNumber *paytypeIntNum; // 支付方式 0表示现金，1表示支付宝，2表示微信公众号支付，3表示白花花支付(废弃)，4表示支付宝扫码付，5表示微信刷卡支付，6表示微信App支付 7表示店长代付 8表示信用钱包支付
@property(nonatomic, strong) NSString *payTradeNoStr; // 支付宝或微信支付的交易号
@property(nonatomic, strong) NSNumber *refundStatusCodeNum; // 0为退款中，1为已退款，一定会有该字段
@property(nonatomic, strong) NSString *refundStatusMsgStr;  // 一定会有该字段，字段内容可能为空
@property(nonatomic, strong) NSNumber *printIntNum;         // 打印文档份数
@property(nonatomic, strong) NSNumber *printAmountDoubleNum; // 文档总金额
@property(nonatomic, strong) NSNumber *printPagesIntNum;     //文档的总页数
@property(nonatomic, strong) NSNumber *deliveryAmountDoubleNum; // 配送费用
@property(nonatomic, strong) NSNumber *discountDoubleNum;       // 合计折扣金额
@property(nonatomic, strong) NSNumber *couponDiscountDoubleNum; // 优惠券金额
@property(nonatomic, strong) NSNumber *orderAmountDoubleNum; // print_amount + delivery_fee - discount，订单金额
@property(nonatomic, strong) NSNumber *addTimeLongNum; // 订单下单时间
@property(nonatomic, strong) NSNumber *confirmTimeLongNum; // 店长确认订单时间
@property(nonatomic, strong) NSNumber *sendTimeLongNum; // 送达时间
@property(nonatomic, strong) NSString *addressStr; // 用户地址
@property(nonatomic, strong) NSString *phoneStr; // 用户电话
@property(nonatomic, strong) NSString *dormContactStr; // 楼主手机号
@property(nonatomic, strong) NSNumber *sendTypeIntNum; // 取货类型
@property(nonatomic, strong) NSNumber *deliveryTypeIntNum; // 配送方式
@property(nonatomic, strong) NSNumber *expectStartTimeLongNum; // 配送开始时间
@property(nonatomic, strong) NSNumber *expectEndTimeLongNum; // 配送结束时间
@property(nonatomic, strong) NSString *deliveryDescStr; // 配送时间和配送方式的描述(店长配送  19:00-19:15)
@property(nonatomic, strong) NSString *remarkStr; //备注
@property(nonatomic, strong) NSNumber *payTimeLongNum; // 支付时间
@property(nonatomic, strong) NSString *attachStr;
@property(nonatomic, strong) NSString *cancelReasonStr; // 取消理由

@property(nonatomic, strong) NSNumber *payAmountDoubleNum; // 订单实付金额

@property(nonatomic, strong) NSMutableArray<HXSMyPrintOrderItem> *itemsArr;



+(instancetype)objectFromJSONObject:(NSDictionary *)object;

- (NSString *)getPayType;

- (CGFloat)getCancleResonLabelHeight;
@end

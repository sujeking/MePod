//
//  HXSBoxOrderModel.h
//  store
//
//  Created by 格格 on 16/6/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kHXSBoxOrderStayusUnknow   = -1, // 未知状态
    kHXSBoxOrderStayusNotPay   = 0,  // 未支付
    kHXSBoxOrderStayusFinished = 1,  // 已完成
    kHXSBoxOrderStayusCancled  = 2,  // 已取消
} kHXSBoxOrderStayus;

// 订单商品促销信息
@protocol HXSBoxPromotionItemModel
@end

@interface HXSBoxPromotionItemModel : HXBaseJSONModel

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSNumber *typeNum;
@property (nonatomic, strong) NSString *linkStr;
@property (nonatomic, strong) NSString *schemeStr;
@property (nonatomic, strong) NSDictionary *paramsDic;

@end


// 订单商品信息
@protocol HXSBoxOrderItemModel
@end
@interface HXSBoxOrderItemModel : HXBaseJSONModel

@property (nonatomic, strong) NSString *productIdStr;       // 商品原型ID
@property (nonatomic, strong) NSNumber *itemIdNum;          // 商品ID
@property (nonatomic, strong) NSString *nameStr;            // 商品名称
@property (nonatomic, strong) NSNumber *quantityNum;        // 商品数量
@property (nonatomic, strong) NSNumber *priceDoubleNum;     // 商品价格
@property (nonatomic, strong) NSNumber *originPriceDoubleNum; // 原价
@property (nonatomic, strong) NSNumber *stockNum;           // 库存
@property (nonatomic, assign) BOOL hasStock;                // 1:有库存，0:无库存
@property (nonatomic, strong) NSNumber *salesNum;           // 销量
@property (nonatomic, strong) NSNumber *amountDoubleNum;    // 本条商品记录商品结算金额，单位为元
@property (nonatomic, strong) NSNumber *salesRangeNum;      // 销售热度
@property (nonatomic, strong) NSNumber *cateIdNum;          // 分类ID
@property (nonatomic, strong) NSString *tipStr;
@property (nonatomic, strong) NSString *imageThumbStr;      // 缩略图
@property (nonatomic, strong) NSMutableArray *imagesArr;    // 轮播图
@property (nonatomic, strong) NSString *imageMediumStr;     // 兼容旧版本
@property (nonatomic, strong) NSString *descriptionStr;     // 图描述
@property (nonatomic, strong) NSString *descriptionTitleStr;    // 代替以前的description
@property (nonatomic, strong) NSString *descriptionContentStr;  // 代替以前的tip
@property (nonatomic, strong) NSNumber *promotionIdNum;         // 促销ID
@property (nonatomic, strong) NSString *promotionLabelStr;      //"超低价"

@property (nonatomic, strong) NSMutableArray<HXSBoxPromotionItemModel> *promotionsArr; // 促销

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end


// 订单支付信息
@protocol HXSBoxOrderPayItemModel
@end

@interface HXSBoxOrderPayItemModel : HXBaseJSONModel

/** 订单ID */
@property (nonatomic, strong) NSString *orderIdStr;
/** 支付方式 */
@property (nonatomic, strong) NSNumber *typeNum;
/** 支付名称 */
@property (nonatomic, strong) NSString *nameStr;
/** 支付来源 */
@property (nonatomic, strong) NSNumber *sourceNum;
/** 该支付方式的状态（第三方支付会用到） */
@property (nonatomic, strong) NSNumber *statusNum;
/** 退款状态 */
@property (nonatomic, strong) NSNumber *refundStatusNum;
/** 该支付方式支付的金额，单位为分 */
@property (nonatomic, strong) NSNumber *amountDoubleNum;
/** 付款人id */
@property (nonatomic, strong) NSString *payerIdStr;
/** 付款人类型 */
@property (nonatomic, strong) NSNumber *payerTypeNum;
/** 支付宝、微信的pay_trade_no，促销活动的promotion_id，优惠券的coupon_code */
@property (nonatomic, strong) NSString *outIdStr;
/** 外部付款人id */
@property (nonatomic, strong) NSString *outPayerIdStr;
/** 支付信息描述 */
@property (nonatomic, strong) NSString *remarkStr;
/** 更新时间 */
@property (nonatomic, strong) NSNumber *updateTimeNum;

@end


// 订单折扣信息
@protocol HXSBoxDiscountInfoItemModel
@end

@interface HXSBoxDiscountInfoItemModel: HXBaseJSONModel

@property (nonatomic, strong) NSString *discountTitleStr;  // 折扣标题
@property (nonatomic, strong) NSNumber *discountDoubleNum; // 折扣值


@end


// 订单活动信息
@protocol HXSBoxActivityModel
@end

@interface HXSBoxActivityModel : HXBaseJSONModel

@property (nonatomic, strong) NSString *actionStr;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *textStr;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSString *imageUrlStr;
@property (nonatomic, strong) NSString *shareBtnStr;

@end


// 订单信息
@interface HXSBoxOrderModel : HXBaseJSONModel

/** 订单ID */
@property (nonatomic, strong) NSString *orderIdStr;
/** 订单状态 */
@property (nonatomic, strong) NSNumber *orderStatusNum;
/** 支付状态 */
@property (nonatomic, strong) NSNumber *orderPayStatusNum;
/** 支付总金额（商品包含优惠总金额+运费） */
@property (nonatomic, strong) NSNumber *payAmountDoubleNum;
/** 最终显示总金额 */
@property (nonatomic, strong) NSNumber *orderAmountDoubleNum;
/** 优惠金额 */
@property (nonatomic, strong) NSNumber *couponAmountDoubleNum;
/** 商品总计 */
@property (nonatomic, strong) NSNumber *itemCountNum;
/** 配送信息(在用户端不显示) */
@property (nonatomic, strong) NSString *deliveryStr;
/** 零食盒子 */
@property (nonatomic, strong) NSNumber *bizTypeNum;
/** 1:已删除，0:未删除 */
@property (nonatomic, assign) BOOL isDeleted;
@property (nonatomic, strong) NSNumber *subStatusNum;
/** 退款状态 */
@property (nonatomic, strong) NSNumber *refundStatusNum;
/** 订单来源 */
@property (nonatomic, strong) NSNumber *sourceNum;
/** 更新时间 */
@property (nonatomic, strong) NSNumber *updateTimeNum;
/** 下单时间 */
@property (nonatomic, strong) NSNumber *createTimeNum;
/** 运费 */
@property (nonatomic, strong) NSNumber *deliveryFeeDoubleNum;
/** 卖家ID */
@property (nonatomic, strong) NSString *sellerIdStr;
/** 卖家名字 */
@property (nonatomic, strong) NSString *sellerNameStr;
/** 卖家手机号 */
@property (nonatomic, strong) NSString *sellerPhoneStr;
/** 卖家地址 */
@property (nonatomic, strong) NSString *sellerAddressStr;
/** 卖家校区id */
@property (nonatomic, strong) NSNumber *sellerSiteIdNum;
/** 卖家楼栋id */
@property (nonatomic, strong) NSNumber *sellerDormentryIdNum;
/** 卖家店铺id */
@property (nonatomic, strong) NSNumber *sellerShopIdNum;
/** 买家ID */
@property (nonatomic, strong) NSString *buyerIdStr;
/** 买家名称 */
@property (nonatomic, strong) NSString *buyerNameStr;
/** 买家手机 */
@property (nonatomic, strong) NSString *buyerPhoneStr;
/** 需带上寝室号 */
@property (nonatomic, strong) NSString *buyerAddressStr;
/** 买家期望收货时间字符串 */
@property (nonatomic, strong) NSString *buyerExpectTimeStr;
/** 备注 */
@property (nonatomic, strong) NSString *buyerRemarkStr;
/** 买家评级 */
@property (nonatomic, strong) NSNumber *evaluateScoreNum;
/** 买家评语 */
@property (nonatomic, strong) NSString *evaluationStr;
/** 设备ID */
@property (nonatomic, strong) NSString *deviceIdStr;
/** 扩展信息 */
@property (nonatomic, strong) NSDictionary *extensionStr;

/** 订单商品信息 */
@property (nonatomic, strong) NSMutableArray<HXSBoxOrderItemModel> *itemsArr;
/** 支付信息 */
@property (nonatomic, strong) NSMutableArray<HXSBoxOrderPayItemModel> *orderPayArr;
/** 折扣信息 */
@property (nonatomic, strong) NSMutableArray<HXSBoxDiscountInfoItemModel> *discountInfoArr;
/** 活动 */
@property (nonatomic, strong) NSMutableArray<HXSBoxActivityModel> *activitiesArr;

// 自己添加的字段，非服务器返回
@property (nonatomic, strong) NSString *refundStatusMsg; // 退款状态描述

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

- (NSString *)getStatus;

- (NSString *)getPayType;

// 将activitiesArr里面的对象转成老的活动entity
- (NSArray *)changeActivitiesArrToOld;
@end

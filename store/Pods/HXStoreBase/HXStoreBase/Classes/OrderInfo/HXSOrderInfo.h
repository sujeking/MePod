//
//  HXSOrderInfo.h
//  store
//
//  Created by chsasaw on 14/12/4.
//  strongright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

typedef NS_ENUM(NSInteger, HXSOrderInfoInstallment){
    kHXSOrderInfoInstallmentNO = 0,
    kHXSOrderInfoInstallmentYES = 1,
};

@interface HXSOrderDiscountDetail : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *discountAmountFloatNum;     // 折扣金额
@property (nonatomic, strong) NSString *discountDescStr;            // 折扣描述

+ (instancetype)createOrderDiscountDetailWithDic:(NSDictionary *)dic;

@end


@protocol HXSOrderActivitInfo
@end

@interface HXSOrderActivitInfo : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *shareBtnImgUrl;

@end

@interface HXSOrderItem : NSObject

@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, assign) NSInteger type;               // 同item/info中的type，0表示普通商品，1是组售
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, strong) NSNumber * quantity;          // 购物车中该项的合计金额，可能不等于price * quantity
@property (nonatomic, strong) NSNumber * amount;
@property (nonatomic, strong) NSNumber * origin_price;      // 商品原价，字段总是存在。默认等于price，如果商品有促销活动，则可能不等于price

@property (nonatomic, strong) NSNumber * promotion_id;      // 促销id
@property (nonatomic, strong) NSNumber * promotion_type;    // 促销类型
@property (nonatomic, strong) NSString * promotion_label;   // 促销显示标签

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * image_small;
@property (nonatomic, strong) NSString * image_medium;
@property (nonatomic, strong) NSString * image_big;

@property (nonatomic, strong) NSString * comment;
@property (nonatomic, strong) NSNumber * comment_time;

// 3.3中 “花不完”中添加
@property (nonatomic, strong) NSString *specificationsStr;       // 规格描述


// END


- (id)initWithDictionary:(NSDictionary *)dic;

@end

// ==============================================

@interface HXSRecommendBoxInfo : NSObject

@property (nonatomic, strong) NSString *recommendImage;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

// ==============================================

@interface HXSOrderInfo : NSObject

@property (nonatomic, strong) NSString * order_sn;          // 订单号
@property (nonatomic, assign) int status;                   // 0表示已提交，1表示已确认，2表示已送出(用户端显示已完成)，3表示等待状态(便利店的，废弃)，4表示已完成，5表示失败(已取消)，11表示在线支付等待支付状态
@property (nonatomic, assign) int type;                     // 0表示便利店(废弃)，1表示团购订单(废弃)，2表示预定订单(废弃)，3表示中国移动项目(废弃)，4表示夜猫店 5表示零食盒 6表示饿了么  7表示饮品店  8表示打印店 9表示充值订单 10表示分期购订单
@property (nonatomic, strong) NSString * typeName;
@property (nonatomic, assign) int source;                   // 订单来源平台, 0:网站; 1:手机网页(微信); 3:shop端快速下单

@property (nonatomic, assign) int paytype;                  // 0表示现金，1表示支付宝，2表示微信公众号支付，3表示信用钱包支付，4表示支付宝扫码付，5表示微信刷卡支付，6表示微信App支付
@property (nonatomic, assign) int paystatus;                // 0表示等待用户支付现金，10表示完成
@property (nonatomic, strong) NSString * pay_trade_no;      // 支付宝或微信支付的交易号

@property (nonatomic, strong) NSNumber * service_eva;       // 可以不存在，如果存在，-1表示差评
@property (nonatomic, strong) NSNumber * delivery_eva;      // 可以不存在，如果存在，0表示中评
@property (nonatomic, strong) NSNumber * food_eva;          // 可以不存在，如果存在，1表示好评
@property (nonatomic, strong) NSString * evaluation;
@property (nonatomic, strong) NSString * attach;

@property (nonatomic, strong) NSNumber * food_num;          // 包含商品数量。如果一个订单买1个青豆2个可乐，则为3
@property (nonatomic, strong) NSNumber * food_amount;       // 商品的总金额
@property (nonatomic, strong) NSNumber * delivery_fee;      // 配送费用
@property (nonatomic, strong) NSNumber * discount;          // 合计折扣金额
@property (nonatomic, strong) NSNumber * order_amount;      // food_amount + delivery_fee - discount

@property (nonatomic, strong) NSNumber * add_time;          // 订单下单时间
@property (nonatomic, strong) NSNumber * confirm_time;      // 站点确认订单时间
@property (nonatomic, strong) NSNumber * send_time;         // 站点发货时间
@property (nonatomic, strong) NSNumber * expect_date;       // 期待收货时间。比如2014.12.5收货，则字段为2014.12.5凌晨0:00对应的东8区UNIX时间戳

@property (nonatomic, strong) NSNumber * delivery_type;     // 配送类型，对应于site/info中的delivery_policy，0表示立即送出(59分钟内必达)，1表示预定(某个时间段内送达)

@property (nonatomic, strong) NSString * expect_timeslot;   // 期望收货时间段的字符串表示
@property (nonatomic, strong) NSString * phone;             // 客户手机
@property (nonatomic, strong) NSString * address1;          // 例如“东区”
@property (nonatomic, strong) NSString * address2;          // 例如“D2”
@property (nonatomic, strong) NSString * dormitory;
@property (nonatomic, strong) NSString * dorm_contact;      // 楼主的手机号
@property (nonatomic, strong) NSString * coupon_code;       // 用户使用的优惠券号码

@property (nonatomic, strong) NSMutableArray * features;
@property (nonatomic, strong) NSString * remark;            // 客户下单的备注

@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) NSMutableArray * promotion_items; //满就送的数组

@property (nonatomic, strong) NSNumber * refund_status_code;
@property (nonatomic, strong) NSString * refund_status_msg;

@property (nonatomic, strong) NSArray *shareInfos;
@property (nonatomic, strong) NSArray *activityInfos;

// 3.3中 “花不完”中添加
@property (nonatomic, strong) NSArray *discountDetialArr;       // 折扣明细
@property (nonatomic, strong) NSString *iconURLStr;             // 订单icon
@property (nonatomic, strong) NSNumber *commentStatusIntNum;    // 评价状态  0未评价  1已评价
@property (nonatomic, strong) NSString *consigneeNameStr;       // 收货人姓名
@property (nonatomic, strong) NSString *consigneeAddressStr;    // 收货人地址
@property (nonatomic, strong) NSNumber *installmentIntNum;          // 是否分期
@property (nonatomic, strong) NSNumber *downPaymentFloatNum;          // 首付
@property (nonatomic, strong) NSNumber *installmentAmountFloatNum;  // 分期金额
@property (nonatomic, strong) NSNumber *repaymentAmountFloatNum;    // 每期应还
@property (nonatomic, strong) NSNumber *installmentNumIntNum;       // 分期数
@property (nonatomic, strong) NSString *payTimeStr;                 // 支付时间
@property (nonatomic, strong) NSNumber *downPaymentTypeIntNum;      // 首付方式
@property (nonatomic, strong) NSNumber *installmentTypeIntNum;      // 分期方式
@property (nonatomic, strong) NSString *cacelTimeStr;               // 取消订单时间
@property (nonatomic, strong) NSString *commentTimeStr;             // 评论时间
// END

// APP 3.1
@property (nonatomic, strong) HXSRecommendBoxInfo *recommendBoxInfo;


// 本地自定义属性
@property (nonatomic, strong) NSString *orderDescriptionStr; // 订单的描述，用于下单时上传

- (id)initWithDictionary:(NSDictionary *)dic;

- (NSString *)getStatus;
- (NSString *)getPayType;

- (id)initWithOrderInfo:(id)orderInfo;

@end
//
//  HXSBoxModel.h
//  store
//
//  Created by ArthurWang on 15/7/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSBoxInfoEntity.h"
#import "HXSBoxUserEntity.h"
#import "HXSBoxOrderModel.h"
#import "HXSDormItem.h"
#import "HXSBoxMessageModel.h"

#define HXS_BOX_SHARED_QUIT         @"box/shared/quit"         // 分享人退出盒子
#define HXS_BOX_USER_MESSAGE_LIST   @"user/message/list"       // 获取消息列表
#define HXS_BOX_TRANSTER_HANDLE     @"box/transfer/handle"     // 盒子转让处理
#define HXS_BOX_SHARED_HANDLE       @"box/shared/handle"       // 被共享人消息处理
#define HXS_BOX_CONSUM_INIT_LIST    @"box/consum/init/list"    // 本期初始零食清单
#define HXS_BOX_ORDER_CANCLE        @"box/order/cancel"        // 取消订单
#define HXS_BOX_SHARED_REMOVE       @"box/shared/remove"       // 移除共享人
#define HXS_BOX_MESSAGR_READ        @"user/message/read"       // 消息置为已读
#define HXS_BOX_SHARED_LIST         @"box/shared/list"         // 获取共享人列表

@class HXSBoxOrderEntity;

// 性别类型
typedef enum : NSUInteger {
    HXSBoxGenderTypeMale    = 0,
    HXSBoxGenderTypeFemale  = 1,
}HXSBoxGenderType;


@interface HXSBoxModel : NSObject

#pragma mark Order
/**
 *  获取盒子信息
 *
 *  @param block
 */
+ (void)fetchBoxInfo:(void (^)(HXSErrorCode code, NSString *message, HXSBoxInfoEntity *boxInfoEntity))block;

/**
 *  盒子取消订单
 *
 *  @param orderSNStr 订单号
 *  @param block
 */
- (void)cancelOrderWithOrderSN:(NSString *)orderSNStr
                      complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *orderInfo))block;


/**
 *  获取分享者列表
 *
 *  @param box_id    盒子id
 *  @param with_bill 附带本期已付账单信息，1:是,0:否
 *  @param block
 */
+ (void)fetSharerListWithBoxId:(NSNumber *)box_id
                       batchNo:(NSNumber *)batch_no
                    ifWithBill:(BOOL)with_bill
                      complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *boxerInfoArr,NSArray *sharedInfoArr))block;

/**
 *  零食盒子订单列表
 *
 *  @param uid              用户ID也包括盒主ID
 *  @param box_id           盒子ID
 *  @param batch_no         批次号
 *  @param with_order_items 是否查询订单商品信息  1:是，0:否  **非必填**
 *  @param with_order_pays  是否查询订单支付明细  1:是，0:否 **非必填**
 *  @param block
 */
+ (void)fetOrderListWithUid:(NSNumber *)uid
                      boxId:(NSNumber *)box_id
                    batchNo:(NSNumber *)batch_no
             withOrderItems:(BOOL)with_order_items
              withOrderPays:(BOOL)with_order_pays
                   complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *orders))block;
/**
 *  零食盒子订单详情
 *
 *  @param order_id         订单id
 *  @param with_order_items 是否查询订单商品信息  1:是，0:否  **非必填**
 *  @param with_order_pays   是否查询订单支付明细  1:是，0:否 **非必填**
 *  @param block
 */
+ (void)fetBoxOrderInfoWithOrderId:(NSString *)order_id
                    withOrderItems:(BOOL)with_order_items
                     withOrderPays:(BOOL)with_order_pays
                          complete:(void (^)(HXSErrorCode code, NSString *message, HXSBoxOrderModel *boxOrderModel))block;

/**
 *  转让零食盒子
 *
 *  @param boxId 盒子id
 *  @param uid   用户id
 *  @param block
 */
+ (void)tansferBoxWithBoxId:(NSNumber *)boxId
                     userId:(NSNumber *)uid
                   complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block;
/**
 *  零食盒子商品列表
 *
 *  @param boxId    盒子ID
 *  @param batch_no 盒子批次号
 *  @param block
 */
+ (void)fetBoxItemListWithBoxId:(NSNumber *)boxId
                        batchNo:(NSNumber *)batchNo
                       complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *items))block;

/**
 *  本期初始零食清单
 *
 *  @param box_id   盒子ID
 *  @param batch_no 盒子批次号
 *  @param block
 */
+ (void)fetConsumInitListWithBoxId:(NSNumber *)box_id
                           batchNo:(NSNumber *)batch_no
                          complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *items ,NSNumber *quantity))block;

/**
 *  获取消费清单
 *
 *  @param box_id   盒子ID
 *  @param batch_no 盒子批次号
 *  @param block   notPaidItems：未支付零食列表 notPaidAmount 未支付总计 untakeQuantity 已支付未领取零食数量 amount实际支付金额
 */
+ (void)fetBoxConsumListWithBoxId:(NSNumber *)box_id
                          batchNo:(NSNumber *)batch_no
                         complete:(void (^)(
                                            HXSErrorCode code,
                                            NSString *message,
                                            NSArray *notPaidItems,
                                            NSNumber *notPaidAmount,
                                            NSNumber *untakeQuantity,
                                            NSNumber *billStatus,
                                            HXSOrderInfo *orderInfo
                                            ))block;

/**
 *  已支付未领取零食列表
 *
 *  @param box_id      零食盒子ID
 *  @param item_status 商品状态 0:初始状态，1:已支付未领取，2:已支付已领取，3:未支付
 *  @param block
 */
+ (void)fetBoxConsumUnTakeListWithBoxId:(NSNumber *)box_id
                             batchNo:(NSNumber *)batch_no
                               complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *items ,NSNumber *quantity))block;


/**
 *  零食盒下单
 *
 *  @param itemList 商品列表
 *  @param block
 */
+ (void)createBoxOrderWithItemList:(NSArray *)itemList
                             boxId:(NSNumber *)boxIdNum
                          complete:(void (^)(HXSErrorCode code,NSString *message,HXSBoxOrderModel *orderInfo))block;

/**
 *  零食盒分享者退出盒子
 *
 *  @param uid   用户id
 *  @param boxId 盒子id
 *  @param block
 */
+ (void)sharerQuitBoxWithUid:(NSNumber *)uid
                       boxId:(NSNumber *)boxId
                    complete:(void (^)(HXSErrorCode code,NSString *message,NSDictionary *dic))block;

/**
 *  移除共享人
 *
 *  @param boxId 盒子id
 *  @param uid   用户id
 *  @param block
 */
+ (void)boxRemoveSharerWithBoxId:(NSNumber *)boxId
                             uid:(NSNumber *)uid
                        complete:(void (^)(HXSErrorCode code,NSString *message,NSDictionary *dic))block;

/**
 *  获取消息列表
 *
 *  @param message_status 消息状态 0未读；1已读；2删除
 *  @param size
 *  @param page
 *  @param block
 */
+ (void)fetchBoxMessageListWithMessageStatus:(NSNumber *)message_status
                                        size:(NSNumber *)size
                                        page:(NSNumber *)page
                                    complete:(void (^)(HXSErrorCode code,NSString *message,NSArray *messageList))block;

/**
 *  盒子转让处理
 *
 *  @param boxId      盒子ID
 *  @param uid        用户iD
 *  @param action     action 1:拒绝 2:同意
 *  @param message_id 消息id
 *  @param block
 */
+ (void)handleBoxTransterWithBoxId:(NSNumber *)boxId
                               uid:(NSNumber *)uid
                            action:(NSNumber *)action
                         messageId:(NSString *)message_id
                     boxUserEntity:(HXSBoxUserEntity *)sharedInfo
                          complete:(void (^)(HXSErrorCode code,NSString *message,NSDictionary *dic))block;

/**
 *  被共享人消息处理
 *
 *  @param boxId      盒子ID
 *  @param uid        用户iD
 *  @param action     action 1:拒绝 2:同意
 *  @param message_id 消息id
 *  @param block
 */
+ (void)hanleBoxSharedWithBoxId:(NSNumber *)boxId
                            uid:(NSNumber *)uid
                         action:(NSNumber *)action
                      messageId:(NSString *)message_id
                       complete:(void (^)(HXSErrorCode code,NSString *message,NSDictionary *dic))block;

/**
 *  消息至为已读
 *
 *  @param messageId 消息ID
 *  @param block
 */
+ (void)setMessageReadedWithMessageId:(NSString *)messageId
                             complete:(void (^)(HXSErrorCode code,NSString *message,NSDictionary *dic))block;

/**
 *  更加uid获取分享者信息
 *
 *  @param uid   用户id
 *  @param block
 */
+ (void)fetchBoxSharedInfoWithUid:(NSNumber *)uid
                         complete:(void (^)(HXSErrorCode code,NSString *message,HXSBoxUserEntity *boxShare))block;



@end

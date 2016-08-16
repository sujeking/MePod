//
//  HXSBoxModel.m
//  store
//
//  Created by ArthurWang on 15/7/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBoxModel.h"

#import "HXSBoxOrderEntity.h"
#import "HXSOrderInfo.h"
@interface HXSBoxModel ()


@end

@implementation HXSBoxModel


#pragma mark - Object LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    // Nothing
}


#pragma mark - Public Methods

// 获取盒子信息
+ (void)fetchBoxInfo:(void (^)(HXSErrorCode code, NSString *message, HXSBoxInfoEntity *boxInfoEntity))block
{
    [HXStoreWebService getRequest:HXS_BOX_INFO parameters:@{} progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(kHXSNoError == status){
            
            HXSBoxInfoEntity *boxInfo = [HXSBoxInfoEntity objectFromJSONObject:data];
            block(status,msg,boxInfo);
            
        }else{
            block(status,msg,nil);
        }
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

// 盒子取消订单
- (void)cancelOrderWithOrderSN:(NSString *)orderSNStr
                      complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *orderInfo))block
{
    NSDictionary *prama = @{@"order_id":orderSNStr};
    [HXStoreWebService postRequest:HXS_BOX_ORDER_CANCLE parameters:prama progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];
}

// 获取分享者列表
+ (void)fetSharerListWithBoxId:(NSNumber *)box_id
                       batchNo:(NSNumber *)batch_no
                    ifWithBill:(BOOL)with_bill
                      complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *boxerInfoArr,NSArray *sharedInfoArr))block{

    NSDictionary *parma = @{
                            @"box_id":box_id,
                            @"batch_no":batch_no,
                            @"with_bill":@(with_bill)
                            };
    [HXStoreWebService getRequest:HXS_BOX_SHARED_LIST
                parameters:parma
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(kHXSNoError == status){
            
            NSArray *arr = [data objectForKey:@"boxer_info"];
            NSMutableArray *boxerInfoArray = [NSMutableArray array];
            if(arr){
                for(NSDictionary *dic in arr){
                    HXSBoxUserEntity *temp = [HXSBoxUserEntity objectFromJSONObject:dic];
                    [boxerInfoArray addObject:temp];
                }
            }
            
            arr = [data objectForKey:@"shared_info"];
            NSMutableArray *sharedInfoArray = [NSMutableArray array];
            if(arr){
                for(NSDictionary *dic in arr){
                    HXSBoxUserEntity *temp = [HXSBoxUserEntity objectFromJSONObject:dic];
                    [sharedInfoArray addObject:temp];
                }
            }
            block(status,msg,boxerInfoArray,sharedInfoArray);
        }else{
            block(status,msg,nil,nil);
        }
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil,nil);
    }];
}

// 零食盒子订单列表
+ (void)fetOrderListWithUid:(NSNumber *)uid
                      boxId:(NSNumber *)box_id
                    batchNo:(NSNumber *)batch_no
             withOrderItems:(BOOL)with_order_items
              withOrderPays:(BOOL)with_order_pays
                   complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *orders))block{
    
    NSDictionary *prama = @{
                            @"uid":uid,
                            @"box_id":box_id,
                            @"batch_no":batch_no,
                            @"with_order_items":@(with_order_items),
                            @"with_order_pays":@(with_order_pays)
                            };
    [HXStoreWebService getRequest:HXS_BOX_ORDER_LIST
                parameters:prama
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       
                       if(kHXSNoError == status){
                           NSMutableArray *resultArr = [NSMutableArray array];
                           NSArray *arr = [data objectForKey:@"orders"];
                           if(arr){
                               for(NSDictionary *dic in arr){
                                   HXSBoxOrderModel *temp = [HXSBoxOrderModel objectFromJSONObject:dic];
                                   [resultArr addObject:temp];
                               }
                           }
                           block(status,msg,resultArr);
                       }else{
                           block(status,msg,nil);
                       }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

// 零食盒子订单详情
+ (void)fetBoxOrderInfoWithOrderId:(NSString *)order_id
                    withOrderItems:(BOOL)with_order_items
                     withOrderPays:(BOOL)with_order_pays
                          complete:(void (^)(HXSErrorCode code, NSString *message, HXSBoxOrderModel *boxOrderModel))block{
    
    NSDictionary *prama = @{
                            @"order_id":order_id,
                            @"with_order_items":@(with_order_items),
                            @"with_order_pays":@(with_order_pays)
                            };
    [HXStoreWebService getRequest:HXS_BOX_ORDER_INFO
                parameters:prama
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(kHXSNoError == status){
            HXSBoxOrderModel *temp = [HXSBoxOrderModel objectFromJSONObject:data];
            block(status,msg,temp);
        }else{
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
 }


// 转让零食盒子
+ (void)tansferBoxWithBoxId:(NSNumber *)boxId
                     userId:(NSNumber *)uid
                   complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *dic))block{
    NSDictionary *param = @{
                            @"box_id":boxId,
                            @"uid":uid
                            };
    [HXStoreWebService postRequest:HXS_BOX_TRANSFER parameters:param progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(kHXSNoError == status){
            block(status,msg,data);
        }else{
            block(status,msg,nil);
        }
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

// 零食盒子商品列表
+ (void)fetBoxItemListWithBoxId:(NSNumber *)boxId
                        batchNo:(NSNumber *)batchNo
                       complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *items))block{
    
    NSDictionary *prama = @{
                            @"box_id":boxId,
                            @"batch_no":batchNo
                            };
    
    [HXStoreWebService getRequest:HXS_BOX_ITEM_LIST
                parameters:prama
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(kHXSNoError == status){
                           NSMutableArray *resultArray = [NSMutableArray array];
                           NSArray *arr = [data objectForKey:@"items"];
                           if(arr){
                               for(NSDictionary *dic in arr){
                                   HXSBoxOrderItemModel *temp = [HXSBoxOrderItemModel objectFromJSONObject:dic];
                                   [resultArray addObject:temp];
                               }
                           }
                           block(status,msg,resultArray);
                       }else{
                           block(status,msg,nil);
                       }
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

// 本期初始零食清单
+ (void)fetConsumInitListWithBoxId:(NSNumber *)box_id
                           batchNo:(NSNumber *)batch_no
                          complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *items ,NSNumber *quantity))block{
    
    NSDictionary *prama = @{
                            @"box_id":box_id,
                            @"batch_no":batch_no
                            };
    [HXStoreWebService getRequest:HXS_BOX_CONSUM_INIT_LIST parameters:prama progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(kHXSNoError == status){
            
            NSMutableArray *resultArray = [NSMutableArray array];
            NSArray *arr = [data objectForKey:@"items"];
            
            for(NSDictionary *dic in arr){
                HXSDormItem *temp = [[HXSDormItem alloc]init];
                temp.name = [dic objectForKey:@"name"];
                temp.price = [dic objectForKey:@"price"];
                temp.quantity = [dic objectForKey:@"quantity"];
                [resultArray addObject:temp];
            }
            
            NSNumber *quantityNum = [data objectForKey:@"quantity"];
            block(status,msg,resultArray,quantityNum);
            
        }else{
            block(status,msg,nil,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil,nil);
    }];

}

// 获取消费清单
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
                                            ))block{
    NSDictionary *prama = @{
                            @"box_id":box_id,
                            @"batch_no":batch_no
                            };
    [HXStoreWebService getRequest:HXS_BOX_CONSUM_LIST
                parameters:prama
                progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(kHXSNoError == status){
                           
                           NSMutableArray *resultArray = [NSMutableArray array];
                           NSArray *arr = [data objectForKey:@"not_paid_items"];
                           if(arr){
                               for(NSDictionary *dic in arr){
                                   HXSDormItem *temp = [[HXSDormItem alloc]init];
                                   temp.name = [dic objectForKey:@"name"];
                                   temp.price = [dic objectForKey:@"price"];
                                   temp.quantity = [dic objectForKey:@"quantity"];
                                   [resultArray addObject:temp];
                               }
                           }
                           NSNumber *notPaidAmountNum = [data objectForKey:@"not_paid_amount"];
                           NSNumber *untakeQuantityNum = [data objectForKey:@"untake_quantity"];
                           NSNumber *amountNum = [data objectForKey:@"amount"];
                           NSNumber *billStatusNum = [data objectForKey:@"bill_status"];
                           NSString *orderIdStr = [data objectForKey:@"order_id"];
                           NSNumber *createTime = [data objectForKey:@"create_time"];
                           HXSOrderInfo *order = [[HXSOrderInfo alloc]init];
                           order.order_sn = orderIdStr;
                           order.order_amount = amountNum;
                           order.typeName = @"零食盒";
                           order.type = 19;
                           order.add_time = createTime;
                           block(status,msg,resultArray,notPaidAmountNum,untakeQuantityNum,billStatusNum,order);
                       
                       }else{
                           block(status,msg,nil,nil,nil,nil,nil);
                       }
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil,nil,nil,nil,nil);
    }];
}

// 已支付未领取零食列表
+ (void)fetBoxConsumUnTakeListWithBoxId:(NSNumber *)box_id
                             batchNo:(NSNumber *)batch_no
                               complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *items ,NSNumber *quantity))block{
    
    NSDictionary *prama = @{
                            @"box_id":box_id,
                            @"batch_no":batch_no
                            };
    [HXStoreWebService getRequest:HXS_BOX_CONSUM_UNTAKE_LIST parameters:prama progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(kHXSNoError == status){
            
            NSMutableArray *resultArray = [NSMutableArray array];
            NSArray *arr = [data objectForKey:@"items"];
            
            for(NSDictionary *dic in arr){
                HXSDormItem *temp = [[HXSDormItem alloc]init];
                temp.name = [dic objectForKey:@"name"];
                temp.price = [dic objectForKey:@"price"];
                temp.quantity = [dic objectForKey:@"quantity"];
                [resultArray addObject:temp];
            }
            
            NSNumber *quantityNum = [data objectForKey:@"quantity"];
            block(status,msg,resultArray,quantityNum);
            
        }else{
            block(status,msg,nil,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil,nil);
    }];

}

//  零食盒下单

+ (void)createBoxOrderWithItemList:(NSArray *)itemList
                             boxId:(NSNumber *)boxIdNum
                          complete:(void (^)(HXSErrorCode code,NSString *message,HXSBoxOrderModel *orderInfo))block;
{
    NSMutableArray *itemsArray = [NSMutableArray array];
    
    for (HXSBoxOrderItemModel *itemModel in itemList)
    {
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
        [itemDict setValue:itemModel.quantityNum forKey:@"quantity"];
        [itemDict setValue:itemModel.productIdStr forKey:@"product_id"];
        [itemsArray addObject:itemDict];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:itemsArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:boxIdNum forKey:@"box_id"];
    [dict setValue:jsonStr forKey:@"items"];
    
    [HXStoreWebService postRequest:HXS_BOX_ORDER_CREATE
                        parameters:dict
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data)
    {
        HXSBoxOrderModel *temp = [HXSBoxOrderModel objectFromJSONObject:data];
        block(status, msg,temp);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        block(status, msg, nil);
    }];
    
}

// 分享者退出盒子
+ (void)sharerQuitBoxWithUid:(NSNumber *)uid boxId:(NSNumber *)boxId complete:(void (^)(HXSErrorCode code,NSString *message,NSDictionary *dic))block{
    
    NSDictionary *prama = @{@"uid":uid,@"box_id":boxId};
    [HXStoreWebService postRequest:HXS_BOX_SHARED_QUIT parameters:prama progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];
}

// 移除共享人
+ (void)boxRemoveSharerWithBoxId:(NSNumber *)boxId
                             uid:(NSNumber *)uid
                        complete:(void (^)(HXSErrorCode code,NSString *message,NSDictionary *dic))block{
    NSDictionary *prama = @{@"box_id":boxId,@"uid":uid};
    [HXStoreWebService postRequest:HXS_BOX_SHARED_REMOVE parameters:prama progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];
}


// 获取消息列表
+ (void)fetchBoxMessageListWithMessageStatus:(NSNumber *)message_status
                                        size:(NSNumber *)size
                                        page:(NSNumber *)page
                                    complete:(void (^)(HXSErrorCode code,NSString *message,NSArray *messageList))block{
    NSDictionary *prama = @{
                            @"message_status":message_status,
                            @"num_per_page":size,
                            @"page":page,
                            @"type":@(155)
                            };
    [HXStoreWebService getRequest:HXS_BOX_USER_MESSAGE_LIST
                       parameters:prama
                         progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                             if(kHXSNoError == status){
                                 
                                 NSMutableArray *resultArray = [NSMutableArray array];
                                 NSArray *arr = [data objectForKey:@"list"];
                                 if(arr){
                                     for(NSDictionary *dic in arr){
                                         HXSBoxMessageModel *temp = [HXSBoxMessageModel objectFromJSONObject:dic];
                                         [resultArray addObject:temp];
                                     }
                                 }
                                 block(status,msg,resultArray);
                             }else{
                                 block(status,msg,nil);
                             }
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

// 盒子转让处理
+ (void)handleBoxTransterWithBoxId:(NSNumber *)boxId
                               uid:(NSNumber *)uid
                            action:(NSNumber *)action
                         messageId:(NSString *)message_id
                     boxUserEntity:(HXSBoxUserEntity *)sharedInfo
                          complete:(void (^)(HXSErrorCode code,NSString *message,NSDictionary *dic))block{
    
    NSDictionary *prama = @{
                            @"box_id":boxId,
                            @"uid":uid,
                            @"action":action,
                            @"message_id":message_id,
                            @"username":sharedInfo.unameStr,
                            @"phone":sharedInfo.phoneStr,
                            @"dormentry_id":sharedInfo.dormentryIdNum,
                            @"room":sharedInfo.roomStr,
                            @"gender":sharedInfo.genderNum,
                            @"enrollment_year":sharedInfo.enrollmentYearNum
                            };
    [HXStoreWebService postRequest:HXS_BOX_TRANSTER_HANDLE
                        parameters:prama progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];
}

// 被共享人消息处理
+ (void)hanleBoxSharedWithBoxId:(NSNumber *)boxId
                            uid:(NSNumber *)uid
                         action:(NSNumber *)action
                      messageId:(NSString *)message_id
                       complete:(void (^)(HXSErrorCode code,NSString *message,NSDictionary *dic))block{
    NSDictionary *prama = @{
                            @"box_id":boxId,
                            @"uid":uid,
                            @"action":action,
                            @"message_id":message_id
                            };
    [HXStoreWebService postRequest:HXS_BOX_SHARED_HANDLE
                        parameters:prama progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];
}

// 消息已读
+ (void)setMessageReadedWithMessageId:(NSString *)messageId
                             complete:(void (^)(HXSErrorCode code,NSString *message,NSDictionary *dic))block{
    
    NSDictionary *prama = @{
                            @"message_id":messageId
                            };
    [HXStoreWebService postRequest:HXS_BOX_MESSAGR_READ parameters:prama progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];
 }


// 更加uid获取分享者信息
+ (void)fetchBoxSharedInfoWithUid:(NSNumber *)uid
                         complete:(void (^)(HXSErrorCode code,NSString *message,HXSBoxUserEntity *boxShare))block{
    NSDictionary *param = @{
                            @"uid":uid
                            };
    [HXStoreWebService getRequest:HXS_BOX_SHARED_INFO
                       parameters:param
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if(kHXSNoError == status){
                                  HXSBoxUserEntity *temp = [HXSBoxUserEntity objectFromJSONObject:data];
                                  block(status,msg,temp);
                              }else{
                                  block(status,msg,nil);
                              }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

@end

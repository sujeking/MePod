//
//  HXSPrintModel.m
//  store
//
//  Created by 格格 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintModel.h"


@implementation HXSPrintModel

// 云印店 订单列表
+ (void)getPrintOrderListWithPage:(int)page complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * orders)) block{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:@(page) forKey:@"page"];
    [dic setObject:@(10) forKey:@"num_per_page"];
    [HXStoreWebService getRequest:HXS_PRINT_ORDER_LIST
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           NSMutableArray * orders = [NSMutableArray array];
                           
                           if(DIC_HAS_ARRAY(data, @"orders")) {

                               for(NSDictionary * dic in [data objectForKey:@"orders"]) {
                                   if((NSNull *)dic == [NSNull null]) {
                                       continue;
                                   }
                                   HXSPrintOrderInfo *printOrderInfo = [HXSPrintOrderInfo objectFromJSONObject:dic];
                                   [orders addObject:printOrderInfo];
                               }
                           }
                           block(kHXSNoError, msg, orders);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

// 云印店 订单详情
+ (void)getPrintOrderDetialWithOrderSn:(NSString *)orderSn complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintOrderInfo *printOrder))block{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:orderSn forKey:@"order_sn"];
    
    [HXStoreWebService getRequest:HXS_PRINT_ORDER_INFO
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        DLog(@"-------------- 云印店订单详情: %@",data);
        if(status == kHXSNoError) {
            
            HXSPrintOrderInfo *printOrderInfo = [HXSPrintOrderInfo objectFromJSONObject:data];
            block(kHXSNoError, msg, printOrderInfo);
        } else {
            block(status, msg, nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status, msg, nil);
    }];
}

// 云印店 取消订单
+ (void)cancelPrintOrderWithOrderSn:(NSString *)orderSn complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *info))block{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:orderSn forKey:@"order_sn"];
    
    [HXStoreWebService postRequest:HXS_PRINT_ORDER_CANCEL
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        DLog(@"-------------- 云印店订单取消: %@",data);
                        block(status, msg, nil);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

// 云印店 订单更改支付方式
+ (void)changePrintOrderPayType:(NSString *)orderSn
                      complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:orderSn forKey:@"order_sn"];
    
    [HXStoreWebService postRequest:@"drink/order/online2cash"
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        DLog(@"-------------- 云印店修改订单支付类型: %@",data);
                        block(status, msg, nil);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

+ (void)createOrCalculatePrintOrderWithPrintCartEntity:(HXSPrintCartEntity *)printCartEntity
                                                shopId:(NSNumber *)shopid
                                                openAd:(NSNumber *)openAd
                                              complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintCartEntity *printCartEntity))block{
    
    NSMutableDictionary *prama = [NSMutableDictionary dictionaryWithDictionary:[printCartEntity printCartDictionary]];
    [prama setObject:shopid forKey:@"shop_id"];
    [prama setObject:openAd forKey:@"open_ad"];
    [HXStoreWebService postRequest:HXS_PRINT_CART_CREATE
                 parameters:prama
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        DLog(@"------云印店计算订单价格 创建购物车 %@",data);
                        if(kHXSNoError == status){
                            HXSPrintCartEntity *cartEntity = [HXSPrintCartEntity objectFromJSONObject:data];
                            block(status,msg,cartEntity);
                        } else {
                            block(status,msg,nil);
                        }
                        
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status,msg,nil);
                    }];
}

// 云印店 下单
+ (void)createPrintOrderWithPhone:(NSString *)phone
                          address:(NSString *)address
                           remark:(NSString *)remark
                         pay_type:(NSNumber *)pay_type
                     dormentry_id:(NSNumber *)dormentry_id
                          shop_id:(NSNumber *)shop_id
                          open_ad:(NSNumber *)open_ad
                 printOrderEntity:(HXSPrintCartEntity *)printCartEntity
                           apiStr:(NSString *)apiStr
                         complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintOrderInfo *orderInfo))block;{
    
    NSMutableDictionary *prama = [NSMutableDictionary dictionaryWithDictionary:[printCartEntity printCartDictionary]];
    [prama setObject:phone forKey:@"phone"];
    [prama setObject:address forKey:@"address"];
    [prama setObject:remark forKey:@"remark"];
    [prama setObject:pay_type forKey:@"pay_type"];
    [prama setObject:dormentry_id forKey:@"dormentry_id"];
    [prama setObject:shop_id forKey:@"shop_id"];
    [prama setObject:open_ad forKey:@"open_ad"];
    [prama setObject:@(3) forKey:@"source"];
    
    
    [HXStoreWebService postRequest:apiStr
                 parameters:prama
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(status == kHXSNoError) {
            
            HXSPrintOrderInfo *printOrderInfo = [HXSPrintOrderInfo objectFromJSONObject:data];
            
            block(kHXSNoError, msg, printOrderInfo);
            
        } else {
            block(status, msg, nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

- (NSURLSessionDataTask *)uploadTheDocument:(HXSPrintDownloadsObjectEntity *)entity
                 complete:(void (^)(HXSErrorCode code, NSString *message, HXSMyPrintOrderItem *orderItem))block
{
    NSMutableArray *formDataArray = [[NSMutableArray alloc]init];
    [formDataArray addObject:entity.fileData];
    [formDataArray addObject:[entity.archiveDocNameStr stringByDeletingPathExtension]];
    [formDataArray addObject:entity.archiveDocNameStr];
    [formDataArray addObject:entity.mimeTypeStr];
    
    NSURLSessionDataTask *task = [HXStoreWebService uploadRequest:HXS_PRINT_UPLOAD
                 parameters:nil
              formDataArray:formDataArray
                    progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (kHXSNoError != status) {
                            block(status, msg, nil);
                            return ;
                        }
                        HXSMyPrintOrderItem *orderItemEntitiy = [self createPrintOrderEntityWithData:data];
                        block(status, msg, orderItemEntitiy);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status,msg,nil);
                    }];
    return task;
}

+ (NSArray<HXSMainPrintTypeEntity *> *)createTheMainPrintTypeArray
{
    HXSMainPrintTypeEntity *documentPrintTypeEntity = [[HXSMainPrintTypeEntity alloc]init];
    [documentPrintTypeEntity setTypeName:@"打印文档"];
    [documentPrintTypeEntity setImageName:@"img_print_dayinwendang"];
    [documentPrintTypeEntity setPrintType:kHXSMainPrintTypeDocument];
    
    HXSMainPrintTypeEntity *photoPrintTypeEntity = [[HXSMainPrintTypeEntity alloc]init];
    [photoPrintTypeEntity setTypeName:@"打印照片"];
    [photoPrintTypeEntity setImageName:@"img_print_dayinzhaopian"];
    [photoPrintTypeEntity setPrintType:kHXSMainPrintTypePhoto];
    
    HXSMainPrintTypeEntity *scanPrintTypeEntity = [[HXSMainPrintTypeEntity alloc]init];
    [scanPrintTypeEntity setTypeName:@"扫描"];
    [scanPrintTypeEntity setImageName:@"img_print_saomiao"];
    [scanPrintTypeEntity setPrintType:kHXSMainPrintTypeScan];
    
    HXSMainPrintTypeEntity *copyPrintTypeEntity = [[HXSMainPrintTypeEntity alloc]init];
    [copyPrintTypeEntity setTypeName:@"复印"];
    [copyPrintTypeEntity setImageName:@"img_print_fuyin"];
    [copyPrintTypeEntity setPrintType:kHXSMainPrintTypeCopy];
    
    NSArray *array = [NSArray arrayWithObjects:documentPrintTypeEntity,
                                              photoPrintTypeEntity,
                                              scanPrintTypeEntity,
                                              copyPrintTypeEntity,nil];
    
    return array;
}


#pragma mark - private method

- (HXSMyPrintOrderItem *)createPrintOrderEntityWithData:(NSDictionary *)dic
{
    return [HXSMyPrintOrderItem objectFromJSONObject:dic];
}


@end

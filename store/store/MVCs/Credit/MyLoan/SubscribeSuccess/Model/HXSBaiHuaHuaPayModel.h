//
//  HXSBaiHuaHuaPayModel.h
//  store
//
//  Created by ArthurWang on 15/8/17.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSBaiHuaHuaPayModel : NSObject

/*
 *order_id: 订单id
 *order_type:  订单类型(0，便利店订单，4，夜猫店订单, 5,盒子)
 *cost_amount: 消费金额
 *title: 描述
 *notify_url：通知的url
 *pay_password： 支付密码
 */
- (void)payCreditCardPayment:(NSDictionary *)paymentDic
                   complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *paymentInfo))block;

@end

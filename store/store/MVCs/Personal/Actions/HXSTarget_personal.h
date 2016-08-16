//
//  HXSTarget_personal.h
//  store
//
//  Created by ArthurWang on 16/6/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSTarget_personal : NSObject

/** 跳转订单列表页面 */
- (UIViewController *)Action_orderList:(NSDictionary *)paramsDic;

/** 跳转优惠券页面 */
- (UIViewController *)Action_coupon:(NSDictionary *)paramsDic;

/** 跳转忘记密码页面 */
- (UIViewController *)Action_forgotPassword:(NSDictionary *)paramsDic;

/** 跳转地址薄页面 */
// messageBody=xxxx
- (UIViewController *)Action_addressBook:(NSDictionary *)paramsDic;

/** 是否登录 */
- (NSNumber *)Action_isLoggedin:(NSDictionary *)paramsDic;

/** 选中TabBar */
// index=xxxx
- (NSNumber *)Action_tabSelectedIndex:(NSDictionary *)paramsDic;

@end

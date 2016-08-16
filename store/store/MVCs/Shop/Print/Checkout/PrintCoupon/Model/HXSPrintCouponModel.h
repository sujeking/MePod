//
//  HXSPrintCouponModel.h
//  store
//
//  Created by 格格 on 16/5/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSPrintCouponModel : NSObject

/**
 *  打印获取优惠券接口
 *
 *  @param type   优惠券类型0:通用 ，1:相片  2:文稿，（如果不传则默认为2）
 *  @param amount 如果isAll传no,需要传这个字段，获取满足使用金额门槛的优惠券
 *  @param isAll  是否全部优惠券  //yes:是  no:否
 *  @param block
 */
+ (void)getPrintCouponpicListWithType:(NSNumber *)type
                               amount:(NSNumber *)amount
                                isAll:(BOOL)isAll
                             complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *printCoupons))block;

@end

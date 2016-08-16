//
//  HXSCreateOrderParams.h
//  store
//
//  Created by ArthurWang on 16/1/20.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCreateOrderParams : NSObject

/**楼栋id*/
@property (nonatomic, strong) NSNumber *dormentryIDIntNum;
/**店铺id*/
@property (nonatomic, strong) NSNumber *shopIDIntNum;
/**2 立即配送 3 预定配送*/
@property (nonatomic, strong) NSNumber *deliveryTypeIntNum;
/**期望配送时间段开始时间的时间戳*/
@property (nonatomic, strong) NSNumber *expectStartTimeIntNum;
/**期望配送时间段结束时间的时间戳*/
@property (nonatomic, strong) NSNumber *expectEndTimeIntNum;
/**寝室号*/
@property (nonatomic, strong) NSString *dormitoryStr;
/**手机号*/
@property (nonatomic, strong) NSString *phoneStr;
/**支付方式, 0表示现金支付, 1表示支付宝，2表示微信支付*/
@property (nonatomic, strong) NSNumber *payTypeIntNum;
/**优惠券（可选）*/
@property (nonatomic, strong) NSString *couponCodeStr;
/**验证码（可选）下单失败返回特定错误时要验证*/
@property (nonatomic, strong) NSString *verificationCodeStr;
/**备注*/
@property (nonatomic, strong) NSString *remarkStr;

@end

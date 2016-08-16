//
//  HXSConfirmOrderEntity.h
//  store
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSAddressEntity.h"
#import "HXSDigitalMobileInstallmentDetailEntity.h"
#import "HXSCoupon.h"


@interface HXSConfirmOrderEntity : NSObject

@property (strong, nonatomic) HXSAddressEntity *addressInfo;
@property (strong, nonatomic) HXSDigitalMobileInstallmentDetailEntity *installmentInfo;
@property (strong, nonatomic) HXSCoupon *coupon;

@property (strong, nonatomic) NSString *goodsName;
@property (strong, nonatomic) NSNumber *goodsId;
@property (strong, nonatomic) NSNumber *goodsPrice;
@property (strong, nonatomic) NSString *goodsImageUrl;
@property (strong, nonatomic) NSNumber *goodsNum;
@property (strong, nonatomic) NSNumber *total;
@property (strong, nonatomic) NSString *goodsProperty;
@property (strong, nonatomic) NSString *goodsService;
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) NSNumber *carriage;
@property (strong, nonatomic) NSNumber *isInstallment;

/*
 * 获取最终总价，减去优惠券后的总价
 */
- (NSNumber *)getToTalAccount;
/*
 * 获取首付
 */
- (NSNumber *)getDownPayment;
- (NSMutableDictionary *)getDictionary;
@end

//
//  HXSDeliveryEntity.h
//  store
//
//  Created by 格格 on 16/3/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HXSDeliveryTime
@end

@interface HXSDeliveryTime : HXBaseJSONModel

/** 配送方式 2立即送出  3预订  (send_type = 2时才有) */
@property(nonatomic,strong) NSNumber *typeIntNum;
/** 显示字段 */
@property(nonatomic,strong) NSString *nameStr;
/** 开始时间 */
@property(nonatomic,strong) NSNumber *expectStartTimeLongNum;
/** 结束时间 */
@property(nonatomic,strong) NSNumber *expectEndTimeLongNum;

@end

@interface HXSDeliveryEntity : HXBaseJSONModel

/** 发货方式 1店长配送  2.上门自取 */
@property(nonatomic,strong) NSNumber *sendTypeIntNum;
/** 配送费 */
@property(nonatomic,strong) NSNumber *deliveryAmountDoubleNum;
/** 减费送费金额门槛 */
@property(nonatomic,strong) NSNumber *freeDeliveryAmountDoubleNum;
/** 配送方式的说明 */
@property(nonatomic,strong) NSString *descriptionStr;
/** 取货地址 */
@property(nonatomic,strong) NSString *pickAddressStr;
/** 取货时间 */
@property(nonatomic,strong) NSString *pickTimeStr;
/** 店长配送时间数组 */
@property(nonatomic,strong) NSMutableArray<HXSDeliveryTime> *deliveryTimesMutArr;


@end

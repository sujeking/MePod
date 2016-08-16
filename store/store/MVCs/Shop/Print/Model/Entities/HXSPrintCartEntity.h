//
//  HXSPrintCartEntity.h
//  store
//
//  Created by 格格 on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSMyPrintOrderItem.h"

@interface HXSPrintCartEntity : HXBaseJSONModel

/**总价＝打印文档价格＋配送价格－优惠券金额*/
@property(nonatomic, strong) NSNumber *totalAmountDoubleNum;
/**配送价格*/
@property(nonatomic, strong) NSNumber *deliveryAmountDoubleNum;
/**文档打印价格*/
@property(nonatomic, strong) NSNumber *documentAmountDoubleNum;

//下为上传的购物车信息

/**优惠券编码*/
@property (nonatomic, strong) NSString *couponCodeStr;
/**优惠券折扣*/
@property (nonatomic, strong) NSNumber *couponDiscountDoubleNum;
/**取货方式*/
@property (nonatomic, strong) NSNumber *sendTypeIntNum;
/**配送方式*/
@property (nonatomic, strong) NSNumber *deliveryTypeIntNum;
/**配送开始时间  店长配送、预约配送时必传*/
@property (nonatomic, strong) NSNumber *expectStartTimeLongNum;
/**配送结束时间  店长配送、预约配送时必传*/
@property (nonatomic, strong) NSNumber *expectEndTimeLongNum;
/**配送时间显示的字符串(包括立即送出)*/
@property (nonatomic, strong) NSString *expectTimeNameStr;
/**取货地址*/
@property (nonatomic, strong) NSString *pickAddressStr;
/**取货时间*/
@property (nonatomic, strong) NSString *pickTimeStr;
/**店铺id*/
@property (nonatomic, strong) NSNumber *shopIdIntNum;
/**是否免费打印 0不开启  1开启免费打印*/
@property (nonatomic, strong) NSNumber *openAdIntNum;
/** 打印总份数 */
@property (nonatomic, strong) NSNumber *printIntNum;
/** 打印总页数 */
@property (nonatomic, strong) NSNumber *printPagesIntNum;
/** 单类型：0:图片，1:文档 */
@property (nonatomic, strong) NSNumber *docTypeNum;
/** 福利纸总价 */
@property (nonatomic, strong) NSNumber *freeAmountDoubleNum;
/**订单免费打印的张数*/
@property (nonatomic, strong) NSNumber *adPageNumIntNum;
/**是否有优惠券*/
@property(nonatomic,strong) NSNumber *couponHadNum;
/**打印文档列表*/
@property (nonatomic, strong) NSMutableArray<HXSMyPrintOrderItem> *itemsArray;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

- (NSDictionary *)printCartDictionary;

@end

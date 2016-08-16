//
//  HXSShopEntity.h
//  store
//
//  Created by ArthurWang on 16/1/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

/**
 *  促销活动
 */

@protocol HXSPromotionsEntity 
@end
@interface HXSPromotionsEntity : HXBaseJSONModel

@property (nonatomic, strong) NSString *promotionImageStr;       //活动图标
@property (nonatomic, strong) NSNumber *promotionIdNum;          //活动ID
@property (nonatomic, strong) NSString *promotionNameStr;        //活动名称
@property (nonatomic, strong) NSString *promotionColorStr;       //活动标题颜色

@end;


@interface HXSShopEntity : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *shopIDIntNum;
@property (nonatomic, strong) NSNumber *statusIntNum;                   // 0表示休息中，1表示营业中，2表示可预订
@property (nonatomic, strong) NSString *dormNameStr;                    // 楼主的名字
@property (nonatomic, strong) NSString *shopNameStr;                    // 店铺名称
@property (nonatomic, strong) NSString *shopAddressStr;                 // "D5栋3层"
@property (nonatomic, strong) NSNumber *itemNumIntNum;                  // 108
@property (nonatomic, strong) NSString *addressStr;                     // "东区D5"
@property (nonatomic, strong) NSString *noticeStr;                      // 如果没有则是空字符串
@property (nonatomic, strong) NSNumber *minAmountFloatNum;              // 满5元起送
@property (nonatomic, strong) NSNumber *freeDeliveryAmountFloatNum;     // 满5元免配送费
@property (nonatomic, strong) NSNumber *deliveryFeeFloatNum;            // 不满5元配送费5元
@property (nonatomic, strong) NSNumber *shopTypeIntNum;                 // 0夜猫店  1饮品店  2打印店 3云超市 4水果店
@property (nonatomic, strong) NSString *shopTypeImageUrlStr;                 // 店铺类型的小图标
@property (nonatomic, strong) NSNumber *deliveryStatusIntNum;           // 0 送到寝室 1 送到楼下 2 只限自取
@property (nonatomic, strong) NSString *deliveryTimeStr;                // 最快11:20送达
@property (nonatomic, strong) NSString *shopLogoURLStr;
@property (nonatomic, strong) NSString *signaturesStr;                   // 个性签名
/** 云超市营业时间 */
@property (nonatomic, copy) NSString *businesHoursStr;                   // 便利店&云超市用该字段

@property (nonatomic, strong) NSArray<HXSPromotionsEntity> *promotionsArr;

// temp status
@property (nonatomic, assign) BOOL hasExtended;  // default is NO


+ (instancetype)createShopEntiryWithData:(NSDictionary *)shopDic;

- (CGFloat)getNoticeCellHight;


@end

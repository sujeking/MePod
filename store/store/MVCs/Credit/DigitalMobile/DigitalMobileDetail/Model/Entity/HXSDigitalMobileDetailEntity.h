//
//  HXSDigitalMobileDetailEntity.h
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HXSDigitalMobileDetailCommentEntity
@end

@interface HXSDigitalMobileDetailCommentEntity : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *commentIDIntNum;
/** 用户名 */
@property (nonatomic, strong) NSString *userNameStr;
/** 用户头像 */
@property (nonatomic, strong) NSString *userPortraitUrlStr;
/** 评论内容*/
@property (nonatomic, strong) NSString *contentStr;
/** 评论时间时间戳 */
@property (nonatomic, strong) NSNumber *commentTimeIntNum;
/** 评论地点 */
@property (nonatomic, strong) NSString *siteNameStr;

+ (instancetype)createCommentEntityWithDic:(NSDictionary *)dic;

@end


@protocol HXSDigitalMobileDetailPromotionEntity
@end

@interface HXSDigitalMobileDetailPromotionEntity : HXBaseJSONModel

/** 推销图标 */
@property (nonatomic, strong) NSString *promotionImageURLStr;
/** 推销文案 */
@property (nonatomic, strong) NSString *promotionNameStr;

@end


@protocol HXSDigitalMobileDetailImageEntity
@end

@interface HXSDigitalMobileDetailImageEntity : HXBaseJSONModel

/** 图片URL */
@property (nonatomic, strong) NSString *imageURLStr;
/** 图片ID  */
@property (nonatomic, strong) NSNumber *imageIDIntNum;

@end

@interface HXSDigitalMobileDetailEntity : HXBaseJSONModel

/** 商品名 */
@property (nonatomic, strong) NSString *nameStr;
/** 组合商品ID */
@property (nonatomic, strong) NSNumber *itemIDIntNum;
/** 供货商 */
@property (nonatomic, strong) NSString *supplierStr;
/** 价格  "3999～4999" */
@property (nonatomic, strong) NSString *priceStr;
/** 评分 */
@property (nonatomic, strong) NSNumber *averageScoreFloatNum;
/** 图文详情 */
@property (nonatomic, strong) NSString *introductionHtmlStr;

/** 图片 */
@property (nonatomic, strong) NSArray<HXSDigitalMobileDetailImageEntity> *imagesArr;
/** 推荐 */
@property (nonatomic, strong) NSArray<HXSDigitalMobileDetailPromotionEntity> *promotionsArr;
/** 评论 */
@property (nonatomic, strong) NSArray<HXSDigitalMobileDetailCommentEntity> *commentsArr;


+ (instancetype)createMobileDetailEntityWithDic:(NSDictionary *)dic;

@end

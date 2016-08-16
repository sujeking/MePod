//
//  HXSCartsItem.h
//  store
//
//  Created by  黎明 on 16/3/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCartsItem : NSObject

@property (nonatomic, strong) NSNumber *amountNum;
@property (nonatomic, strong) NSNumber *dormentryIdNum;
@property (nonatomic, strong) NSString *errorInfoStr;
@property (nonatomic, strong) NSString *imageBigStr;
@property (nonatomic, strong) NSString *imageMediumStr;
@property (nonatomic, strong) NSString *imageSmallStr;
@property (nonatomic, strong) NSNumber *itemIdNum;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSNumber *ownerUserIdNum;
@property (nonatomic, strong) NSNumber *priceNum;
@property (nonatomic, strong) NSNumber *quantityNum;
@property (nonatomic, strong) NSNumber *ridNum;
@property (nonatomic, strong) NSNumber *sessionNumberNum;
@property (nonatomic, strong) NSNumber *orderNum;
/**原始价*/
@property (nonatomic, strong) NSNumber *OriginPrice;
+ (id)initWithDict:(NSDictionary *)dict;
@end

//
//  HXSDrinkCartEntity.h
//  store
//
//  Created by ArthurWang on 15/11/24.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSDrinkCartItemEntity : NSObject

@property (nonatomic, strong) NSNumber *amountNum;
@property (nonatomic, strong) NSString *imageMediumStr;
@property (nonatomic, strong) NSNumber *ridNum;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSNumber *priceNum;
@property (nonatomic, strong) NSNumber *quantityNum;
@property (nonatomic, strong) NSString *errorInfoStr;

@end


@interface HXSDrinkCartEntity : NSObject

@property (nonatomic, strong) NSString *couponCodeStr;
@property (nonatomic, strong) NSNumber *couponDiscountNum;
@property (nonatomic, strong) NSString *errorInfoStr;
@property (nonatomic, strong) NSNumber *itemAmountNum;
@property (nonatomic, strong) NSNumber *itemNum;
@property (nonatomic, strong) NSString *promotionTipStr;
@property (nonatomic, strong) NSNumber *originAmountDoubleNum;

@property (nonatomic, strong) NSArray  *itemsArr;

@end

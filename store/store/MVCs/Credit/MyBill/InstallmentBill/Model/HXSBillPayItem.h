//
//  HXSBillPayItem.h
//  store
//
//  Created by hudezhi on 15/8/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSBillPayGoodsItem : NSObject

@property (nonatomic) double amount;
@property (nonatomic) NSString *goodsDescription;
@property (nonatomic) NSString *payDate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

// ================== HXSBillPayItem ==================

@interface HXSBillPayItem : NSObject

@property (nonatomic) NSString *billDate;
@property (nonatomic) double billAmount;
@property (nonatomic) BOOL isOverTime;
@property (nonatomic) NSString *serviceFeeDescription;
@property (nonatomic) NSArray *goodsList;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

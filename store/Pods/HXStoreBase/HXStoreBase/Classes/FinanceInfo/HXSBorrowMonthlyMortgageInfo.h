//
//  HXSBorrowMonthlyMortgageResponse.h
//  store
//
//  Created by hudezhi on 15/8/3.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSInstallmentSelectEntity : NSObject<NSCoding>

@property (nonatomic, strong) NSNumber *installmentNum; //分期期数
@property (nonatomic, strong) NSNumber *installmentAmountNum;  //月供金额

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface HXSBorrowMonthlyMortgageInfo : NSObject

@property (nonatomic, strong) NSMutableArray *installmentMArr;

- (instancetype)initWithDictionary:(NSDictionary *)response;

@end

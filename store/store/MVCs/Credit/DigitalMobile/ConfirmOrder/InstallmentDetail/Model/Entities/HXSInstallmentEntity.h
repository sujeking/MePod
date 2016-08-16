//
//  HXSInstallmentEntity.h
//  store
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSInstallmentEntity : NSObject

@property (strong, nonatomic) NSNumber *downpayment;
@property (strong, nonatomic) NSNumber *installmentMoney;
@property (strong, nonatomic) NSArray *installmentList;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@interface HXSInstallmentItemEntity : NSObject

@property (strong, nonatomic) NSNumber *installmentNum;
@property (strong, nonatomic) NSNumber *installmentMoney;
@property (strong, nonatomic) NSNumber *chargeMoney;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

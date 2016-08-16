//
//  HXSAccountBillCategoryItem.h
//  store
//
//  Created by hudezhi on 15/8/15.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSAccountBillCategoryItem : NSObject

@property (nonatomic) NSString* billDate;
@property (nonatomic) NSString *categoryName;
@property (nonatomic) NSInteger categoryCode;
@property (nonatomic, assign) double amount;
@property (nonatomic) NSString *bankTailNum;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

/*
 * ================================================================
 */

@interface HXSAccountBillCategoryInfo : NSObject

@property (nonatomic) NSArray *billCategoryList;
@property (nonatomic) NSString *tailNumber;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

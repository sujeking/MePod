//
//  HXSBoxCart.h
//  store
//
//  Created by ArthurWang on 15/8/19.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HXSBox, HXSBoxCartItem;

@interface HXSBoxCart : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * boxID;
@property (nonatomic, retain) NSString * couponCode;
@property (nonatomic, retain) NSNumber * couponDiscount;
@property (nonatomic, retain) NSNumber * foodAmount;
@property (nonatomic, retain) NSNumber * totalNum;
@property (nonatomic, retain) HXSBox *box;
@property (nonatomic, retain) NSSet *boxCartItem;
@end

@interface HXSBoxCart (CoreDataGeneratedAccessors)

- (void)addBoxCartItemObject:(HXSBoxCartItem *)value;
- (void)removeBoxCartItemObject:(HXSBoxCartItem *)value;
- (void)addBoxCartItem:(NSSet *)values;
- (void)removeBoxCartItem:(NSSet *)values;

@end

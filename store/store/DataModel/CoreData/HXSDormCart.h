//
//  HXSDormCart.h
//  store
//
//  Created by ArthurWang on 15/9/9.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HXSDormCart : NSManagedObject

@property (nonatomic, retain) NSString * couponCode;
@property (nonatomic, retain) NSNumber * couponDiscount;
@property (nonatomic, retain) NSNumber * deliveryFee;
@property (nonatomic, retain) NSNumber * dormentryId;
@property (nonatomic, retain) NSString * errorInfo;
@property (nonatomic, retain) NSNumber * itemAmount;
@property (nonatomic, retain) NSNumber * itemNum;
@property (nonatomic, retain) NSNumber * ownerUserId;
@property (nonatomic, retain) NSString * promotion_tip;
@property (nonatomic, retain) NSNumber * sessionNumber;
@property (nonatomic, retain) NSNumber * originAmountDoubleNum;

@end

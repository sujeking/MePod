//
//  HXSCart.h
//  store
//
//  Created by chsasaw on 14/12/12.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HXSCart : NSManagedObject

@property (nonatomic, retain) NSString * activityTips;
@property (nonatomic, retain) NSString * errorInfo;
@property (nonatomic, retain) NSNumber * itemAmount;
@property (nonatomic, retain) NSNumber * itemNum;
@property (nonatomic, retain) NSNumber * ownerUserId;
@property (nonatomic, retain) NSNumber * sessionNumber;
@property (nonatomic, retain) NSNumber * deliveryFee;

@end

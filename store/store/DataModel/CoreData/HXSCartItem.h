//
//  HXSCartItem.h
//  store
//
//  Created by chsasaw on 14/11/29.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HXSCartItem : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * defaultImage;
@property (nonatomic, retain) NSString * imageBig;
@property (nonatomic, retain) NSString * imageMedium;
@property (nonatomic, retain) NSString * imageSmall;
@property (nonatomic, retain) NSNumber * itemId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * originPrice;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * promotionId;
@property (nonatomic, retain) NSString * promotionLabel;
@property (nonatomic, retain) NSNumber * promotionType;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * rid;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * ownerUserId;
@property (nonatomic, retain) NSNumber * sessionNumber;
@property (nonatomic, retain) NSNumber * order;

@end

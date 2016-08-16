//
//  HXSDormCartItem.h
//  store
//
//  Created by chsasaw on 15/7/1.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HXSDormCartItem : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * dormentryId;
@property (nonatomic, retain) NSString * error_info;
@property (nonatomic, retain) NSString * imageBig;
@property (nonatomic, retain) NSString * imageMedium;
@property (nonatomic, retain) NSString * imageSmall;
@property (nonatomic, retain) NSNumber * itemId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * ownerUserId;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * rid;
@property (nonatomic, retain) NSNumber * sessionNumber;
@property (nonatomic, retain) NSNumber * order;

@end

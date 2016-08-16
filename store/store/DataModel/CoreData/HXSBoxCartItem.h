//
//  HXSBoxCartItem.h
//  store
//
//  Created by ArthurWang on 15/7/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HXSBoxCart;

@interface HXSBoxCartItem : NSManagedObject

@property (nonatomic, retain) NSString * img;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rid;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) HXSBoxCart *boxCart;

@end

//
//  HXSElemeFood.h
//  store
//
//  Created by ArthurWang on 15/8/27.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HXSElemeCategory;

@interface HXSElemeFood : NSManagedObject

@property (nonatomic, retain) NSNumber * foodID;
@property (nonatomic, retain) NSNumber * foodNumber;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) HXSElemeCategory *category;

@end

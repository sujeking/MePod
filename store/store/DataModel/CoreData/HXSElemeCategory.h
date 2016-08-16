//
//  HXSElemeCategory.h
//  store
//
//  Created by ArthurWang on 15/8/27.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HXSElemeFood, HXSElemeRestaurant;

@interface HXSElemeCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * categoryID;
@property (nonatomic, retain) NSNumber * categoryNumber;
@property (nonatomic, retain) HXSElemeRestaurant *restaurant;
@property (nonatomic, retain) NSSet *food;
@end

@interface HXSElemeCategory (CoreDataGeneratedAccessors)

- (void)addFoodObject:(HXSElemeFood *)value;
- (void)removeFoodObject:(HXSElemeFood *)value;
- (void)addFood:(NSSet *)values;
- (void)removeFood:(NSSet *)values;

@end

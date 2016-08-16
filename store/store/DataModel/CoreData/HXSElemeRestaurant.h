//
//  HXSElemeRestaurant.h
//  store
//
//  Created by ArthurWang on 15/8/27.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HXSElemeCategory;

@interface HXSElemeRestaurant : NSManagedObject

@property (nonatomic, retain) NSNumber * restaurantID;
@property (nonatomic, retain) NSSet *category;
@end

@interface HXSElemeRestaurant (CoreDataGeneratedAccessors)

- (void)addCategoryObject:(HXSElemeCategory *)value;
- (void)removeCategoryObject:(HXSElemeCategory *)value;
- (void)addCategory:(NSSet *)values;
- (void)removeCategory:(NSSet *)values;

@end

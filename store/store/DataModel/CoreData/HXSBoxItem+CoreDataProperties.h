//
//  HXSBoxItem+CoreDataProperties.h
//  store
//
//  Created by ArthurWang on 15/12/22.
//  Copyright © 2015年 huanxiao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HXSBoxItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXSBoxItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *img;
@property (nullable, nonatomic, retain) NSNumber *itemID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *order;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSNumber *replenishing;
@property (nullable, nonatomic, retain) NSNumber *rid;
@property (nullable, nonatomic, retain) NSNumber *stock;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) HXSBox *box;

@end

NS_ASSUME_NONNULL_END

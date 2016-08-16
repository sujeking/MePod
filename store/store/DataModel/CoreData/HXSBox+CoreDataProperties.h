//
//  HXSBox+CoreDataProperties.h
//  store
//
//  Created by ArthurWang on 15/10/9.
//  Copyright © 2015年 huanxiao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HXSBox.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXSBox (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *boxID;
@property (nullable, nonatomic, retain) NSString *code;
@property (nullable, nonatomic, retain) NSNumber *order;
@property (nullable, nonatomic, retain) NSString *owner;
@property (nullable, nonatomic, retain) NSString *room;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSNumber *capacity;
@property (nullable, nonatomic, retain) HXSBoxCart *boxCart;
@property (nullable, nonatomic, retain) NSSet<HXSBoxItem *> *boxItem;
@property (nullable, nonatomic, retain) HXSBoxQuestionnaire *boxQuestionnaire;
@property (nullable, nonatomic, retain) HXSRoom *roomItem;

@end

@interface HXSBox (CoreDataGeneratedAccessors)

- (void)addBoxItemObject:(HXSBoxItem *)value;
- (void)removeBoxItemObject:(HXSBoxItem *)value;
- (void)addBoxItem:(NSSet<HXSBoxItem *> *)values;
- (void)removeBoxItem:(NSSet<HXSBoxItem *> *)values;

@end

NS_ASSUME_NONNULL_END

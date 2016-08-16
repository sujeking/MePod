//
//  HXSMessage+CoreDataProperties.h
//  store
//
//  Created by ArthurWang on 15/9/25.
//  Copyright © 2015年 huanxiao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HXSMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXSMessage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSNumber *createTime;
@property (nullable, nonatomic, retain) NSString *icon;
@property (nullable, nonatomic, retain) NSString *messageID;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) HXSMessageAction *action;

@end

NS_ASSUME_NONNULL_END

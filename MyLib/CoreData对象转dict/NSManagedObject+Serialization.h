//
//  NSManagedObject+Serialization.h
//  NewHelome
//
//  Created by Kele on 14-9-17.
//  Copyright (c) 2014年 jetxiao. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Serialization)
- (NSDictionary*) toDictionary;

- (void) populateFromDictionary:(NSDictionary*)dict;

+ (NSManagedObject*) createManagedObjectFromDictionary:(NSDictionary*)dict
                                             inContext:(NSManagedObjectContext*)context;

@end

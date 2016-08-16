//
//  HXSDorm.h
//  
//
//  Created by ArthurWang on 15/8/11.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HXSRoom;

@interface HXSDorm : NSManagedObject

@property (nonatomic, retain) NSNumber * dormentryID;
@property (nonatomic, retain) NSSet *room;
@end

@interface HXSDorm (CoreDataGeneratedAccessors)

- (void)addRoomObject:(HXSRoom *)value;
- (void)removeRoomObject:(HXSRoom *)value;
- (void)addRoom:(NSSet *)values;
- (void)removeRoom:(NSSet *)values;

@end

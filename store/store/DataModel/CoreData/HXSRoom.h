//
//  HXSRoom.h
//  
//
//  Created by ArthurWang on 15/8/11.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HXSBox, HXSDorm;

@interface HXSRoom : NSManagedObject

@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) HXSDorm *dorm;
@property (nonatomic, retain) NSSet *box;
@end

@interface HXSRoom (CoreDataGeneratedAccessors)

- (void)addBoxObject:(HXSBox *)value;
- (void)removeBoxObject:(HXSBox *)value;
- (void)addBox:(NSSet *)values;
- (void)removeBox:(NSSet *)values;

@end

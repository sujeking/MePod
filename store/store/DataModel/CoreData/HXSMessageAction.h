//
//  HXSMessageAction.h
//  
//
//  Created by ArthurWang on 15/8/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HXSMessage;

@interface HXSMessageAction : NSManagedObject

@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) id param;
@property (nonatomic, retain) NSString * scheme;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) HXSMessage *message;

@end

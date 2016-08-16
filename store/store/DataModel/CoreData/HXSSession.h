//
//  HXSSession.h
//  store
//
//  Created by chsasaw on 14/11/29.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface HXSSession : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSNumber * ownerUserId;
@property (nonatomic, retain) NSNumber * sessionNumber;

@end

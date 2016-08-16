//
//  HXSDormSession.h
//  store
//
//  Created by chsasaw on 15/2/11.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HXSDormSession : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSNumber * ownerUserId;
@property (nonatomic, retain) NSNumber * sessionNumber;
@property (nonatomic, retain) NSNumber * dormentryId;

@end

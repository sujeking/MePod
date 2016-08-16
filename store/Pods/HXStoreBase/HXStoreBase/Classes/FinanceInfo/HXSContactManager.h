//
//  HXSContactManager.h
//  store
//
//  Created by chsasaw on 14-10-16.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HXSContactInfo : NSObject

@property (copy) NSString * name;
@property (copy) NSString * phoneNumber;

@end


@interface HXSContactManager : NSObject

+ (NSMutableArray *)getAllContacts;

+ (NSArray *)exportAllContactsForUserInfoAuth;

@end

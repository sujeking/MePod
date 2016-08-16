//
//  HXSUserInfo.h
//  store
//
//  Created by chsasaw on 14/10/26.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "HXSUserMyBoxInfo.h"
#import "HXSUserCreditcardInfoEntity.h"

@class HXSUserBasicInfo, HXSUserFinanceInfo, HXSUserKnightInfo;
/*
 *  manager user info
 */
@interface HXSUserInfo : NSObject

@property (nonatomic, strong) HXSUserBasicInfo            *basicInfo;
@property (nonatomic, strong) HXSUserFinanceInfo          *financeInfo;
@property (nonatomic, strong) HXSUserMyBoxInfo            *myBoxInfo;
@property (nonatomic, strong) HXSUserCreditcardInfoEntity *creditCardInfo;
@property (nonatomic, strong) HXSUserKnightInfo           *knightInfo;

@property (nonatomic, assign) BOOL hasBox;

- (void)logout;

#pragma mark - User info

- (void)updateUserInfo;

#pragma mark - location management

- (void)updateLocationInfo;

@end
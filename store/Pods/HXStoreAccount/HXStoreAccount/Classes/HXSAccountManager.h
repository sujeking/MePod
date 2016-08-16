//
//  HXSAccountManager.h
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXMacrosEnum.h"

@protocol HXSThirdAccountDelegate <NSObject>

@optional

- (void) thirdAccountDidLogin:(HXSAccountType)type;
- (void) thirdAccountDidLogout:(HXSAccountType)type;
- (void) thirdAccountLoginCancelled:(HXSAccountType)type;
- (void) thirdAccountLoginFailed:(HXSAccountType)type;
- (void) thirdAccountTokenInvalid:(HXSAccountType)type;

@end

// 第三方帐号管理

@interface HXSAccountManager : NSObject

+ (HXSAccountManager *) sharedManager;

- (NSString *) accountID;
- (NSString *) accountToken;

- (void) clearAccounts;

@property (nonatomic, assign) HXSAccountType accountType;

@end

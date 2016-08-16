//
//  HXSAccountManager.m
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSAccountManager.h"
#import "HXSSinaWeiboManager.h"
#import "HXSRenrenManager.h"
#import "HXSQQSdkManager.h"
#import "HXSWXApiManager.h"

static HXSAccountManager * account_instance = nil;

#define ACCOUNTTYPE_KEY     @"NS_ACCOUNTTYPE_KEY"

@implementation HXSAccountManager

+ (HXSAccountManager *) sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (account_instance == nil)
        {
            account_instance = [[HXSAccountManager alloc] init];
        }
    });
    return account_instance;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNTTYPE_KEY])
        {
            self.accountType = [[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNTTYPE_KEY] intValue];
        }
        else
        {
            self.accountType = kHXSUnknownAccount;
        }
    }
    return self;
}

- (NSString *) accountID
{
    if (self.accountType == kHXSSinaWeiboAccount)
    {
        if ([HXSSinaWeiboManager sharedManager].isLoggedIn)
        {
            return [HXSSinaWeiboManager sharedManager].userID;
        }
        else
        {
            return nil;
        }
    }
    else if (self.accountType == kHXSQQAccount)
    {
        if ([HXSQQSdkManager sharedManager].isLoggedIn)
        {
            return [HXSQQSdkManager sharedManager].userID;
        }
        else
        {
            return nil;
        }
    }
    else if (self.accountType == kHXSRenrenAccount)
    {
        if ([HXSRenrenManager sharedManager].isLoggedIn)
        {
            return [HXSRenrenManager sharedManager].userID;
        }
        else
        {
            return nil;
        }
    }
    else if (self.accountType == kHXSWeixinAccount)
    {
        if ([HXSWXApiManager sharedManager].isLoggedIn)
        {
            return [HXSWXApiManager sharedManager].userID;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        NSAssert(FALSE, @"Unknown account type");
        return nil;
    }
}

- (NSString *) accountToken
{
    if (self.accountType == kHXSSinaWeiboAccount)
    {
        if ([HXSSinaWeiboManager sharedManager].isLoggedIn)
        {
            return [HXSSinaWeiboManager sharedManager].accessToken;
        }
        else
        {
            return nil;
        }
    }
    else if (self.accountType == kHXSQQAccount)
    {
        if ([HXSQQSdkManager sharedManager].isLoggedIn)
        {
            return [HXSQQSdkManager sharedManager].accessToken;
        }
        else
        {
            return nil;
        }
    }
    else if (self.accountType == kHXSWeixinAccount)
    {
        if ([HXSWXApiManager sharedManager].isLoggedIn)
        {
            return [HXSWXApiManager sharedManager].accessToken;
        }
        else
        {
            return nil;
        }
    }
    else if (self.accountType == kHXSRenrenAccount)
    {
        if ([HXSRenrenManager sharedManager].isLoggedIn)
        {
            return [HXSRenrenManager sharedManager].accessToken;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        NSAssert(FALSE, @"Unknown account type");
        return nil;
    }
}

- (void) setAccountType:(HXSAccountType)accountType
{
    _accountType = accountType;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:_accountType] forKey:ACCOUNTTYPE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) clearAccounts
{
//    [[HXSSinaWeiboManager sharedManager] logOut];
//    [[HXSQQSdkManager sharedManager] logOut];
//    BEGIN_BACKGROUND_THREAD
//    [[HXSRenrenManager sharedManager] logOut];
//    END_BACKGROUND_THREAD
//    [[HXSWXApiManager sharedManager] logOut];
}

@end
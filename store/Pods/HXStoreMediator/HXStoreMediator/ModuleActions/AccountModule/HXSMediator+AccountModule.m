//
//  HXSMediator+AccountModule.m
//  Pods
//
//  Created by ArthurWang on 16/6/22.
//
//

#import "HXSMediator+AccountModule.h"

static NSString *kHXSMediatorTargetAccount = @"account";

static NSString *kHXSMediatorActionToken       = @"token";
static NSString *kHXSMediatorActionUpdateToken = @"updateToken";
static NSString *kHXSMediatorActionLogout      = @"logout";
static NSString *kHXSMediatorActionBoxID       = @"boxID";

@implementation HXSMediator (AccountModule)

- (NSString *)HXSMediator_token
{
    NSString *tokenStr = [self performTarget:kHXSMediatorTargetAccount
                                      action:kHXSMediatorActionToken
                                      params:nil];
    
    return tokenStr;
}

- (NSNumber *)HXSMediator_updateToken
{
    NSNumber *resultBoolNum = [self performTarget:kHXSMediatorTargetAccount
                                           action:kHXSMediatorActionUpdateToken
                                           params:nil];
    
    return resultBoolNum;
}

- (NSNumber *)HXSMediator_logout
{
    NSNumber *resultBoolNum = [self performTarget:kHXSMediatorTargetAccount
                                           action:kHXSMediatorActionLogout
                                           params:nil];
    
    return resultBoolNum;
}

- (NSNumber *)HXSMediator_boxID
{
    NSNumber *boxIDIntNum = [self performTarget:kHXSMediatorTargetAccount
                                         action:kHXSMediatorActionBoxID
                                         params:nil];
    
    return boxIDIntNum;
}


@end

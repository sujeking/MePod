//
//  HXSTarget_account.m
//  
//
//  Created by ArthurWang on 16/6/22.
//
//

#import "HXSTarget_account.h"

#import "HXSUserAccount.h"
#import "HXSUserInfo.h"
#import "HXSUserMyBoxInfo.h"
#import "HXSBoxEntry.h"

@implementation HXSTarget_account

- (NSString *)Action_token:(NSDictionary *)paramsDic
{
    NSString *tokenStr = [HXSUserAccount currentAccount].strToken;
    
    return tokenStr;
}

- (NSNumber *)Action_updateToken:(NSDictionary *)paramsDic
{
    [[HXSUserAccount currentAccount] updateToken];
    
    return [NSNumber numberWithBool:YES];
}

/** 登出 */
- (NSNumber *)Action_logout:(NSDictionary *)paramsDic
{
    [[HXSUserAccount currentAccount] logout];
    
    return [NSNumber numberWithBool:YES];
}

/** 获取BoxID */
- (NSNumber *)Action_boxID:(NSDictionary *)paramsDic
{
    NSNumber *boxIDIntNum = [HXSUserAccount currentAccount].userInfo.myBoxInfo.boxEntry.boxID;
    
    return boxIDIntNum;
}

@end

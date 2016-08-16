//
//  HXSMediator+AccountModule.h
//  Pods
//
//  Created by ArthurWang on 16/6/22.
//
//

#import "HXSMediator.h"

@interface HXSMediator (AccountModule)

- (NSString *)HXSMediator_token;

- (NSNumber *)HXSMediator_updateToken;

- (NSNumber *)HXSMediator_logout;

- (NSNumber *)HXSMediator_boxID;

@end

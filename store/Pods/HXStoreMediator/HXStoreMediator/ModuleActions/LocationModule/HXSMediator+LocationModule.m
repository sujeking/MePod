//
//  HXSMediator+LocationModule.m
//  
//
//  Created by ArthurWang on 16/6/22.
//
//

#import "HXSMediator+LocationModule.h"

static NSString *kHXSMediatorTargetLocation = @"location";

static NSString *kHXSMediatorActionSiteID      = @"siteID";
static NSString *kHXSMediatorActionCityID      = @"cityID";
static NSString *kHXSMediatorActionDormentryID = @"dormentryID";

@implementation HXSMediator (LocationModule)

- (NSNumber *)HXSMediator_currentSiteID
{
    NSNumber *siteIDIntNum = [self performTarget:kHXSMediatorTargetLocation
                                          action:kHXSMediatorActionSiteID
                                          params:nil];
    
    return siteIDIntNum;
}

- (NSNumber *)HXSMediator_currentCityID
{
    NSNumber *cityIDIntNum = [self performTarget:kHXSMediatorTargetLocation
                                          action:kHXSMediatorActionCityID
                                          params:nil];
    
    return cityIDIntNum;
}

- (NSNumber *)HXSMediator_currentDormentryID
{
    NSNumber *dormentryIDIntNum = [self performTarget:kHXSMediatorTargetLocation
                                          action:kHXSMediatorActionDormentryID
                                          params:nil];
    
    return dormentryIDIntNum;
}

@end

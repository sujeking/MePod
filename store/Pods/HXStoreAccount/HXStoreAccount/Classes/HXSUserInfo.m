//
//  HXSUserInfo.m
//  store
//
//  Created by chsasaw on 14/10/26.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSUserInfo.h"

#import "HXSUserAccountModel.h"
#import "HXSUserBasicInfo.h"
#import "HXMacrosDefault.h"

@interface HXSUserInfo() <CLLocationManagerDelegate>

@end

@implementation HXSUserInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self updateUserInfo];
    }
    return self;
}

- (void)updateUserInfo
{
    __weak typeof(self) weakSelf = self;
    
    [HXSUserAccountModel getUserWholeInfo:^(HXSErrorCode code, NSString *message, NSDictionary *info) {
        if (kHXSNoError == code) {
            weakSelf.knightInfo     = [info objectForKey:KEY_USER_INFO_KNIGHT];
            
            weakSelf.basicInfo      = [info objectForKey:KEY_USER_INFO_BASIC];

            weakSelf.financeInfo    = [info objectForKey:KEY_USER_INFO_FINANCE];

            weakSelf.myBoxInfo      = [info objectForKey:KEY_USER_INFO_MY_BOX];
            
            HXSBoxEntry *boxEntry = weakSelf.myBoxInfo.boxEntry;
            if ([boxEntry.boxID intValue] > 0) {
                weakSelf.hasBox = YES;
            }
            else {
                weakSelf.hasBox = NO;
            }
        }
        
        [weakSelf updateCreditCardInfo];
        
    }];
}

- (void)updateCreditCardInfo
{
    __weak typeof(self) weakSelf = self;
    
    [HXSUserAccountModel getCreditCardInfo:^(HXSErrorCode code, NSString *message, HXSUserCreditcardInfoEntity *creditcardInfoEntity) {
        if (kHXSNoError == code) {
            weakSelf.creditCardInfo = creditcardInfoEntity;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoUpdated
                                                            object:nil
                                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:weakSelf.basicInfo.uid, @"uid", nil]];
    }];
}

- (void)logout
{
    self.basicInfo      = nil;
    self.financeInfo    = nil;
    self.myBoxInfo      = nil;
    self.creditCardInfo = nil;
    self.knightInfo     = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoUpdated
                                                        object:nil
                                                      userInfo:nil];
}


#pragma mark - location management

- (void) updateLocationInfo
{
    CLLocationManager * locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = 100;
    locationManager.distanceFilter = 100;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation.horizontalAccuracy >= 0 &&
        newLocation.horizontalAccuracy < 100)
    {
        double latitude = newLocation.coordinate.latitude;
        double longitude = newLocation.coordinate.longitude;
        self.basicInfo.latitude = [NSString stringWithFormat:@"%.2f", latitude];
        self.basicInfo.longitude = [NSString stringWithFormat:@"%.2f", longitude];
        
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray * placeMarks, NSError * error)
         {
             if(placeMarks && placeMarks.count > 0)
             {
                 CLPlacemark *topResult = [placeMarks objectAtIndex:0];
                 
                 if (topResult.administrativeArea && topResult.subAdministrativeArea)
                 {
                     self.basicInfo.location = [NSString stringWithFormat:@"%@ %@", topResult.administrativeArea, topResult.subAdministrativeArea];
                 }
                 else if (topResult.administrativeArea)
                 {
                     self.basicInfo.location = [NSString stringWithFormat:@"%@", topResult.administrativeArea];
                 }
             }
         }];
    }
}



@end

//
//  HXSSubscribeAuthorizeCheck.m
//  59dorm
//
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSSubscribeAuthorizeCheck.h"

@implementation HXSSubscribeAuthorizeCheck

- (ABAuthorizationStatus)checkABAddressBookGetAuthorize
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        });
        return kABAuthorizationStatusNotDetermined;
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        return kABAuthorizationStatusDenied;//未授权
    } else
        return ABAddressBookGetAuthorizationStatus();
}

- (CLAuthorizationStatus)checkLocationAuthorize
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    return status;
}

@end

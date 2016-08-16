//
//  HXSSubscribeAuthorizeCheck.h
//  59dorm
//
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>

@interface HXSSubscribeAuthorizeCheck : NSObject


/**
 *  检测通讯录是否被授权
 */
- (ABAuthorizationStatus)checkABAddressBookGetAuthorize;

/**
 *  获取定位是否被授权
 *
 *  @return
 */
- (CLAuthorizationStatus)checkLocationAuthorize;

@end

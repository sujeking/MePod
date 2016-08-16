//
//  HXSTarget_creditcard.m
//  store
//
//  Created by ArthurWang on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTarget_creditcard.h"

#import "HXSDigitalMobileViewController.h"

@implementation HXSTarget_creditcard

/** 跳转分期商城页面 */
// hxstore://creditcard/tip
- (UIViewController *)Action_tip:(NSDictionary *)paramsDic
{
    HXSDigitalMobileViewController *mobileVC = [HXSDigitalMobileViewController controllerFromXib];
    
    return mobileVC;
}

@end

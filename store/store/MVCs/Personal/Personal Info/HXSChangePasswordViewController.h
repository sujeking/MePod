//
//  HXSChangePasswordViewController.h
//  store
//
//  Created by ranliang on 15/7/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseTableViewController.h"

typedef NS_ENUM(NSUInteger, HXSChangePasswordMode) {
    HXSChangePasswordLogin = 0,
    HXSChangePasswordPay,
};

@interface HXSChangePasswordViewController : HXSBaseTableViewController

@property (nonatomic, assign) HXSChangePasswordMode mode;
@property (nonatomic, assign) BOOL hasOldPassword;

@end

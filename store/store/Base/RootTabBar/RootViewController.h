//
//  RootViewController.h
//  store
//
//  Created by chsasaw on 14-10-14.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITabBarController

- (BOOL)checkIsLoggedin;

- (UINavigationController *)currentNavigationController;

@end
//
//  AppDelegate.h
//  store
//
//  Created by chsasaw on 14-10-11.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class RootViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UIViewController * viewController;

@property (nonatomic, strong) RootViewController * rootViewController;

+ (AppDelegate *)sharedDelegate;

- (void)showApnsPayload;
- (void)showPayload:(NSString *)payload;

@end
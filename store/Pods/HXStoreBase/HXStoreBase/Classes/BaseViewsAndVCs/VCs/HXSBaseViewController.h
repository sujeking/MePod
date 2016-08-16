//
//  HXSBaseViewController.h
//  store
//
//  Created by chsasaw on 14-10-15.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSWarningBarView;

@interface HXSBaseViewController : UIViewController

@property (nonatomic, strong) HXSWarningBarView *warnBarView;
@property (nonatomic, assign, getter=isFirstLoading) BOOL firstLoading;

@property (nonatomic, weak) IBOutlet UIImageView *cannotFindImageView;
@property (nonatomic, weak) IBOutlet UILabel *cannotFindLabel;

- (void)showWarning:(NSString *)wStr;
- (void)dismissWarning;

- (void)tokenRefreshed;

- (void)replaceCurrentViewControllerWith:(UIViewController *)viewController animated:(BOOL)animated;

- (void)initialNavigationLeftItem; // back + close buttons
- (void)turnBack;
- (void)close;

@end
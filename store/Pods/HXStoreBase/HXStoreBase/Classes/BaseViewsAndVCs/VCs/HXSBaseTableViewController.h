//
//  HXSBaseTableViewController.h
//  store
//
//  Created by hudezhi on 15/7/22.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSWarningBarView.h"

@interface HXSBaseTableViewController : UITableViewController

@property (nonatomic, strong) HXSWarningBarView *warnBarView;

- (void)showWarning:(NSString *)wStr;
- (void)dismissWarning;

@end

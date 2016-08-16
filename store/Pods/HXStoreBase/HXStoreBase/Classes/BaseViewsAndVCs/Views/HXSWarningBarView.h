//
//  HXSWarningBarView.h
//  store
//
//  Created by ArthurWang on 15/7/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSWarningBarView : UIView

@property (nonatomic, strong) UILabel *warnLabel;

- (void)customWarningText:(NSString *)warningText;

- (void)removeMyselfViewFromSuperview;

@end

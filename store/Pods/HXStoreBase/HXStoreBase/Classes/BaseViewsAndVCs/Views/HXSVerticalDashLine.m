//
//  HXSVerticalDashLine.m
//  store
//
//  Created by chsasaw on 14/11/20.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSVerticalDashLine.h"

@implementation HXSVerticalDashLine

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_line_vertical"]]];
}

@end
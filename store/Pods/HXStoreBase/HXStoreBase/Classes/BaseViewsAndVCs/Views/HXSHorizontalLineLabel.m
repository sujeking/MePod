//
//  HXSHorizontalLineLabel.m
//  store
//
//  Created by chsasaw on 14/11/22.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSHorizontalLineLabel.h"

@implementation HXSHorizontalLineLabel

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line_horizontal"]]];
}

@end

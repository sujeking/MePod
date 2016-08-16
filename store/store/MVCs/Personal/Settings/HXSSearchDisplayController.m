//
//  HXSSearchDisplayController.m
//  store
//
//  Created by chsasaw on 15/3/3.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSSearchDisplayController.h"

@implementation HXSSearchDisplayController

- (void)setActive:(BOOL)visible animated:(BOOL)animated;
{
    [super setActive:visible animated:animated];
    
    if(!self.active) {
        [self performSelector:@selector(showNav) withObject:nil afterDelay:0.5];
    }
}

- (void)showNav {
    [self.searchContentsController.navigationController setNavigationBarHidden:NO animated:YES];
    [self.searchContentsController.navigationController.navigationBar setNeedsDisplay];
    
}

@end

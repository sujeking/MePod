//
//  HXSRoundedButton.m
//  store
//
//  Created by chsasaw on 14/12/2.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSRoundedButton.h"

#import "Color+Image.h"
#import "UIColor+Extensions.h"
#import "HXMacrosUtils.h"

@implementation HXSRoundedButton

- (id)init {
    if(self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:HXS_MAIN_COLOR] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor highlightedColorFromColor:HXS_MAIN_COLOR]] forState:UIControlStateHighlighted];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.0;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:HXS_MAIN_COLOR] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor highlightedColorFromColor:HXS_MAIN_COLOR]] forState:UIControlStateHighlighted];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.0;
    }
    
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    if (enabled) {
        self.userInteractionEnabled = YES;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        self.userInteractionEnabled = NO;
        [self setTitleColor:UIColorFromRGB(0x45B6FB) forState:UIControlStateNormal];
    }
}

@end

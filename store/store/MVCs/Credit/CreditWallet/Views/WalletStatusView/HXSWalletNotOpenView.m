//
//  HXSWalletNotOpenView.m
//  store
//
//  Created by ArthurWang on 16/7/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSWalletNotOpenView.h"

@interface HXSWalletNotOpenView ()

@end

@implementation HXSWalletNotOpenView

#pragma mark - Public Methos

+ (instancetype)createWalletNotOpenView
{
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                     owner:nil
                                                   options:nil];
    
    HXSWalletNotOpenView *notOpenView = [viewArr firstObject];
    
    
    return notOpenView;
}

@end

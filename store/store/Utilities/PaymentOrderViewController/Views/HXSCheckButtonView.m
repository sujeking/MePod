

//
//  HXSCheckButtonView.m
//  store
//
//  Created by  黎明 on 16/5/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCheckButtonView.h"

@implementation HXSCheckButtonView

- (void)awakeFromNib
{
    [self initButton];
}

- (void)initButton
{
    [self.checkButton addTarget:self action:@selector(paymentButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)paymentButtonClick
{
    if (self.paymentAction) {
        self.paymentAction();
    }
}


@end

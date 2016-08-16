//
//  HXSInfoSubmitCompleteFooterView.m
//  store
//
//  Created by  黎明 on 16/7/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSEditDormAddressFooterView.h"

@implementation HXSEditDormAddressFooterView

- (void)awakeFromNib
{
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self.commitButton setEnabled:NO];
}


- (IBAction)submitButtonClick:(id)sender
{
    if (self.submitButtonClickBlock)
    {
        self.submitButtonClickBlock();
    }
}

@end

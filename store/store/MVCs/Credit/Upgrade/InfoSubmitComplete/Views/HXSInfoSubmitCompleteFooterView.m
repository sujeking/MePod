//
//  HXSInfoSubmitCompleteFooterView.m
//  store
//
//  Created by  黎明 on 16/7/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSInfoSubmitCompleteFooterView.h"

@interface HXSInfoSubmitCompleteFooterView()

@property (nonatomic, weak) IBOutlet HXSRoundedButton *backButton;

@end

@implementation HXSInfoSubmitCompleteFooterView

- (IBAction)backButtonClickAction:(id)sender
{
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock();
    }
}

@end

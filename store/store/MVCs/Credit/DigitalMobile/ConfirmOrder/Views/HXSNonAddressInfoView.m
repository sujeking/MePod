//
//  HXSNonAddressInfoView.m
//  store
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSNonAddressInfoView.h"
#import "HXSDigitalMobileAddressViewController.h"
#import "HXSDigitalMobileConfirmOrderViewController.h"

@implementation HXSNonAddressInfoView

- (void)awakeFromNib {
    
}


#pragma mark - add address

- (IBAction)addAddress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoAddAddressViewcontroller)]) {
        [self.delegate performSelector:@selector(gotoAddAddressViewcontroller) withObject:nil];
    }
}

@end

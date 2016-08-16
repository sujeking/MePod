//
//  HXSNonAddressInfoView.h
//  store
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSDigitalMobileConfirmOrderViewController;

@protocol HXSAddAddressInfoDelegate <NSObject>

- (void)gotoAddAddressViewcontroller;

@end

@interface HXSNonAddressInfoView : UIView

@property (nonatomic, weak) id <HXSAddAddressInfoDelegate> delegate;

@end

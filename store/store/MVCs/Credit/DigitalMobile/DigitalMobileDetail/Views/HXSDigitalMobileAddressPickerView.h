//
//  HXSDigitalMobileAddressPickerView.h
//  store
//
//  Created by ArthurWang on 16/3/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HXSDigitalMobileCustomerPickView)(NSArray *pickerViewDataSource, NSArray *selectedAddressArr);

@interface HXSDigitalMobileAddressPickerView : UIView

+ (void)showWithPickerViewDataSource:(NSArray *)pickerViewDataSource
                            selected:(NSArray *)selectedAddressArr
                        toolBarColor:(UIColor *)color
                       completeBlock:(HXSDigitalMobileCustomerPickView)block;

@end

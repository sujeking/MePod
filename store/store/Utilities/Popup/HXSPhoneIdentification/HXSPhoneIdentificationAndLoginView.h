//
//  HXSPhoneIdentificationAndLoginView.h
//  store
//
//  Created by ArthurWang on 15/9/15.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSPhoneIdentificationAndLoginView : UIView

- (instancetype)initWithPhone:(NSString *)phoneNumberStr
                     finished:(void (^)(BOOL success, NSString *message))finished;

- (void)start;
- (void)end;

@end

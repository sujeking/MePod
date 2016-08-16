//
//  HXSPhoneIdentificationView.h
//  store
//
//  Created by ArthurWang on 15/7/29.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSSVerifyButton.h"

@interface HXSPhoneIdentificationView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet HSSVerifyButton *fecthIdentifierBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendIdentificationBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UILabel *alertContentLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activtiyIndicator;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnConstraint;

@end

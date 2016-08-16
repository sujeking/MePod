//
//  HXSPayPasswdAlertView.h
//  Test
//
//  Created by hudezhi on 15/7/27.
//  Copyright (c) 2015年 59store. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSPayPasswdField.h"

@class HXSLineView;

@interface HXSPayPasswdView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet HXSPayPasswdField *passwdField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIView *exemptionView;
@property (weak, nonatomic) IBOutlet UIButton *exemptionBtn;
@property (weak, nonatomic) IBOutlet HXSLineView *topButtonLineView;


@end

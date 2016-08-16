//
//  HXSBindTelephoneFooterView.h
//  store
//
//  Created by hudezhi on 15/9/29.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSBindTelephoneFooterView : UIView

+ (instancetype)bindTelephoneFooterView;

@property (nonatomic, assign) BOOL isUpdate;

@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceCallBtn;

@end

//
//  HXSPersonalCenterHeaderView.h
//  store
//
//  Created by hudezhi on 15/7/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSPersonalMenuButton;

@interface HXSPersonalCenterHeaderView : UIView

@property (nonatomic, weak) UIViewController *parentViewController;

@property (weak, nonatomic) IBOutlet HXSPersonalMenuButton *centsBtn;
@property (weak, nonatomic) IBOutlet HXSPersonalMenuButton *couponsBtn;
@property (weak, nonatomic) IBOutlet HXSPersonalMenuButton *creditBtn;
@property (weak, nonatomic) IBOutlet UIButton *personInfoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *personalPortraitImageView;

@property (weak, nonatomic) IBOutlet HXSPersonalMenuButton *commissionBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateCountLabelHeight;


+ (id)headerView;

- (void)refreshInfo;

@end

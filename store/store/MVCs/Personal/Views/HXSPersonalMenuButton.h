//
//  HXSPersonalMenuButton.h
//  store
//
//  Created by hudezhi on 15/7/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "UIRenderingButton.h"

/*
 * How to use: Set image, title, value
 */
@interface HXSPersonalMenuButton : UIButton

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

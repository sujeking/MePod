//
//  HXSSubscribeVaildNumCell.h
//  59dorm
//  验证码
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

static CGFloat cellVaildNumCellHeight  = 44;

#import <UIKit/UIKit.h>

#import "HXSRegisterVerifyButton.h"

@interface HXSSubscribeVaildNumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel                 *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField             *inputTextField;
@property (weak, nonatomic) IBOutlet HXSRegisterVerifyButton *verityButton;

+ (instancetype)createSubscribeVaildNumCell;

@end

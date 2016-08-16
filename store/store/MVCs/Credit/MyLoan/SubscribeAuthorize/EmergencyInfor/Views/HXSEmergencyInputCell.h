//
//  HXSEmergencyInputCell.h
//  59dorm
//
//  Created by J006 on 16/7/13.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSEmergencyInputCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel        *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField    *inputTextField;
/** 联系人名单按钮 */
@property (weak, nonatomic) IBOutlet UIButton       *contractButton;

+ (instancetype)createEmergencyInputCell;

@end

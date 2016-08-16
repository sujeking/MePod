//
//  HXSModifyBoxInfoCell.h
//  store
//
//  Created by 格格 on 16/7/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSModifyBoxInfoCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *keyLabel;
@property (nonatomic, weak) IBOutlet UITextField *valueTextField;

+ (instancetype)modifyBoxInfoCell;

@end

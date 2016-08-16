//
//  HXSGetCashTableViewCell.h
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSGetCashTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;

+ (id)crashTableViewCell;

@end

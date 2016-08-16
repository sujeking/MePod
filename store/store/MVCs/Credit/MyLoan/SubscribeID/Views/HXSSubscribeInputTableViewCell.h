//
//  HXSSubscribeInputTableViewCell.h
//  59dorm
//
//  Created by J006 on 16/7/8.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat cellInputHeight  = 44;

@interface HXSSubscribeInputTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel     *keyLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

+ (instancetype)createSubscribeInputTableViewCell;

@end

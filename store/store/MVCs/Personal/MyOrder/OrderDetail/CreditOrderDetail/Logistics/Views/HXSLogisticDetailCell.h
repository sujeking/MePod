//
//  HXSLogisticDetailCell.h
//  store
//
//  Created by 沈露萍 on 16/3/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSLogisticDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView      *topLineView;
@property (weak, nonatomic) IBOutlet UIView      *bottomLineView;
@property (weak, nonatomic) IBOutlet UIImageView *dotImageView;
@property (weak, nonatomic) IBOutlet UILabel     *descLabel;
@property (weak, nonatomic) IBOutlet UILabel     *timeLabel;
@end

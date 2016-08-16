//
//  HXSInstallmentDetailCell.h
//  store
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXSDigitalMobileInstallmentDetailViewController;
@class HXSInstallmentItemEntity;

@interface HXSInstallmentDetailCell : UITableViewCell

@property (nonatomic, weak) HXSDigitalMobileInstallmentDetailViewController * controller;

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *installmentMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *installmentAccount;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (void)initCellLabel:(HXSInstallmentItemEntity *)installmentItem;

@end

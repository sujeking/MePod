//
//  HXSOrderAmountTableViewCell.h
//  store
//
//  Created by ArthurWang on 15/7/27.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSOrderAmountTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;


- (void)setupOrderAmountCellWith:(HXSOrderInfo *)orderInfo;

@end

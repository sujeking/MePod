//
//  HXSOrderPayTableViewCell.h
//  store
//
//  Created by ArthurWang on 15/7/27.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSOrderPayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ordrePayCouponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPayPriceLabel;

- (void)setupOrderPayCellWithDiscountDetail:(HXSOrderDiscountDetail *)discountDetail;

@end

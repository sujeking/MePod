//
//  HXSOrderDetailTableViewCell.h
//  store
//
//  Created by ArthurWang on 15/7/27.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSOrderDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderDetailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailAmountLabel;


@end

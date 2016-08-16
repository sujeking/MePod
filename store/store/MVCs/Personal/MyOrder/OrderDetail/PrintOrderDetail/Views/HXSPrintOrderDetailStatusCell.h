//
//  HXSPrintOrderDetailStatusCell.h
//  store
//
//  Created by 格格 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSBoxOrderModel.h"
@class HXSPrintOrderInfo;

@interface HXSPrintOrderDetailStatusCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *telephoneButton;

@property (strong,nonatomic) HXSPrintOrderInfo *printOrder;

@property (nonatomic ,strong) HXSBoxOrderModel *boxOrder;

@end

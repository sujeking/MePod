//
//  HXSMyPayBillCell.h
//  store
//
//  Created by J006 on 16/2/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSMyPayBillDetailEntity.h"

#define HXSMyPayBillCellIdentify @"HXSMyPayBillCell"

@interface HXSMyPayBillCell : UITableViewCell

- (void)initMyPayBillCellWithEntity:(HXSMyPayBillDetailEntity *)entity;

@end

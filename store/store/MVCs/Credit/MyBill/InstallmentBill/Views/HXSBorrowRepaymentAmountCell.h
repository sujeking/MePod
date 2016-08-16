//
//  HXSBorrowRepaymentAmountCell.h
//  store
//
//  Created by hudezhi on 15/8/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSBillRepaymentInfo.h"

/*
 * 近期应还款
 */
@interface HXSBorrowRepaymentAmountCell : UITableViewCell

@property (nonatomic) HXSBillRepaymentItem *record;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;

@end

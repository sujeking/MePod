//
//  HXSPayBillConfirmInstallmentSecondCell.h
//  store
//
//  Created by J006 on 16/2/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HXSPayBillConfirmInstallmentSecondCellIdentify @"HXSPayBillConfirmInstallmentSecondCell"

@interface HXSPayBillConfirmInstallmentSecondCell : UITableViewCell

/**
 *  初始化
 *
 *  @param amount 分期金额
 *  @param nums   月供的月数目
 */
- (void)initPayBillConfirmInstallmentSecondCellWithInstallmentAmount:(NSNumber *)amount
                                                        andMonthNums:(NSInteger)nums;

@end

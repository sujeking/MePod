//
//  HXSPayBillSelectInstallmentCell.h
//  store
//
//  Created by J006 on 16/3/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HXSPayBillSelectInstallmentCellIdentify @"HXSPayBillSelectInstallmentCell"

@interface HXSPayBillSelectInstallmentCell : UITableViewCell

/**
 *  初始化
 *
 *  @param nums 分期的月数
 */
- (void)initPayBillSelectInstallmentCellWithMonthNums:(NSInteger)nums;

@end

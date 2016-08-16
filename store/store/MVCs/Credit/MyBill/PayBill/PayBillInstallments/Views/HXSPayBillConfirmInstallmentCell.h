//
//  HXSPayBillConfirmInstallmentCell.h
//  store
//
//  Created by J006 on 16/2/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HXSPayBillConfirmInstallmentCellIdentify @"HXSPayBillConfirmInstallmentCell"

typedef NS_ENUM(NSUInteger,HXSPayBillConfirmInstallmentCellType) {
    HXSPayBillConfirmInstallmentCellTypeDate      = 0,  // 日期
    HXSPayBillConfirmInstallmentCellTypePrice     = 1,  // 价格
} ;

@interface HXSPayBillConfirmInstallmentCell : UITableViewCell

/**
 *  初始化
 *
 *  @param value 右边lable的值
 *  @param title 左边label的title
 *  @param type
 */
- (void)initPayBillConfirmInstallmentWith:(NSString *)value
                                 andTitle:(NSString *)title
                                  andType:(HXSPayBillConfirmInstallmentCellType)type;

@end

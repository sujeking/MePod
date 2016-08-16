//
//  HXSCreditOrderDetailHeaderTableViewCell.h
//  store
//
//  Created by ArthurWang on 16/3/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSCreditOrderDetailHeaderTableViewCell : UITableViewCell

+ (CGFloat)heightOfHeaderViewForOrder:(HXSOrderInfo *)orderInfo;

- (void)setupCreditOrderHeaderViewWithOrderInfo:(HXSOrderInfo *)orderInfo;

@end

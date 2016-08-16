//
//  HXSCreditOrderDetailFooterTableViewCell.h
//  store
//
//  Created by ArthurWang on 16/3/9.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSCreditOrderDetailFooterTableViewCell : UITableViewCell

+ (CGFloat)heightOfFooterViewForOrder:(HXSOrderInfo *)orderInfo;

- (void)setupFooterCellWithOrderInfo:(HXSOrderInfo *)orderInfo;

@end

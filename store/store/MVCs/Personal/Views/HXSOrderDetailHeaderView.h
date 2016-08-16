//
//  HXSOrderDetailHeaderView.h
//  store
//
//  Created by ranliang on 15/5/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSOrderInfo;

@interface HXSOrderDetailHeaderView : UITableViewCell

- (void)configWithOrderInfo:(HXSOrderInfo *)orderInfo;
+ (CGFloat)heightForOrder:(HXSOrderInfo *)orderInfo;

@end
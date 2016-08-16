//
//  HXSOrderDetailFooterView.h
//  store
//
//  Created by ranliang on 15/5/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSOrderInfo;

@interface HXSOrderDetailFooterView : UITableViewCell

- (void)configWithOrderInfo:(HXSOrderInfo *)orderInfo;

@end

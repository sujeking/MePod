//
//  HXSMyOrdersViewController.h
//  store
//
//  Created by chsasaw on 14/12/5.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@class HXSPrintOrderInfo;
@class HXSStoreOrderEntity;

@interface HXSMyOrdersViewController : HXSBaseViewController

@property (nonatomic, assign) BOOL isFromPersonalCenter;
@property (nonatomic, assign) BOOL isFromDorm;

- (void)replacePrintOrderInfo:(HXSPrintOrderInfo *)order;


@end
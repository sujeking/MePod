//
//  HXSPrintOrderViewController.h
//  store
//
//  Created by 格格 on 16/3/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@class HXSPrintOrderInfo;

typedef void(^updateSelectionTitle)(NSInteger index);

@interface HXSPrintOrderViewController : HXSBaseViewController

@property (nonatomic, strong) NSNumber *typeNumber;
@property (nonatomic, copy)   updateSelectionTitle updateSelectionTitle;

- (void)replaceOrderInfo:(HXSPrintOrderInfo *)order;

@end

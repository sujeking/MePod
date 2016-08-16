//
//  HXSCreditOrderViewController.h
//  store
//
//  Created by ArthurWang on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

#import "HXSCreditOrderEntity.h"

@interface HXSCreditOrderViewController : HXSBaseViewController

@property (nonatomic, strong) NSNumber *typeNumber;
@property (nonatomic, copy) void (^updateSelectionTitle)(NSInteger index);

- (void)replaceOrderInfo:(HXSOrderInfo *)order;

@end

//
//  HXSMyBillViewController.h
//  store
//
//  Created by J006 on 16/2/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@interface HXSMyBillViewController : HXSBaseViewController

/**0 @"消费类账单"  1  @"分期类账单"*/
@property (nonatomic, strong) NSNumber *selectedSegmentIndexIntNum;

@end

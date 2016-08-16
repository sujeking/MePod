//
//  HXSMyNewPayBillTableHeaderView.h
//  store
//
//  Created by J006 on 16/2/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSMyPayBillListEntity.h"

@interface HXSMyPayBillTableHeaderView : UIView

+ (id)myPayBillTableHeaderView;

- (void)initTheViewWithEntity:(HXSMyPayBillListEntity *)entity;

@end

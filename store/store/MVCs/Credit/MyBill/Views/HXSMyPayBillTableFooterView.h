//
//  HXSMyPayBillTableFooterView.h
//  store
//
//  Created by J006 on 16/2/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSMyPayBillListEntity.h"

/**
 *消费类账单footerview
 */
@interface HXSMyPayBillTableFooterView : UIView

+ (id)myNewPayBillTableFooterView;

- (void)initTheViewWithMyPayBillListEntity:(HXSMyPayBillListEntity *)entity;

@end

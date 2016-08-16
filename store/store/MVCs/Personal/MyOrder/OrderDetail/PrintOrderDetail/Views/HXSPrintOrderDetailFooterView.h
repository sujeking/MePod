//
//  HXSPrintOrderDetailFooterView.h
//  store
//
//  Created by 格格 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSBoxOrderModel.h"

@class HXSPrintOrderInfo;

@interface HXSPrintOrderDetailFooterView : UITableViewCell

@property(nonatomic,strong) HXSPrintOrderInfo *printOrderEntity;

@property(nonatomic,strong) HXSBoxOrderModel *boxOrderModel;

@end

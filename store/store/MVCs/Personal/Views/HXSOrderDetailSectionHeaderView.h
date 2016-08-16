//
//  HXSOrderDetailSectionHeaderView.h
//  store
//
//  Created by ranliang on 15/5/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSPrintOrderInfo;

@interface HXSOrderDetailSectionHeaderView : UITableViewCell

@property(nonatomic,strong) HXSPrintOrderInfo *printOrderEntity;

- (void)setNumberOfItems:(NSInteger)numberOfItems;

@end

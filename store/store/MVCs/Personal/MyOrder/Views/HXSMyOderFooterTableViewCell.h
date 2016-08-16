//
//  HXSMyOderFooterTableViewCell.h
//  store
//
//  Created by ArthurWang on 15/7/28.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSPrintOrderInfo;
@class HXSBoxOrderEntity;
@class HXSStoreOrderEntity;
@class HXSBoxOrderModel;

@interface HXSMyOderFooterTableViewCell : UITableViewCell

- (void)setOrderInfo:(HXSOrderInfo *)orderInfo;

- (void)setBoxOrderEntity:(HXSBoxOrderEntity *)boxOrderEntity;

- (void)setPrintOrderInfo:(HXSPrintOrderInfo *)printOrderInfo;

- (void)setStoreOrderEntity:(HXSStoreOrderEntity *)storeOrderEntity;

@property (nonatomic, weak) IBOutlet UILabel *numLabel;
@property (nonatomic, weak) IBOutlet UILabel *discountLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalAmountLabel;

@property (nonatomic, strong) HXSBoxOrderModel *boxOrderModel; // 零食盒子添加

@end

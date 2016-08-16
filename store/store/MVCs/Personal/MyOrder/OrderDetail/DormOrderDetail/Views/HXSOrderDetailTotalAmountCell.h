//
//  HXSOrderDetailTotalAmountCell.h
//  store
//
//  Created by hudezhi on 15/12/2.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSBoxOrderModel.h"

@class HXSPrintOrderInfo;

@interface HXSOrderDetailTotalAmountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (nonatomic,strong) HXSPrintOrderInfo *printOrderEntity;

- (void)setupDetialTotalAmountCellWithOrderInfo:(HXSOrderInfo *)orderInfo;
-(void)setPrintOrderEntity:(HXSPrintOrderInfo *)printOrderEntity;


@property (nonatomic, strong) HXSBoxOrderModel *boxOrder;

@end

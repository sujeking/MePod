//
//  HXSOrderDetailTotalAmountCell.m
//  store
//
//  Created by hudezhi on 15/12/2.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSOrderDetailTotalAmountCell.h"
#import "HXSPrintOrderInfo.h"

@implementation HXSOrderDetailTotalAmountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupDetialTotalAmountCellWithOrderInfo:(HXSOrderInfo *)orderInfo
{
    self.amountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [orderInfo.order_amount doubleValue]];
}

-(void)setPrintOrderEntity:(HXSPrintOrderInfo *)printOrderEntity{
    _printOrderEntity = printOrderEntity;
    self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",printOrderEntity.payAmountDoubleNum.doubleValue];
}

- (void)setBoxOrder:(HXSBoxOrderModel *)boxOrder{
    _boxOrder = boxOrder;
    self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",boxOrder.payAmountDoubleNum.doubleValue];
}

@end

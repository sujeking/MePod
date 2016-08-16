//
//  HXSMyOderFooterTableViewCell.m
//  store
//
//  Created by ArthurWang on 15/7/28.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSMyOderFooterTableViewCell.h"

#import "HXSBoxOrderEntity.h"
#import "HXSCreditOrderEntity.h"
#import "HXSPrintOrderInfo.h"
#import "HXSStoreOrderEntity.h"
#import "HXSBoxOrderModel.h"

@implementation HXSMyOderFooterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark- Setter Methods

- (void)setOrderInfo:(HXSOrderInfo *)orderInfo
{
    self.numLabel.text = [NSString stringWithFormat:@"共%d件商品", orderInfo.food_num.intValue];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"¥%.2f", orderInfo.order_amount.floatValue];
    
    if (orderInfo.discount.floatValue > 0) {
        self.discountLabel.text = [NSString stringWithFormat:@"优惠：¥%.2f", orderInfo.discount.floatValue];
    }
    else {
        self.discountLabel.text = @"";
    }
}

- (void)setBoxOrderEntity:(HXSBoxOrderEntity *)boxOrderEntity
{
    self.numLabel.text = [NSString stringWithFormat:@"共%d件商品", boxOrderEntity.foodNum.intValue];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"¥%.2f", boxOrderEntity.orderAmount.floatValue];
    
    if (boxOrderEntity.totalDiscount.floatValue > 0) {
        self.discountLabel.text = [NSString stringWithFormat:@"优惠：¥%.2f", boxOrderEntity.totalDiscount.floatValue];
    }
    else {
        self.discountLabel.text = @"";
    }
}


#pragma mark - PrintOrder
-(void)setPrintOrderInfo:(HXSPrintOrderInfo *)printOrderInfo{
    self.numLabel.text = [NSString stringWithFormat:@"共%d份",printOrderInfo.printIntNum.intValue];
    if (printOrderInfo.discountDoubleNum.doubleValue > 0){
        self.discountLabel.text = [NSString stringWithFormat:@"折扣：¥%.2f", printOrderInfo.discountDoubleNum.floatValue];
    }else{
        self.discountLabel.text = @"";
    }
    self.totalAmountLabel.text = [NSString stringWithFormat:@"￥%.2f",printOrderInfo.orderAmountDoubleNum.doubleValue];
}

- (void)setStoreOrderEntity:(HXSStoreOrderEntity *)storeOrderEntity {
    self.numLabel.text = [NSString stringWithFormat:@"共%ld件商品",  (long)storeOrderEntity.itemNum];

    self.totalAmountLabel.text = [NSString stringWithFormat:@"¥%.2f", storeOrderEntity.orderAmount.floatValue];
    if (storeOrderEntity.totalDiscount.floatValue > 0.0) {
        self.discountLabel.text = [NSString stringWithFormat:@"优惠：¥%.2f", storeOrderEntity.totalDiscount.floatValue];
    } else {
        self.discountLabel.hidden = YES;
    }
}

- (void)setBoxOrderModel:(HXSBoxOrderModel *)boxOrderModel{
    _boxOrderModel = boxOrderModel;
    
    self.numLabel.text = [NSString stringWithFormat:@"共%ld件商品",  (long)boxOrderModel.itemsArr.count];
    
    self.totalAmountLabel.text = [NSString stringWithFormat:@"¥%.2f", boxOrderModel.orderAmountDoubleNum.floatValue];
    if (boxOrderModel.couponAmountDoubleNum.floatValue > 0.0) {
        self.discountLabel.text = [NSString stringWithFormat:@"优惠：¥%.2f", boxOrderModel.couponAmountDoubleNum.floatValue];
    } else {
        self.discountLabel.hidden = YES;
    }
}

@end

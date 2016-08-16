//
//  HXSDormCartTableViewCell.m
//  store
//
//  Created by chsasaw on 15/3/7.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSDormCartTableViewCell.h"

@implementation HXSDormCartTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.countView.delegate = self;
}

- (void)dealloc
{
    self.cartCellDelegate = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCartItem:(HXSFloatingCartEntity *)item
{
    if(item.itemIDNum)
    {
        self.itemId = item.itemIDNum;
    }
    if(item.productIDStr)
    {
        self.productIDStr = item.productIDStr;
    }

    [self.titleLabel setText:item.nameStr];
    [self.errorInfo setText:item.errorInfoStr];
    [self.countView setCount:item.quantityNum.intValue animated:YES manual:NO];
    if(item.stockNum)
    {
        [self.countView setMaxCount:item.stockNum];
    }
    [self.amountLabel setText:[NSString stringWithFormat:@"%.2f", item.priceNum.floatValue]];
}

#pragma mark - HXSDormCountSelectViewDelegate

- (void)countAdd
{
    if(self.itemId)
    {
        [self.cartCellDelegate dormCartCell:self
                                 udpateItem:self.itemId
                                   quantity:[NSNumber numberWithInt:[_countView getCount]]];
    }
    else if (self.productIDStr)
    {
        [self.cartCellDelegate dormCartCell:self
                              udpateProduct:self.productIDStr
                                   quantity:[NSNumber numberWithInt:[_countView getCount]]];
    }
}

- (void)countSelectView:(HXSDormCountSelectView *)countView didEndEdit:(int)count
{
    if(self.itemId) {
        if(count == 0) {
            [MobClick event:@"dorm_remove_cart" attributes:@{@"item_id":self.itemId}];
        }
        
        [self.cartCellDelegate dormCartCell:self
                                 udpateItem:self.itemId
                                   quantity:[NSNumber numberWithInt:[countView getCount]]];
    }
    else if (self.productIDStr)
    {
        if(count == 0) {
            [MobClick event:@"dorm_remove_cart" attributes:@{@"product_id":self.productIDStr}];
        }
        
        [self.cartCellDelegate dormCartCell:self
                              udpateProduct:self.productIDStr
                                   quantity:[NSNumber numberWithInt:[countView getCount]]];
    }
}

@end

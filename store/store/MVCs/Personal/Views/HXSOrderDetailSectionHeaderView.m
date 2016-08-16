//
//  HXSOrderDetailSectionHeaderView.m
//  store
//
//  Created by ranliang on 15/5/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSOrderDetailSectionHeaderView.h"
#import "HXSPrintOrderInfo.h"

@interface HXSOrderDetailSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;

@end

@implementation HXSOrderDetailSectionHeaderView

- (void)setNumberOfItems:(NSInteger)numberOfItems
{
    _quantityLabel.text = [NSString stringWithFormat:@"商品共%ld件", (long)numberOfItems];
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

-(void)setPrintOrderEntity:(HXSPrintOrderInfo *)printOrderEntity{
    
    _printOrderEntity = printOrderEntity;
    _quantityLabel.text = [NSString stringWithFormat:@"共%d份",printOrderEntity.printIntNum.intValue];
}

@end

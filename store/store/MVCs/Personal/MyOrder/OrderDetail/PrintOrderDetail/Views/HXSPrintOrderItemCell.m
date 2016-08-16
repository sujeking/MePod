//
//  HXSPrintOrderItemCell.m
//  store
//
//  Created by 格格 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintOrderItemCell.h"

@interface HXSPrintOrderItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleDetialLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalPriceLabel;

@end

@implementation HXSPrintOrderItemCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setPrintOrderItem:(HXSMyPrintOrderItem *)printOrderItem{
    _printOrderItem = printOrderItem;
    self.nameLabel.text = printOrderItem.fileNameStr ?printOrderItem.fileNameStr:@"";
    self.titleDetialLabel.text = printOrderItem.specificationsStr ?printOrderItem.specificationsStr:@"";
    self.unitPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",printOrderItem.priceDoubleNum.doubleValue];
    self.countLabel.text = [NSString stringWithFormat:@"x%d",printOrderItem.quantityIntNum.intValue];
    self.subtotalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",printOrderItem.amountDoubleNum.doubleValue];
}

@end

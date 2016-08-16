//
//  HXSBoxCheckCell.m
//  store
//
//  Created by 格格 on 16/6/1.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxCheckCell.h"

@interface HXSBoxCheckCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *numLabel;

@end

@implementation HXSBoxCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setBoxItem:(HXSDormItem *)boxItem{
    _boxItem = boxItem;
    self.nameLabel.text = boxItem.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",boxItem.price.doubleValue];
    self.numLabel.text = [NSString stringWithFormat:@"x%d",boxItem.quantity.intValue];
}

@end

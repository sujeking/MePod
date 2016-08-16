//
//  HXSTaskDetialGoodsCell.m
//  store
//
//  Created by 格格 on 16/4/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTaskDetialGoodsCell.h"

@interface HXSTaskDetialGoodsCell()

@property (nonatomic, weak) IBOutlet UIImageView *goodsImageView; // 商品图片
@property (nonatomic, weak) IBOutlet UILabel *goodsNameLabel; // 商品名称
@property (nonatomic, weak) IBOutlet UILabel *priceLabel; // 商品价格
@property (nonatomic, weak) IBOutlet UILabel *numLabel; // 商品数量


@end

@implementation HXSTaskDetialGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTaskItem:(HXSTaskItem *)taskItem{
    _taskItem = taskItem;
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:taskItem.imageStr] placeholderImage:[UIImage imageNamed:@"img_kp_list"]];
    _goodsNameLabel.text = taskItem.nameStr;
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",taskItem.priceDoubleNum.doubleValue ];
    _numLabel.text = [NSString stringWithFormat:@"x%d",taskItem.quantityIntNum.intValue];
}

@end

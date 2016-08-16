//
//  HXSBankListCell.m
//  store
//
//  Created by 格格 on 16/5/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBankListCell.h"

@interface HXSBankListCell ()

@property (nonatomic, weak) IBOutlet UIImageView *bankImageView;
@property (nonatomic, weak) IBOutlet UILabel     *bankNameLabel;

@end

@implementation HXSBankListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setBankEntity:(HXSBankEntity *)bankEntity{
    _bankEntity = bankEntity;
    [_bankImageView sd_setImageWithURL:[NSURL URLWithString:bankEntity.imageStr]];
    _bankNameLabel.text = bankEntity.nameStr;
}
@end

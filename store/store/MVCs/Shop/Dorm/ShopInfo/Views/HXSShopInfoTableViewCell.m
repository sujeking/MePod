//
//  HXSShopInfoTableViewCell.m
//  store
//
//  Created by  黎明 on 16/7/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopInfoTableViewCell.h"

@implementation HXSShopInfoTableViewCellModel

@end


@interface HXSShopInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HXSShopInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];    
}

- (void)setDataModel:(HXSShopInfoTableViewCellModel *)dataModel
{
    self.titleLabel.text = dataModel.titleStr;
    if (dataModel.imgurlStr)
    {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.imgurlStr]];
    }
    else
    {
        [self.iconImageView setImage:[UIImage imageNamed:@"ic_notice"]];
    }
}

@end

//
//  HXSBoxOwnerInfoView.m
//  store
//
//  Created by  黎明 on 16/6/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxOwnerInfoView.h"
#import "HXSBoxInfoEntity.h"

@interface HXSBoxOwnerInfoView()

/**
 *  盒子名称
 */
@property (weak, nonatomic) IBOutlet UILabel *boxOwnerTitleLabel;
/**
 *  盒主名字
 */
@property (weak, nonatomic) IBOutlet UILabel *boxOwnerNameLabel;
/**
 *  分享人数
 */
@property (weak, nonatomic) IBOutlet UILabel *boxSharedNumLabel;
/**
 *  盒主头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *boxOwnerAvatarImageView;

@property (strong, nonatomic) HXSBoxInfoEntity * modelEntitty;

@end

@implementation HXSBoxOwnerInfoView


+ (HXSBoxOwnerInfoView *)initFromXib
{
    HXSBoxOwnerInfoView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSBoxOwnerInfoView class])
                                                              owner:nil options:nil].firstObject;
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    return view;
}


- (void)awakeFromNib
{
    [self setupSubViewStyle];
}

/**
 *  设置控件样式
 */
- (void)setupSubViewStyle
{
    self.boxOwnerAvatarImageView.layer.borderColor   = [[UIColor colorWithRed:0.416 green:0.796 blue:0.988 alpha:1.000] CGColor];
    self.boxOwnerAvatarImageView.layer.borderWidth   = 3.0f;
    self.boxOwnerAvatarImageView.layer.cornerRadius  = CGRectGetWidth(self.boxOwnerAvatarImageView.bounds)/2;
    self.boxOwnerAvatarImageView.layer.masksToBounds = YES;
}

- (void)initialBoxInfo:(HXSBoxInfoEntity *)boxInfoEntity{
    self.modelEntitty = boxInfoEntity;
}

- (void)setModelEntitty:(HXSBoxInfoEntity *)modelEntitty{
    _modelEntitty = modelEntitty;
    if(modelEntitty.statusNum.intValue >= kHXSBoxStatusChecking)
        self.boxOwnerTitleLabel.text = [NSString stringWithFormat:@"%@的零食盒(清点中)",modelEntitty.boxerInfo.userNameStr];
    else
        self.boxOwnerTitleLabel.text = [NSString stringWithFormat:@"%@的零食盒",modelEntitty.boxerInfo.userNameStr];
    
    self.boxOwnerNameLabel.text = [NSString stringWithFormat:@"盒主：%@",modelEntitty.boxerInfo.userNameStr];
    self.boxSharedNumLabel.text = [NSString stringWithFormat:@"共享伙伴%d人",modelEntitty.sharedUserNum.intValue];
    
    [self.boxOwnerAvatarImageView sd_setImageWithURL:[NSURL URLWithString:modelEntitty.boxerAvatarStr] placeholderImage:[UIImage imageNamed:@"img_headsculpture_small"]];
}


@end

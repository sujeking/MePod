//
//  HXSUpgradeCreditTableViewCell.m
//  store
//
//  Created by  黎明 on 16/7/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSUpgradeCreditTableViewCell.h"

@implementation HXSUpgradeCreditTableViewCellModel

@end


@interface HXSUpgradeCreditTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *accessoryButton;
@property (nonatomic, weak) IBOutlet UIView *accessoryDoneView;
@property (nonatomic, weak) IBOutlet UIImageView *accessoryImageView;

@end

@implementation HXSUpgradeCreditTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.accessoryButton.backgroundColor = [UIColor whiteColor];
    self.accessoryButton.layer.cornerRadius = 3.5f;
    self.accessoryButton.layer.borderWidth = 1.0f;
    [self.accessoryButton setTitleColor:[UIColor colorWithRed:0.086 green:0.686 blue:0.988 alpha:1.000] forState:UIControlStateNormal];
    self.accessoryButton.userInteractionEnabled = YES;
    self.accessoryButton.layer.borderColor = [[UIColor colorWithRed:0.082 green:0.591 blue:0.974 alpha:1.000] CGColor];
    
    self.accessoryDoneView.hidden = YES;
    self.accessoryImageView.hidden = YES;
    self.accessoryImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardImageViewTap:)];
    [self.accessoryImageView addGestureRecognizer:tapGestureRecognizer];
}


- (void)setModel:(HXSUpgradeCreditTableViewCellModel *)model
{
    _model = model;
    if (model.cellDoneNum.boolValue) {
        self.accessoryDoneView.hidden = NO;
        self.accessoryButton.hidden = YES;
        
        if (   model.cellTypeNum == HXSCellTypeNumIDCardUP
            || model.cellTypeNum == HXSCellTypeNumIDCardDown
            || model.cellTypeNum == HXSCellTypeNumIDCardHandle ) {
            
            [self.accessoryImageView sd_setImageWithURL:[NSURL URLWithString:model.cellImageURLStr]];
            
            self.accessoryDoneView.hidden = YES;
            self.accessoryImageView.hidden = NO;
        }
    } else {
        self.accessoryDoneView.hidden = YES;
        [self.accessoryButton setTitle:model.cellButtonTitleStr forState:UIControlStateNormal];
        self.accessoryButton.hidden = NO;
    }
    
    self.titleLabel.text = model.cellLabelTitleStr;
}

- (void)cardImageViewTap:(UIGestureRecognizer *)sender
{
    UIImageView *imageView =(UIImageView *)[sender view];
    if (self.delegate && [self.delegate respondsToSelector:@selector(upgradeCreditTableViewCellImageViewTap:)])
    {
        [self.delegate performSelector:@selector(upgradeCreditTableViewCellImageViewTap:)
                            withObject:imageView];
    }
}


- (IBAction)authButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(upgradeCreditTableViewCellButtonClick:)])
    {
        [self.delegate performSelector:@selector(upgradeCreditTableViewCellButtonClick:)
                            withObject:self.model];
    }
}
@end

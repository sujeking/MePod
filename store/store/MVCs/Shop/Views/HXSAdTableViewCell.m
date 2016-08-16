//
//  HXSAdTableViewCell.m
//  store
//
//  Created by  黎明 on 16/7/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSAdTableViewCell.h"
// Model
#import "HXSStoreAppEntryEntity.h"

@interface HXSAdTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *adLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *adRightTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *adRightBottomImageView;

@property (copy, nonatomic) NSString *linkURL;
@property (copy, nonatomic) NSArray *adModelArray;

@end

@implementation HXSAdTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setupStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setupStyle
{
    UITapGestureRecognizer *tapGestureRecognizerLeft        = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTagAction:)];
    UITapGestureRecognizer *tapGestureRecognizerRightTop    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTagAction:)];
    UITapGestureRecognizer *tapGestureRecognizerRightBottom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTagAction:)];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.adLeftImageView setImage:[UIImage imageNamed:@"img_kp_shouyejiazai_left"]];
    [self.adRightTopImageView setImage:[UIImage imageNamed:@"img_kp_shouyejiazai_right"]];
    [self.adRightBottomImageView setImage:[UIImage imageNamed:@"img_kp_shouyejiazai_right"]];
    
    [self.adLeftImageView setUserInteractionEnabled:YES];
    [self.adRightTopImageView setUserInteractionEnabled:YES];
    [self.adRightBottomImageView setUserInteractionEnabled:YES];

    [self.adLeftImageView addGestureRecognizer:tapGestureRecognizerLeft];
    [self.adRightTopImageView addGestureRecognizer:tapGestureRecognizerRightTop];
    [self.adRightBottomImageView addGestureRecognizer:tapGestureRecognizerRightBottom];
}

- (void)setupItemImages:(NSArray<HXSStoreAppEntryEntity *> *)slideItemsArr
{
    if (0 == slideItemsArr.count) {
        return;
    }
    
    _adModelArray = slideItemsArr;
    
    NSURL *url = nil;
    
    for (HXSStoreAppEntryEntity *model in slideItemsArr) {
        NSInteger index = [slideItemsArr indexOfObject:model];
        url = [NSURL URLWithString:model.imageURLStr];
        if (0 == index) {
            [self.adLeftImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_kp_shouyejiazai_left"]];
        } else if (1 == index) {
            [self.adRightTopImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_kp_shouyejiazai_right"]];
        } else {
             [self.adRightBottomImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_kp_shouyejiazai_right"]];
        }
    }
}

- (void)imageViewTagAction:(UITapGestureRecognizer*)sender
{
    UIImageView *imageView = (UIImageView *)[sender view];
    
    NSInteger tag = imageView.tag;
    
    HXSStoreAppEntryEntity *adModel = self.adModelArray[tag - 1];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AdTableViewCellImageTaped:)])
    {
        [self.delegate performSelector:@selector(AdTableViewCellImageTaped:) withObject:adModel.linkURLStr];
    }
}

+ (CGFloat)getCellHeightWithObject:(HXSStoreAppEntryEntity *)storeAppEntryEntity
{
    CGFloat scale = [storeAppEntryEntity.imageHeightIntNum floatValue]/[storeAppEntryEntity.imageWidthIntNum floatValue];
    HXSAdTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    return CGRectGetWidth(cell.bounds) / 3 * scale + 30;
}
@end

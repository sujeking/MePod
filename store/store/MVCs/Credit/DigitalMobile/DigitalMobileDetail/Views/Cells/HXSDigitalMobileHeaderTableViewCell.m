//
//  HXSDigitalMobileHeaderTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileHeaderTableViewCell.h"

#import "HXSDigitalMobileDetailEntity.h"
#import "UIButton+AFNetworking.h"

static NSInteger const kHeightNormalCell    = 330;
static NSInteger const kHeightSupplierMax   = 52;
static NSInteger const kHeightSupplierMin   = 10;
static NSInteger const kHeightImageView     = 200;
static NSInteger const kHeightPromotionView = 32;

@interface HXSDigitalMobileHeaderTableViewCell () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *promotionScrollView;
/** “本商品货源来自苏宁易购，正品保证！” */
@property (weak, nonatomic) IBOutlet UILabel *supplierLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supplierLabelTopConstraint;


@end

@implementation HXSDigitalMobileHeaderTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    self.scrollView.delegate = nil;
}


#pragma mark - Public Methods

+ (CGFloat)heightOfHeaderViewForOrder:(HXSDigitalMobileDetailEntity *)detailEntity
{
    CGFloat heightOfCell = kHeightNormalCell;
    int padding = 30;
    
    CGFloat nameLabelHeight = [detailEntity.nameStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - padding, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                          context:nil].size.height;
    heightOfCell += nameLabelHeight;
    
    if (0 >= [detailEntity.promotionsArr count]) {
        heightOfCell -= kHeightSupplierMax - kHeightSupplierMin;
    }
    
    return heightOfCell;
}

- (void)setupCellWithEntity:(HXSDigitalMobileDetailEntity *)detailEntity
{
    // 图片
    [self createImageScroll:detailEntity.imagesArr];
    [self.pageControl setNumberOfPages:[detailEntity.imagesArr count]];
    [self.scrollView setDelegate:self];
    
    // 名字
    self.nameLabel.text = detailEntity.nameStr;
    
    // 价格
    self.priceLabel.text = detailEntity.priceStr;
    
    // 推荐
    if (0 < [detailEntity.promotionsArr count]) {
        [self.promotionScrollView setHidden:NO];
        
        [self createPromotionScroll:detailEntity.promotionsArr];
    } else {
        [self.promotionScrollView setHidden:YES];
        self.supplierLabelTopConstraint.constant = kHeightSupplierMin;
    }
    
    // 供货商
    self.supplierLabel.text = [NSString stringWithFormat:@"本商品货源来自%@，正品保证！", detailEntity.supplierStr];
}


#pragma mark - Private Methods

- (void)createImageScroll:(NSArray *)imageArr
{
    UIView *lastestView = nil;
    
    for (UIView *view in [self.scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < [imageArr count]; i++) {
        HXSDigitalMobileDetailImageEntity *imageEntity = [imageArr objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageEntity.imageURLStr]
                     placeholderImage:[UIImage imageNamed:@"img_kp_3c"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.scrollView addSubview:imageView];
        
        if (0 == i) { // first one
            if (1 < [imageArr count]) {
                [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(self.width);
                    make.height.mas_equalTo(kHeightImageView);
                    make.top.left.bottom.mas_equalTo(self.scrollView);
                }];
            } else {
                [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(self.width);
                    make.height.mas_equalTo(kHeightImageView);
                    make.edges.mas_equalTo(self.scrollView);
                }];
            }
            
            lastestView = imageView;
        } else if (([imageArr count] - 1) == i)  {// last one
            [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.width);
                make.height.mas_equalTo(kHeightImageView);
                make.left.mas_equalTo(lastestView.mas_right);
                make.top.bottom.right.mas_equalTo(self.scrollView);
            }];
            
            lastestView = nil;
        } else {
            [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.width);
                make.height.mas_equalTo(kHeightImageView);
                make.left.mas_equalTo(lastestView.mas_right);
                make.top.bottom.mas_equalTo(self.scrollView);
            }];
            
            lastestView = imageView;
        }
        
        [self.scrollView layoutIfNeeded];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.width * [imageArr count], kHeightImageView);
}

- (void)createPromotionScroll:(NSArray *)promotionArr
{
    UIButton *lastButton = nil;
    CGFloat padding      = 15.0f;
    CGFloat totalWidth   = 0.0f;
    
    for (UIView *view in [self.promotionScrollView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < [promotionArr count]; i++) {
        HXSDigitalMobileDetailPromotionEntity *promotionEntity = [promotionArr objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.userInteractionEnabled = NO;
        button.backgroundColor = [UIColor clearColor];
        [button setImageForState:UIControlStateNormal
                         withURL:[NSURL URLWithString:promotionEntity.promotionImageURLStr]
                placeholderImage:nil];
        [button setTitle:promotionEntity.promotionNameStr forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [button setTitleColor:[UIColor colorWithRGBHex:0xADADAD] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        
        [self.promotionScrollView addSubview:button];
        
        CGFloat titleWidth = [promotionEntity.promotionNameStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kHeightPromotionView)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}
                                                                     context:nil].size.width;
        
        titleWidth += 25; // 25 is width of image & padding
        
        if (0 == i) { // first one
            if (1 < [promotionArr count]) {
                [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(titleWidth);
                    make.height.mas_equalTo(kHeightPromotionView);
                    make.top.bottom.equalTo(self.promotionScrollView);
                    make.left.equalTo(self.promotionScrollView.mas_left).with.mas_offset(padding);
                }];
            } else {
                [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(titleWidth);
                    make.height.mas_equalTo(kHeightPromotionView);
                    make.top.bottom.equalTo(self.promotionScrollView);
                    make.left.equalTo(self.promotionScrollView.mas_left).with.mas_offset(padding);
                    make.right.equalTo(self.promotionScrollView.mas_right).with.mas_offset(-padding);
                }];
            }
            
            lastButton = button;
        } else if (([promotionArr count] - 1) == i)  {// last one
            [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(titleWidth);
                make.height.mas_equalTo(kHeightPromotionView);
                make.left.equalTo(lastButton.mas_right).with.mas_offset(padding);
                make.top.bottom.equalTo(self.promotionScrollView);
                make.right.equalTo(self.promotionScrollView.mas_right).with.mas_offset(-padding);
            }];
            
            lastButton = nil;
        } else {
            [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(titleWidth);
                make.height.mas_equalTo(kHeightPromotionView);
                make.left.equalTo(lastButton.mas_right).with.mas_offset(padding);
                make.top.bottom.equalTo(self.promotionScrollView);
            }];
            
            lastButton = button;
        }
        
        [self.promotionScrollView layoutIfNeeded];
        
        totalWidth += titleWidth;
    }
    
    self.promotionScrollView.contentSize = CGSizeMake(totalWidth, kHeightPromotionView);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x < 0) {
        return;
    }
    
    int page = (int)scrollView.contentOffset.x / scrollView.width;
    
    [self.pageControl setCurrentPage:page];
}


@end

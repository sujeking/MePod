//
//  HXSBoxSnacksTableViewCell.m
//  store
//
//  Created by  黎明 on 16/6/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxSnacksTableViewCell.h"
#import "HXSBoxMacro.h"
#import <SDWebImageCompat.h>
#import "UIButton+HXSUIButoonHitExtensions.h"

@interface HXSBoxSnacksTableViewCell()

@end

static NSString * const RMB = @"￥";
static NSString * const STOCK = @"库存";
#define TAB_BAR_HEIGHT 49


@implementation HXSBoxSnacksTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - init Method

- (void)initSubViews
{
    self.subtractButton.hidden = YES;
    self.goodsAmountLabel.text = nil;
    
    [_plusButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];//增加触摸热点范围
    [self.plusButton addTarget:self action:@selector(plusGoodsToCar) forControlEvents:UIControlEventTouchUpInside];
    [self.subtractButton addTarget:self action:@selector(subGoodsFromCar) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action method

/**
 *  添加商品到购物车
 */
- (void)plusGoodsToCar
{
    NSInteger quantity  = self.boxItemModel.quantityNum.integerValue;
    quantity += 1;

    if(quantity > _boxItemModel.stockNum.integerValue)
    {
        return;
    }
    
    [self plusGoodsToCarAnimation];
    [HXSUsageManager trackEvent:kUsageEventBoxCarAdd parameter:@{@"trigger_point":@"商品列表"}];
    
    self.boxItemModel.quantityNum = @(quantity);

    [self.boxCarManager updateCartWithItem:self.boxItemModel];

    if (self.boxItemModel.quantityNum.integerValue != 0)
    {
        self.subtractButton.hidden = NO;
        self.goodsAmountLabel.text = [NSString stringWithFormat:@"%zd",self.boxItemModel.quantityNum.integerValue];
        
        if(self.updateSnackBoxCarBlock)
        {
            self.updateSnackBoxCarBlock();
        }
    }
}

/**
 *  从购物车里面减去商品
 */
- (void)subGoodsFromCar
{
    [HXSUsageManager trackEvent:kUsageEventBoxCarReduce parameter:@{@"trigger_point":@"商品列表"}];
    
    NSInteger quantity  = self.boxItemModel.quantityNum.integerValue;
    quantity --;
    
    if(quantity < 0)
    {
        quantity = 0;
    }
    
    self.boxItemModel.quantityNum = @(quantity);
    
    [self.boxCarManager updateCartWithItem:self.boxItemModel];
    
    
    if (self.boxItemModel.quantityNum.integerValue != 0)
    {
        self.goodsAmountLabel.text = [NSString stringWithFormat:@"%zd",self.boxItemModel.quantityNum.integerValue];
    }
    else
    {
        self.subtractButton.hidden = YES;
        self.goodsAmountLabel.text = nil;
    }
    
    if(self.updateSnackBoxCarBlock)
    {

        self.updateSnackBoxCarBlock();
    }
}

/**
 *  商品进入购物车动画
 */
- (void)plusGoodsToCarAnimation
{
    UIImageView * imageView   = [[UIImageView alloc] initWithFrame:self.goodsImageView.frame];
    imageView.image           = self.goodsImageView.image;
    imageView.contentMode     = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor blackColor];
    UIWindow * window         = [UIApplication sharedApplication].windows[0];
    
    imageView.frame = [window convertRect:self.goodsImageView.frame fromView:self.goodsImageView.superview];
    
    [window addSubview:imageView];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
    {
        imageView.frame = CGRectMake(30, SCREEN_HEIGHT - TAB_BAR_HEIGHT, 1, 1);
        
    } completion:^(BOOL finished)
    {
        [imageView removeFromSuperview];
    }];
}

- (void)dealloc
{
    self.boxCarManager = nil;
}

#pragma mark - GET SET


- (void)setBoxItemModel:(HXSBoxOrderItemModel *)boxItemModel
{
    _boxItemModel = boxItemModel;
    self.goodsNameLabel.text = boxItemModel.nameStr;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ %.2f",RMB,boxItemModel.priceDoubleNum.floatValue];
    self.goodsStockLabel.text = [NSString stringWithFormat:@"%@ %zd",STOCK,boxItemModel.stockNum.integerValue];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:boxItemModel.imageThumbStr] placeholderImage:nil];
    
    if (boxItemModel.stockNum.integerValue == 0)
    {
        [self.plusButton setBackgroundImage:[UIImage imageNamed:@"ic_plus_grid_disable"] forState:UIControlStateNormal];
        self.plusButton.userInteractionEnabled = NO;
    }
    else
    {
        [self.plusButton setBackgroundImage:[UIImage imageNamed:@"ic_plus_grid_normal"] forState:UIControlStateNormal];
        self.plusButton.userInteractionEnabled = YES;
    }
    
    
    if ([self.boxCarManager isEmpty])
    {
        self.subtractButton.hidden = YES;

        self.goodsAmountLabel.text = nil;
    }
    else
    {
        for (HXSBoxOrderItemModel *model in [self.boxCarManager getBoxAllItems])
        {
            if ([model.productIdStr isEqual:self.boxItemModel.productIdStr])
            {
                if (model.quantityNum.integerValue == self.boxItemModel.stockNum.integerValue)
                {
                    [self.plusButton setBackgroundImage:[UIImage imageNamed:@"ic_plus_grid_disable"] forState:UIControlStateNormal];
                    self.plusButton.userInteractionEnabled = NO;
                }
                else
                {
                    [self.plusButton setBackgroundImage:[UIImage imageNamed:@"ic_plus_grid_normal"] forState:UIControlStateNormal];
                    self.plusButton.userInteractionEnabled = YES;
                }
                
                if (model.quantityNum.integerValue != 0)
                {
                    self.subtractButton.hidden = NO;
                    self.goodsAmountLabel.text = [NSString stringWithFormat:@"%zd",model.quantityNum.integerValue];
                }
                else
                {
                    self.subtractButton.hidden = YES;
                    self.goodsAmountLabel.text = nil;
                }
            }
        }
    }
}


- (CGRect )getGoodsImageViewRect
{
    return self.goodsImageView.frame;
}

@end

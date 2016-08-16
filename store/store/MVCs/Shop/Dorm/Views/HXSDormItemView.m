//
//  HXSDormItemView.m
//  store
//
//  Created by chsasaw on 15/2/9.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSDormItemView.h"

// Controllers
#import "HXSShopViewController.h"
#import "HXSBoxOrderModel.h"

// Models
#import "HXSShop.h"
#import "HXSDormItem.h"
#import "HXSDormCartItem.h"
#import "HXSShopEntity.h"

// Others
#import "HXSShopManager.h"
#import "HXSDormCartManager.h"
#import "HXSegmentControl.h"

static NSInteger scrollViewImageViewsStartTag = 100;
static NSInteger const kPromotionLableHeight  = 14;

@interface HXSDormItemView()<HXSDormCountSelectViewDelegate>

@property (nonatomic, strong) HXSDormItem *item;
@property (nonatomic, copy) NSNumber * cartItemId;
@property (nonatomic, assign) CGFloat scrollViewWidth;
@property (nonatomic, assign) NSInteger numberOfImages;
@property (nonatomic, strong) HXSShopEntity *shopEntity;

@end

@implementation HXSDormItemView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //因为在执行完毕layoutSubviews之后，子控件才能获得正确的frame，所以之前在setItem里面对scrollView里面的图片和scrollView的contentSize设置无效，需要在此处重设
    for (int i = 0; i < _numberOfImages; i++) {
        UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:i + scrollViewImageViewsStartTag];
        CGRect frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        imageView.frame = frame;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * _numberOfImages, self.scrollView.frame.size.height);

}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.layer.masksToBounds = YES;
    
    self.descScrollView.hidden = YES;
    
    self.pageControl.userInteractionEnabled = NO;
    [self.pageControl addTarget:self action:@selector(handleClickPageControl:) forControlEvents:UIControlEventTouchUpInside];
    
    self.countView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartUpdated:) name:kUpdateDormCartComplete object:nil];
    
}

- (void)cartUpdated:(NSNotification *)notification
{
    HXSShopManager *shopManager = [HXSShopManager shareManager];
    HXSShopType shopType = [shopManager.currentEntry.shopEntity.shopTypeIntNum intValue];
    
    if (kHXSShopTypeDorm == shopType) {
        if(_item) {
            [self setItem:_item shop:self.shopEntity];
        }
    }
}

- (void)handleClickPageControl:(id)sender
{
    
}

- (void)setItem:(HXSDormItem *)item shop:(HXSShopEntity *)shopEntity
{
    _item = item;
    _shopEntity = shopEntity;
    
    HXSDormCartItem * cartItem = [[HXSDormCartManager sharedManager] getCartItemOfDormItem:item];
    
    self.titleLabel.text = item.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.item.price floatValue]];
    self.descLabel.text = item.tip;
    self.descriptionLabel.text = item.descriptionStr;
    
    if ((0 < [item.tip length])
        || (0 < [item.descriptionStr length])) {
        self.descScrollView.hidden = NO;
        
        if (0 < [item.descriptionStr length]) {
            self.descriptionLabelHeightConstraint.constant = 14;
        } else {
            self.descriptionLabelHeightConstraint.constant = 0;
        }
    }
    
    self.cartItemId = nil;
    
    HXSShopStatus status = (HXSShopStatus)[shopEntity.statusIntNum integerValue];
    
    if(status == kHXSShopStatusClosed) {
        [self.countView setStatus:kHXSDormItemStatusClosed animated:NO];
    } else if(item.has_stock) {
        self.countView.status = kHXSDormItemStatusNormal;
        if(cartItem) {
            self.cartItemId = cartItem.itemId;
            [self.countView setCount:cartItem.quantity.intValue animated:NO manual:NO];
        } else {
            [self.countView setCount:0 animated:NO manual:NO];
        }
    } else {
        [self.countView setStatus:kHXSDormItemStatusLackStock animated:NO];
    }
    
    [self foodScrollViewSetItem:item];
    
    
    int x = 0;
    for(UIView * view in self.promotionLabelsContainer.subviews) {
        [view removeFromSuperview];
    }
    
    for(int i=0; i < [item.promotions count]; i++) {
        HXSClickEvent * event = [item.promotions objectAtIndex:i];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (0 == i%2) {
            [button setBackgroundColor:UIColorFromRGB(0x06CEA3)];
        } else {
            [button setBackgroundColor:UIColorFromRGB(0xFFC107)];
        }
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setTitle:event.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.promotionLabelsContainer addSubview:button];
        
        CGSize size = [button sizeThatFits:self.promotionLabelsContainer.frame.size];
        button.frame = CGRectMake(x, 0, MIN(size.width + 10, 100), kPromotionLableHeight);
        x += button.frame.size.width + 8;
        
        button.tag = [item.promotions indexOfObject:event];
        
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2.0f;
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        button.enabled = event.eventUrl.length > 0;
    }
    
    if (0 < [item.promotions count]) {
        [self.promotionLabelsContainer setHidden:NO];
    } else {
        [self.promotionLabelsContainer setHidden:YES];
    }
    
    [self layoutIfNeeded];
}

- (void)setBoxOrderItem:(HXSBoxOrderItemModel *)boxOrderItemModel
{
    HXSDormItem *item = [[HXSDormItem alloc]initWithItem:boxOrderItemModel];
    _item = item;
    
    self.titleLabel.text = item.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.item.price floatValue]];
    self.descLabel.text = item.description_content;
    self.descriptionLabel.text = item.descriptionStr;
    if ((0 < [item.tip length])
        || (0 < [item.descriptionStr length]))
    {
        self.descScrollView.hidden = NO;
        
        if (0 < [item.descriptionStr length])
        {
            self.descriptionLabelHeightConstraint.constant = 14;
        }
        else
        {
            self.descriptionLabelHeightConstraint.constant = 0;
        }
    }
    
    self.countView.status = kHXSDormItemStatusNormal;
    [self.countView setMaxCount:item.stock];
    [self.countView setCount:item.quantity.intValue animated:NO manual:NO];
    
    [self foodScrollViewSetItem:item];
    
    [self layoutIfNeeded];
}

- (void)foodScrollViewSetItem:(HXSDormItem *)item
{
    [self.scrollView setContentSize:CGSizeZero];
    
    //如果item的images里面没有内容，就把image_big添加到images array中
    if ([item isKindOfClass:[HXSDormItem class]]) {
        
    } else if([item isKindOfClass:[HXSBoxOrderItemModel class]]) {
        //  do nothing
    }
    
    if (item.images.count == 0) {

        item.images = [NSMutableArray arrayWithObject:item.image_big.length > 0 ? item.image_big : @""];
    }
    //判断一下是否设置了scrollView的placeholder图像
    UIImage *placeholderImage = self.scrollViewPlaceHolderImage ? self.scrollViewPlaceHolderImage : [UIImage imageNamed:@"img_kp_banner_cat"];
    
    NSArray *imagesArr = [NSArray arrayWithObjects:
                          [UIImage imageNamed:@"ic_circle_solid_gray"],
                          [UIImage imageNamed:@"ic_circle_hollow_gray"], nil];
    [self.pageControl updateImages:imagesArr];
    
    if(item.images && item.images.count > 0) {
        int i =0;
        for(NSString * imageUrl in item.images) {
            CGRect frame = self.scrollView.bounds;
            frame.origin.x = self.scrollView.bounds.size.width * i++;
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
            imageView.backgroundColor = [UIColor blackColor];
            imageView.tag = i-1 + scrollViewImageViewsStartTag;
            _numberOfImages = i;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]  placeholderImage:placeholderImage ];
            [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
            [self.scrollView addSubview:imageView];
            [self.scrollView sendSubviewToBack:imageView];
            
            imageView.userInteractionEnabled = YES;
        }
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width*i, self.scrollView.frame.size.height)];
        
        self.pageControl.numberOfPages = i;
        self.pageControl.currentPage = 0;
    } else {
        
        self.pageControl.numberOfPages = 0;
        self.pageControl.currentPage = 0;
    }
}

- (void)countSelectView:(HXSDormCountSelectView *)countView didEndEdit:(int)count
{
    [HXSUsageManager trackEvent:kUsageEventFoodDetialInfoChangeNum parameter:@{@"business_type":@"夜猫店"}];
    
    HXSShopManager *shopManager = [HXSShopManager shareManager];
    HXSShopType shopType = [shopManager.currentEntry.shopEntity.shopTypeIntNum intValue];
    
    if(self.cartItemId) {
        if (kHXSShopTypeDorm == shopType) {
            if(count == 0) {
                [MobClick event:@"dorm_remove_cart" attributes:@{@"item_id":self.cartItemId}];
            }
            
            [[HXSDormCartManager sharedManager] updateItem:self.cartItemId quantity:[countView getCount]];
        }
    } else {
        if (kHXSShopTypeDorm == shopType) {
            if(self.item.isBox) {
                if ([_delegate respondsToSelector:@selector(boxItemUpdate:quantity:)]) {
                    [_delegate boxItemUpdate:_item.productIDStr quantity:count];
                }
            } else {
                [MobClick event:@"dorm_add_cart" attributes:@{@"rid":self.item.rid}];
                
                [[HXSDormCartManager sharedManager] addItem:_item.rid quantity:[countView getCount]];
            }
        }
    }
}

- (void)countAdd
{
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView) {
        [self.pageControl setCurrentPage:(int)self.scrollView.contentOffset.x/self.scrollView.frame.size.width];
    }
}


#pragma mark - Target Methods

- (void)onClick:(UIButton *)sender
{
    NSUInteger tag = sender.tag;
    HXSClickEvent * event = [self.item.promotions objectAtIndex:tag];
    if(event && event.eventUrl.length > 0 && [self.delegate respondsToSelector:@selector(dormItemTableViewCellDidClickEvent:)]) {
        [self.delegate dormItemTableViewCellDidClickEvent:event];
    }
}

@end
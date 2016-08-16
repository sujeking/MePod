//
//  HXSDormItemTableViewCell.m
//  store
//
//  Created by chsasaw on 14/12/7.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSDormItemTableViewCell.h"

// Model
#import "HXSDormCartManager.h"
#import "HXSDormCartItem.h"
#import "HXSClickEvent.h"
#import "HXSShop.h"

static CGFloat const kTabBarHeight         = 49.0;
static CGFloat const kPromotionLableHeight = 18.0;
static CGFloat const kHotLevelLabelHeight  = 14.0;

@interface HXSDormItemTableViewCell()

@property (nonatomic, strong) HXSDormItem *currentItem;
@property (nonatomic, strong) NSNumber    *cartItemId;

@end

@implementation HXSDormItemTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.imageImageVeiw.layer.masksToBounds = YES;
    
    self.titleLabel.numberOfLines = 2;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    self.rightCornerLabel.transform = CGAffineTransformMakeRotation(- M_PI/4);
    
    // cart button
    [self.plusBtn setImage:[UIImage imageNamed:@"ic_plus_list_normal"] forState:UIControlStateNormal];
    [self.plusBtn setImage:[UIImage imageNamed:@"ic_plus_list_pressed"] forState:UIControlStateHighlighted];
    [self.plusBtn setImage:[UIImage imageNamed:@"ic_plus_list_disable"] forState:UIControlStateDisabled];
    
    [self.minusBtn setImage:[UIImage imageNamed:@"ic_minus_list_normal"] forState:UIControlStateNormal];
    [self.minusBtn setImage:[UIImage imageNamed:@"ic_minus_list_pressed"] forState:UIControlStateHighlighted];
    [self.minusBtn setImage:[UIImage imageNamed:@"ic_minus_list_disable"] forState:UIControlStateDisabled];
    
    self.plusBtn.exclusiveTouch = YES;
    self.minusBtn.exclusiveTouch = YES;
    
    self.clipsToBounds = YES;
    self.contentView.clipsToBounds = YES;
    
    // status label
    self.statusLabel.layer.masksToBounds = YES;
    self.statusLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    if(point.x < self.minusBtn.frame.origin.x) {
        if([self.delegate respondsToSelector:@selector(dormItemTableViewCellDidShowDetail:)]) {
            [self.delegate dormItemTableViewCellDidShowDetail:self];
        }
    }
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}


#pragma mark - Public Methods

- (void)setItem:(HXSDormItem *)item dormStatus:(HXSShopStatus)status
{
    if (![item isKindOfClass:[HXSDormItem class]]) {
        return;
    }
    
    self.currentItem = item;
    
    self.titleLabel.text = item.name;
    [self.imageImageVeiw sd_setImageWithURL:[NSURL URLWithString:item.image_medium] placeholderImage:[UIImage imageNamed:@"img_kp_list"]];
    
    // price
    [self setupPriceLabelWithItem:item];
    
    self.cartItemId = nil;
    
    // set up status of
    [self setupCartBtnAndCountStauts:status withItem:item];
    

    [self.rightCornerLabel setHidden:item.promotionLabel.length == 0];
    if(!self.rightCornerLabel.hidden) {
        [self.rightCornerLabel setText:[item.promotionLabel substringToIndex:MIN(item.promotionLabel.length, 3)]];
    }
    
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
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
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
        self.promotionLabelHeightConstraint.constant = kPromotionLableHeight;
        self.descriptionLabelHeightConstraint.constant = 0;
    } else {
        self.promotionLabelHeightConstraint.constant = 0;
        self.descriptionLabelHeightConstraint.constant = kHotLevelLabelHeight;
        
        self.descriptionLabel.text = item.descriptionStr;
    }
    
    // origin price label
    if ((0 < [item.origin_price floatValue])
        && ([item.origin_price floatValue] > [item.price floatValue])) {
        self.originPriceLabel.hidden = NO;
    } else {
        self.originPriceLabel.hidden = YES;
    }
    
    [self setupOriginPriceLabelWithItem:item];

    [self layoutIfNeeded];
}

- (void)setupPriceLabelWithItem:(HXSDormItem *)item
{
    NSString *pricePart1Str = @"¥";
    NSString *pricePart2Str = [NSString stringWithFormat:@"%0.2f", [item.price floatValue]];
    NSString *priceStr = [NSString stringWithFormat:@"%@%@", pricePart1Str, pricePart2Str];
    NSMutableAttributedString *priceAttributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    
    [priceAttributedStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:12]
                               range:NSMakeRange(0, [pricePart1Str length])];
    [priceAttributedStr addAttribute:NSForegroundColorAttributeName
                               value:HXS_COLOR_COMPLEMENTARY
                               range:NSMakeRange(0, [pricePart1Str length])];
    [priceAttributedStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:15]
                               range:NSMakeRange([pricePart1Str length], [pricePart2Str length])];
    [priceAttributedStr addAttribute:NSForegroundColorAttributeName
                               value:HXS_COLOR_COMPLEMENTARY
                               range:NSMakeRange([pricePart1Str length], [pricePart2Str length])];
    
    
    self.priceLabel.attributedText = priceAttributedStr;
}

- (void)setupOriginPriceLabelWithItem:(HXSDormItem *)item
{
    NSString *pricePart1Str = @"¥";
    NSString *pricePart2Str = [NSString stringWithFormat:@"%0.2f", [item.origin_price floatValue]];
    NSString *priceStr = [NSString stringWithFormat:@"%@%@", pricePart1Str, pricePart2Str];
    NSMutableAttributedString *priceAttributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    
    [priceAttributedStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:10]
                               range:NSMakeRange(0, [pricePart1Str length])];
    [priceAttributedStr addAttribute:NSForegroundColorAttributeName
                               value:HXS_PROMPT_TEXT_COLOR
                               range:NSMakeRange(0, [pricePart1Str length])];
    [priceAttributedStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:12]
                               range:NSMakeRange([pricePart1Str length], [pricePart2Str length])];
    [priceAttributedStr addAttribute:NSForegroundColorAttributeName
                               value:HXS_PROMPT_TEXT_COLOR
                               range:NSMakeRange([pricePart1Str length], [pricePart2Str length])];
    [priceAttributedStr addAttribute:NSStrikethroughStyleAttributeName
                               value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)
                               range:NSMakeRange(0, [priceStr length])];
    [priceAttributedStr addAttribute:NSStrikethroughColorAttributeName
                               value:HXS_PROMPT_TEXT_COLOR
                               range:NSMakeRange(0, [priceStr length])];
    
    
    self.originPriceLabel.attributedText = priceAttributedStr;
}


- (void)setupCartBtnAndCountStauts:(HXSShopStatus)status withItem:(HXSDormItem *)item
{
    HXSDormCartItem * cartItem = [[HXSDormCartManager sharedManager] getCartItemOfDormItem:item];
    
    // 卖光了 状态设置
    if (self.currentItem.has_stock) {
        self.statusLabel.hidden = YES;
    } else {
        self.statusLabel.hidden = NO;
        self.statusLabel.text = [self fetchStatusString:kHXSDormItemStatusLackStock];
    }
    
    // 休息中 状态设置
    if (kHXSShopStatusClosed == status) {
        self.restStatusLabel.hidden = NO;
        self.restStatusLabel.text = [self fetchStatusString:kHXSDormItemStatusClosed];
        self.minusBtn.hidden       = YES;
        self.soldCountLabel.hidden = YES;
        self.plusBtn.hidden        = YES;
    } else {
        self.restStatusLabel.hidden = YES;
        self.plusBtn.hidden         = NO;
        self.minusBtn.hidden        = NO;
        self.soldCountLabel.hidden  = NO;
    }
    
    // 购物车状态设置
    if((kHXSShopStatusClosed != status)
       && self.currentItem.has_stock) {
        self.plusBtn.enabled = YES;
        if(cartItem) {
            self.cartItemId = cartItem.itemId;
        }
    } else {
        self.plusBtn.enabled = NO;
    }
    
    [self setupSoldCountLabel:cartItem.quantity.integerValue];
    
    [self layoutIfNeeded];
    self.statusLabel.layer.cornerRadius  = self.statusLabel.frame.size.width / 2.0f;
    
}

- (void)setupSoldCountLabel:(NSInteger)count
{
    if (0 < count) {
        self.soldCountLabel.hidden = NO;
        self.minusBtn.hidden = NO;
    } else {
        self.soldCountLabel.hidden = YES;
        self.minusBtn.hidden = YES;
    }
    
    if (0 > count) {
        count = 0;
    }
    
    self.soldCountLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
}


#pragma mark - Target Methods

- (void)onClick:(UIButton *)sender
{
    NSUInteger tag = sender.tag;
    HXSClickEvent * event = [_currentItem.promotions objectAtIndex:tag];
    if(event && event.eventUrl.length > 0 && [self.delegate respondsToSelector:@selector(dormItemTableViewCellDidClickEvent:)]) {
        [self.delegate dormItemTableViewCellDidClickEvent:event];
    }
}

- (IBAction)onClickPlusBtn:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventFoodListItemChangeNum parameter:@{@"business_type":@"夜猫店",@"type":@"增加"}];
    
    [self addSKUToCart];
    
    int selectedCount = [self.soldCountLabel.text intValue];
    selectedCount++;
    
    [self setupSoldCountLabel:selectedCount];
    
    [self.delegate updateCountOfRid:[NSNumber numberWithInt:selectedCount] inItem:self.currentItem];
    
}

- (IBAction)onClickMinusBtn:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventFoodListItemChangeNum parameter:@{@"business_type":@"夜猫店",@"type":@"减少"}];

    int selectedCount = [self.soldCountLabel.text intValue];
    selectedCount--;
    if (0 > selectedCount) {
        selectedCount = 0;
    }
    
    [self setupSoldCountLabel:selectedCount];
    
    [self.delegate updateCountOfRid:[NSNumber numberWithInt:selectedCount] inItem:self.currentItem];
    
}

- (void)addSKUToCart
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.imageImageVeiw.frame];
    imageView.image = self.imageImageVeiw.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor blackColor];
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    
    imageView.frame = [window convertRect:self.imageImageVeiw.frame fromView:self.imageImageVeiw.superview];
    [window addSubview:imageView];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        imageView.frame = CGRectMake(20, window.frame.size.height - 20 - kTabBarHeight, 1, 1);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}


#pragma mark - Private Methods

- (NSString *)fetchStatusString:(HXSDormItemStatus)status
{
    if(status == kHXSDormItemStatusClosed) {
        return @"休息中";
    } else if(status == kHXSDormItemStatusEmpty) {
        return @"未开通";
    } else if(status == kHXSDormItemStatusLackStock) {
        return @"卖光啦";
    } else {
        return @"";
    }
}


@end

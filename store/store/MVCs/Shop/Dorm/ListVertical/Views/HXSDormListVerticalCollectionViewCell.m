//
//  HXSDormListVerticalCollectionViewCell.m
//  store
//
//  Created by ArthurWang on 15/11/10.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSDormListVerticalCollectionViewCell.h"

// Model
#import "HXSShop.h"
#import "HXSDormCartManager.h"
#import "HXSDormListVerticalCellEntity.h"

static NSInteger const kTabBarHeight                    = 49;
static NSInteger const kPromotionLableHeight            = 14;
static NSInteger const kDistantCenterRightLabelIphone4s = -70;
static NSInteger const kDistantCenterRightLabelIphone6  = -83;
static NSInteger const kDistantCenterRightLabelIphone6p = -93;

static NSString * const kDrinkCartUpdateRid             = @"rid";
static NSString * const kDrinkCartUpdateQuantity        = @"quantity";


@interface HXSDormListVerticalCollectionViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCornerLabelCenterConstraint;

@property (nonatomic, strong) UIView *horizotalRightView;  // seperator line of right
@property (nonatomic, strong) UIView *verticalBottomView;  // seperator line of bottom

@property (nonatomic, strong) HXSDormItem                   *currentItem;
@property (nonatomic, strong) NSNumber                      *cartItemId;
@property (nonatomic, strong) HXSDormListVerticalCellEntity *cellEntity;

@property (nonatomic, strong) NSMutableArray                *requestParamMArr;


@end

@implementation HXSDormListVerticalCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    
    [self initialSeperatorLine];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.imageImageVeiw addGestureRecognizer:tap];
    
    UITapGestureRecognizer *addSKUTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(addSKU:)];

    [self addGestureRecognizer:addSKUTap];
    
    if (320 == SCREEN_WIDTH) {
        self.rightCornerLabelCenterConstraint.constant = kDistantCenterRightLabelIphone4s;
    } else if (375 == SCREEN_WIDTH) {
        self.rightCornerLabelCenterConstraint.constant = kDistantCenterRightLabelIphone6;
    } else {
        self.rightCornerLabelCenterConstraint.constant = kDistantCenterRightLabelIphone6p;
    }
    
    self.rightCornerLabel.transform = CGAffineTransformMakeRotation(- M_PI/4);
    
    // cart button
    [self.plusBtn setImage:[UIImage imageNamed:@"ic_plus_grid_normal"] forState:UIControlStateNormal];
    [self.plusBtn setImage:[UIImage imageNamed:@"ic_plus_grid_pressed"] forState:UIControlStateHighlighted];
    [self.plusBtn setImage:[UIImage imageNamed:@"ic_plus_grid_disable"] forState:UIControlStateDisabled];
    
    [self.minusBtn setImage:[UIImage imageNamed:@"ic_minus_grid_normal"] forState:UIControlStateNormal];
    [self.minusBtn setImage:[UIImage imageNamed:@"ic_minus_grid_pressed"] forState:UIControlStateHighlighted];
    [self.minusBtn setImage:[UIImage imageNamed:@"ic_minus_grid_disable"] forState:UIControlStateDisabled];
    
    self.plusBtn.exclusiveTouch = YES;
    self.minusBtn.exclusiveTouch = YES;
    
    // status label
    self.statusLabel.layer.masksToBounds = YES;
    self.statusLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
}

- (void)dealloc
{
    self.delegate         = nil;
    self.currentItem      = nil;
    self.cartItemId       = nil;
    self.cellEntity       = nil;
    self.requestParamMArr = nil;
}


#pragma mark - Initial Methods

- (void)initialSeperatorLine
{
    // bottom seperator line
    _horizotalRightView = [[UIView alloc] init];
    self.horizotalRightView.backgroundColor = HXS_COLOR_SEPARATION_WEAK;
    
    [self addSubview:self.horizotalRightView];
    
    [self.horizotalRightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(HXS_LINE_WIDTH);
    }];

    // right seperator line
    _verticalBottomView = [[UIView alloc] init];
    self.verticalBottomView.backgroundColor = HXS_COLOR_SEPARATION_WEAK;
    
    [self addSubview:self.verticalBottomView];
    
    [self.verticalBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.width.mas_equalTo(HXS_LINE_WIDTH);
    }];
    
    [self bringSubviewToFront:self.horizotalRightView];
    [self bringSubviewToFront:self.verticalBottomView];
    
    [self setNeedsLayout];
}


#pragma mark - Public Methods

- (void)setItem:(HXSDormItem *)item item:(HXSDormListVerticalCellEntity *)cellEntity dormStatus:(HXSShopStatus)status
{
    if (![item isKindOfClass:[HXSDormItem class]]) {
        return;
    }
    
    self.currentItem = item;
    self.cellEntity  = cellEntity;
    
    self.titleLabel.text = item.name;
    [self.imageImageVeiw sd_setImageWithURL:[NSURL URLWithString:item.image_medium] placeholderImage:[UIImage imageNamed:@"img_kp_list"]];
    
    // price
    [self setupPriceLabelWithItem:item];
    
    self.cartItemId = nil;
    
    // set up status of
    [self setupCartBtnAndCountStauts:status];
    
    
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
        [self.descriptionLabel setHidden:YES];
    } else {
        [self.promotionLabelsContainer setHidden:YES];
        [self.descriptionLabel setHidden:NO];
        
        self.descriptionLabel.text = item.descriptionStr;
    }
    
    // origin price label
    if ((0 < [item.origin_price floatValue])
        && !self.priceLabel.hidden
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

- (void)setupCartBtnAndCountStauts:(HXSShopStatus)status
{
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
        if(self.cellEntity) {
            self.cartItemId = self.cellEntity.itemId;
            
        }
    } else {
        self.plusBtn.enabled = NO;
    }
    
    [self setupSoldCountLabel:self.cellEntity.quantity.integerValue];
    
    [self layoutIfNeeded];
    self.statusLabel.layer.cornerRadius  = self.statusLabel.frame.size.width / 2.0f;
}

- (void)setupSoldCountLabel:(NSInteger)count
{
    if (0 < count) {
        self.soldCountLabel.hidden   = NO;
        self.minusBtn.hidden         = NO;
        self.priceLabel.hidden       = YES;
        self.originPriceLabel.hidden = YES;
        
        self.soldCountLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    } else {
        self.soldCountLabel.hidden   = YES;
        self.minusBtn.hidden         = YES;
        self.priceLabel.hidden       = NO;
        if ([self.currentItem.origin_price floatValue] > [self.currentItem.price floatValue]) {
            self.originPriceLabel.hidden = NO;
        } else {
            self.originPriceLabel.hidden = YES;
        }
        
        self.soldCountLabel.text = [NSString stringWithFormat:@"%ld", (long)0];
    }
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

- (void)tap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    if(point.x < self.plusBtn.frame.origin.x) {
        if([self.delegate respondsToSelector:@selector(dormItemTableViewCellDidShowDetail:)]) {
            [self.delegate dormItemTableViewCellDidShowDetail:self];
        }
    }
}

- (void)addSKU:(UITapGestureRecognizer *)tap
{
    if (self.plusBtn.isHidden
        || !self.plusBtn.enabled) {
        return; // When cart button is hidden, can't add SKU
    }
    
    CGPoint point = [tap locationInView:self];
    
    if ((point.y > self.titleLabel.frame.origin.y)
        && (point.x > (self.frame.size.width / 2.0))) {
        
        [self onClickPlusBtn:nil];
    }
}

- (IBAction)onClickPlusBtn:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventFoodGridItemChangeNum parameter:@{@"business_type":@"夜猫店",@"type":@"增加"}];
    
    [self addSKUToCart];
    
    int selectedCount = [self.soldCountLabel.text intValue];
    selectedCount++;
    
    [self setupSoldCountLabel:selectedCount];
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.currentItem.rid,       kDrinkCartUpdateRid,
                              [NSNumber numberWithInteger:selectedCount],  kDrinkCartUpdateQuantity, nil];
    
    [self addUpdataDrinkCartRequest:[NSString stringWithFormat:@"%@", self.currentItem.rid]
                            param:paramDic];
    
    
}

- (IBAction)onClickMinusBtn:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventFoodGridItemChangeNum parameter:@{@"business_type":@"夜猫店",@"type":@"减少"}];
    int selectedCount = [self.soldCountLabel.text intValue];
    selectedCount--;
    
    [self setupSoldCountLabel:selectedCount];
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.currentItem.rid,       kDrinkCartUpdateRid,
                              [NSNumber numberWithInteger:selectedCount],  kDrinkCartUpdateQuantity, nil];
    
    [self addUpdataDrinkCartRequest:[NSString stringWithFormat:@"%@", self.currentItem.rid]
                              param:paramDic];

}

- (void)addUpdataDrinkCartRequest:(NSString *)name param:(NSDictionary *)paramDic
{
    for (NSTimer *timer in self.requestParamMArr) {
        NSDictionary *tempParamDic = (NSDictionary *)(timer.userInfo);
        NSString *ridStr = [NSString stringWithFormat:@"%@", [tempParamDic objectForKey:kDrinkCartUpdateRid]];
        if ([ridStr isEqualToString:name]) {
            [timer invalidate];
            [self.requestParamMArr removeObject:timer];
            
            break;
        }
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(updateDrinkCartInfoWithParam:)
                                                    userInfo:paramDic
                                                     repeats:NO];
    
    [self.requestParamMArr addObject:timer];
    
}


- (void)updateDrinkCartInfoWithParam:(NSTimer *)timer
{
    NSDictionary *paramDic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)(timer.userInfo)];
    
    NSNumber *currentRid = [paramDic objectForKey:kDrinkCartUpdateRid];
    
    for (NSTimer *timer in self.requestParamMArr) {
        NSDictionary *tempParamDic = (NSDictionary *)timer.userInfo;
        NSNumber *rid = [tempParamDic objectForKey:kDrinkCartUpdateRid];
        if ([rid integerValue] == [currentRid integerValue]) {
            
            [self.requestParamMArr removeObject:timer];
            break;
        }
    }
    
    NSNumber *ridNum = [paramDic objectForKey:kDrinkCartUpdateRid];
    NSNumber *quantityNum = [paramDic objectForKey:kDrinkCartUpdateQuantity];
    
    if(self.cartItemId) {
        if(0 == [quantityNum intValue]) {
            [MobClick event:@"dorm_remove_cart" attributes:@{@"item_id":ridNum}];
        }
        
        [self.delegate listConllectionViewCell:self udpateItem:ridNum quantity:quantityNum];
    } else {
        [MobClick event:@"dorm_add_cart" attributes:@{@"rid":ridNum}];
        
        [self.delegate listConllectionViewCell:self udpateItem:ridNum quantity:quantityNum];
    }
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


#pragma mark - Setter Getter

- (NSMutableArray *)requestParamMArr
{
    if (nil == _requestParamMArr) {
        _requestParamMArr = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return _requestParamMArr;
}





@end

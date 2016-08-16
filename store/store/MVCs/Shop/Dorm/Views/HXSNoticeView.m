//
//  HXSNoticeView.m
//  store
//
//  Created by ArthurWang on 16/1/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSNoticeView.h"

#import "HXSShopEntity.h"

@interface HXSNoticeView ()

@property (nonatomic, strong) HXSShopEntity *shopEntity;
@property (nonatomic, copy) void (^onTouchInView)(void);

@end

@implementation HXSNoticeView


#pragma mark - Override Methods

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}


#pragma mark - Public Methods

- (instancetype)initWithShopEntity:(HXSShopEntity *)shopEntity targetMethod:(void (^)(void))sender
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    if (self) {
        [self createWithShopEntity:shopEntity targetMethod:sender];
    }
    return self;
}

- (instancetype)createWithShopEntity:(HXSShopEntity *)shopEntity targetMethod:(void (^)(void))sender
{
    self.shopEntity = shopEntity;
    self.onTouchInView = sender;
    
    [self createNoticeView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onClickInView:)];
    [self addGestureRecognizer:tap];
    
    return self;
}


#pragma mark - Create Methods

- (void)createNoticeView
{
    self.backgroundColor = HXS_MAIN_COLOR;
    
    // 活动标记
    CGFloat padding = 5.0f;
    CGFloat widthOfImage = 16.0f;
    CGFloat yOfImage = (self.height - widthOfImage) / 2.0f;
    CGFloat lastX = 15.0f;
    
    // 公告符号
    UIImageView *noticeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(lastX, yOfImage, widthOfImage, widthOfImage)];
    noticeImageView.image = [UIImage imageNamed:@"ic_notice"];
    
    [self addSubview:noticeImageView];
    
    lastX += widthOfImage + padding;
    
    // 公告信息
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(lastX, 0, self.width - lastX - 10, self.height)]; // 10 距离右边
    [noticeLabel setFont:[UIFont systemFontOfSize:14]];
    [noticeLabel setTextColor:[UIColor whiteColor]];
    noticeLabel.text = self.shopEntity.noticeStr;
    
    [self addSubview:noticeLabel];
}


#pragma mark - Target Methods

- (void)onClickInView:(id)sender
{
    if (self.onTouchInView) {
        self.onTouchInView();
    }
}

@end

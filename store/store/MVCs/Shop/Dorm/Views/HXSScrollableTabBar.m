//
//  HXSScrollableTabBar.m
//  store
//
//  Created by chensi on 6/2/15.
//  Copyright (c) 2015 59store. All rights reserved.
//

#import "HXSScrollableTabBar.h"

// Views
#import "HXSLocationCustomButton.h"

// Others
#import "UIButton+AFNetworking.h"


static NSInteger const kScrollTabbarSideButtonWidth = 15;
#define SCROLL_TABBAR_BAR_WIDTH  ((self.maxWidth - kScrollTabbarSideButtonWidth*2)/3)  // 4 is setup the fixed width


@interface HXSScrollableTabBar ()

@property (nonatomic, strong) NSMutableArray *tabItems;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIScrollView *tabScrollView;
@property (nonatomic, strong) UIImageView * selectedImageView;
@property (nonatomic, assign) CGFloat    maxWidth;

@end

@implementation HXSScrollableTabBar

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initViews];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    
    return self;
}

- (void)initViews
{
    self.maxWidth         = SCREEN_WIDTH;
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.tabScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    [self addSubview:self.tabScrollView];
    self.tabScrollView.delegate = self;
    self.tabScrollView.showsHorizontalScrollIndicator = NO;
    
    self.previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.previousButton addTarget:self action:@selector(goToPreviousTabBar) forControlEvents:UIControlEventTouchUpInside];
    [self.previousButton setImage:[UIImage imageNamed:@"web_icon_back"] forState:UIControlStateNormal];
    [self.previousButton setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.previousButton];
    self.previousButton.hidden = YES;
    self.previousButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton addTarget:self action:@selector(goToNextTabBar) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setImage:[UIImage imageNamed:@"web_icon_forward"] forState:UIControlStateNormal];
    [self.nextButton setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.nextButton];
    self.nextButton.hidden = YES;
    self.nextButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCROLL_TABBAR_BAR_WIDTH, 3)];
    self.selectedImageView.backgroundColor = UIColorFromRGB(0xFC6D41);
    self.selectedImageView.hidden = YES;
    
    self.tabItems = [[NSMutableArray alloc] init];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.previousButton.frame = CGRectMake(0, 0, kScrollTabbarSideButtonWidth, CGRectGetHeight(self.frame));
    self.tabScrollView.frame = CGRectMake(kScrollTabbarSideButtonWidth, 0, CGRectGetWidth(self.frame) - kScrollTabbarSideButtonWidth*2, CGRectGetHeight(self.frame));
    self.nextButton.frame = CGRectMake(CGRectGetWidth(self.frame) - kScrollTabbarSideButtonWidth, 0, kScrollTabbarSideButtonWidth, CGRectGetHeight(self.frame));
}


#pragma mark - Public Methods

- (void)setItems:(NSArray *)items animated:(BOOL)animated width:(CGFloat)maxWidth
{
    [self removeAllTabs];
    
    self.maxWidth = (0 < maxWidth) ? maxWidth : SCREEN_WIDTH;
    
    int i=0;
    for(NSDictionary *itemDic in items) {
        [self insertTabWithItem:itemDic atIndex:i animated:animated];
        i++;
    }
    self.tabScrollView.contentSize = CGSizeMake(SCROLL_TABBAR_BAR_WIDTH * i, self.tabScrollView.frame.size.height);
    [self setSelectedIndex:0 animated:NO];
    [self scrollViewDidScroll:self.tabScrollView];
}

- (void)removeAllTabs {
    for(UIButton * button in self.tabItems) {
        [button removeFromSuperview];
    }
    [self.tabItems removeAllObjects];
    self.tabScrollView.contentOffset = CGPointMake(0, 0);
    
    [self scrollViewDidScroll:self.tabScrollView];
}


-(void)goToNextTabBar {
    [self.tabScrollView scrollRectToVisible:CGRectMake(self.tabScrollView.contentOffset.x + self.tabScrollView.frame.size.width, 0, SCROLL_TABBAR_BAR_WIDTH, self.tabScrollView.frame.size.height) animated:YES];
}

-(void)goToPreviousTabBar {
    int x = self.tabScrollView.contentOffset.x - SCROLL_TABBAR_BAR_WIDTH;
    [self.tabScrollView scrollRectToVisible:CGRectMake(x > 0 ? x : 0, 0, SCROLL_TABBAR_BAR_WIDTH, self.tabScrollView.frame.size.height) animated:YES];
}

- (void)insertTabWithItem:(NSDictionary *)itemDic atIndex:(NSUInteger)index animated:(BOOL)animated
{
    NSString *titleStr              = [itemDic objectForKey:kScrollBarTitle];
    
    HXSLocationCustomButton *button = [HXSLocationCustomButton buttonWithType:UIButtonTypeCustom];
    
    [button setContentMode:UIViewContentModeScaleAspectFill];
    [button setTitle:titleStr forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [button.titleLabel setMinimumScaleFactor:0.5];
    [button setTitleColor:UIColorFromRGB(0x6F5F61) forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x00A3FA) forState:UIControlStateSelected];
    [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateDisabled];

    UIImage *downImageHighlighted=[UIImage imageNamed:@"ic_classify_downarrow"];
    UIImage *downImageSelected=[UIImage imageNamed:@"ic_classify_downarrow"];
    UIImage *downImageNormal=[UIImage imageNamed:@"ic_downcontent"];
    [button setImage:downImageNormal forState:UIControlStateNormal];
    [button setImage:downImageSelected forState:UIControlStateSelected];
    [button setImage:downImageHighlighted forState:UIControlStateHighlighted];
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width+60, 0,0)];
    
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(onClickTabButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = index;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [self.tabScrollView addSubview:button];
    [self.tabItems addObject:button];
    
    button.frame = CGRectMake(SCROLL_TABBAR_BAR_WIDTH * index, 0, SCROLL_TABBAR_BAR_WIDTH, self.tabScrollView.frame.size.height);
    
    [self.tabScrollView bringSubviewToFront:self.selectedImageView];
}

- (NSInteger)selectedIndex
{
    for(UIButton * button in self.tabItems) {
        if(button.selected) {
            return button.tag;
        }
    }
    
    return -1;
}

- (void)onClickTab:(UIButton *)button
{
    [self setSelectedIndex:button.tag animated:YES];
    if(self.scrollableTabBarDelegate && [self.scrollableTabBarDelegate respondsToSelector:@selector(scrollableTabBar:didSelectItemWithIndex:)]) {
        [self.scrollableTabBarDelegate scrollableTabBar:self didSelectItemWithIndex:(int)button.tag];
    }
}


/**
 *  工具按钮点击事件
 *
 *  @param button button
 */
- (void)onClickTabButton:(UIButton *)button
{
    //
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    for(UIButton * btn in self.tabItems) {
        if(btn.tag == index) {
            btn.selected = YES;
            
            [self.tabScrollView scrollRectToVisible:btn.frame animated:YES];
        } else {
            btn.selected = NO;
        }
    }
    
    self.selectedImageView.hidden = self.tabItems.count == 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImageView.frame = CGRectMake(index * SCROLL_TABBAR_BAR_WIDTH, CGRectGetHeight(self.tabScrollView.frame) - 2, SCROLL_TABBAR_BAR_WIDTH, 2);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollWidth = self.tabScrollView.frame.size.width;
    CGFloat contentOffsetX = self.tabScrollView.contentOffset.x;
    self.previousButton.hidden = contentOffsetX < (SCROLL_TABBAR_BAR_WIDTH / 2);
    self.nextButton.hidden = (contentOffsetX + scrollWidth) > (SCROLL_TABBAR_BAR_WIDTH * (self.tabItems.count - 1));
}

@end
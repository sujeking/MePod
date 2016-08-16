//
//  HXSBannerLinkHeaderView.m
//  store
//
//  Created by ArthurWang on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBannerLinkHeaderView.h"
// Model
#import "HXSStoreAppEntryEntity.h"
// Others
#import "HXSPageControl.h"
#import "NSTimer+Addition.h"

static NSInteger const kHeightScrollView  = 44;
static NSInteger const kHeightPageControl = 37;
static NSInteger const kTagBasic          = 1000;

@interface HXSBannerLinkHeaderView () <UIScrollViewDelegate>

@property (nonatomic, strong) HXSPageControl *pageControl;
@property (nonatomic, strong) UIScrollView   *scrollView;

@property (nonatomic ,assign) NSInteger      currentPageIndex;
@property (nonatomic ,assign) NSInteger      totalPageCount;
@property (nonatomic ,strong) NSMutableArray *contentViews;
@property (nonatomic ,strong) NSMutableArray *slideItems;
@property (nonatomic ,strong) NSMutableArray *imageViews;
@property (nonatomic ,strong) NSTimer        *animationTimer;
@property (nonatomic ,assign) NSTimeInterval animationDuration;

@property (nonatomic ,assign) CGFloat        scrollViewStartContentOffsetX;

@end

@implementation HXSBannerLinkHeaderView


#pragma mark - Init Methods

- (void)awakeFromNib
{
    [self initialView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialView];
    }
    return self;
}

- (instancetype)initHeaderViewWithDelegate:(id<HXSBannerLinkHeaderViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.eventDelegate = delegate;
        self.scrollView.scrollsToTop = NO;
    }
    return self;
}


#pragma mark - Public Methods

- (void)setSlideItemsArray:(NSArray<HXSStoreAppEntryEntity *> *)slideItemsArr
{
    for(UIView * view in self.imageViews) {
        [view removeFromSuperview];
    }
    
    [self.slideItems removeAllObjects];
    [self.imageViews removeAllObjects];
    
    [self.slideItems addObjectsFromArray:slideItemsArr];
    
    for(int i=0; i<self.slideItems.count; i++) {
        HXSStoreAppEntryEntity *item = [self.slideItems objectAtIndex:i];
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [image sd_setImageWithURL:[NSURL URLWithString:item.imageURLStr]  placeholderImage:[UIImage imageNamed:@"img_kp_banner_cat"]];
        image.contentMode = UIViewContentModeScaleToFill;
        image.tag = i + kTagBasic;
        [image setUserInteractionEnabled:YES];
        [self.imageViews addObject:image];
        
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [image addGestureRecognizer:gesture];
    }
    
    self.currentPageIndex = 0;
    
    self.pageControl.numberOfPages = self.slideItems.count;
    self.pageControl.currentPage = 0;
    
    [self.animationTimer pauseTimer];
    
    _totalPageCount = self.imageViews.count;
    
    if(_totalPageCount > 0) {
        HXSStoreAppEntryEntity *item = [self.slideItems objectAtIndex:0];
        CGSize size = CGSizeMake(item.imageWidthIntNum.floatValue, item.imageHeightIntNum.floatValue);
        CGFloat scaleOfSize = size.height/size.width;
        if (isnan(scaleOfSize)
            || isinf(scaleOfSize)) {
            scaleOfSize = 1.0;
        }
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(scaleOfSize * self.frame.size.width);
        }];
        
        self.scrollView.hidden = NO;
        self.pageControl.hidden = NO;
    }else {
        self.scrollView.hidden = YES;
        self.pageControl.hidden = YES;
        
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    [self setNeedsLayout];
    
    [self performSelector:@selector(totalPage) withObject:nil afterDelay:0.2];
}

- (void)initialView
{
    // Initialization code
    self.autoresizesSubviews = YES;
    
    [self addDefineSubView];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    self.currentPageIndex = 0;
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.hidden = YES;
    self.pageControl.numberOfPages = self.slideItems.count;
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(handleClickPageControl:) forControlEvents:UIControlEventTouchUpInside];
    
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = 4.0f)
                                                           target:self
                                                         selector:@selector(animationTimerDidFired:)
                                                         userInfo:nil
                                                          repeats:YES];
    [self.animationTimer pauseTimer];
    
    _totalPageCount = self.imageViews.count;
}

- (void)layoutSubviews
{
    NSInteger count = self.scrollView.subviews.count;
    
    if(self.slideItems.count > 0) {
        HXSStoreAppEntryEntity *item = [self.slideItems objectAtIndex:0];
        CGSize size = CGSizeMake(item.imageWidthIntNum.floatValue, item.imageHeightIntNum.floatValue);
        CGFloat scaleOfSize = size.height/size.width;
        if (isnan(scaleOfSize)
            || isinf(scaleOfSize)) {
            scaleOfSize = 1.0;
        }
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(scaleOfSize * self.frame.size.width);
        }];
    } else {
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    
    // 在iOS7中，将 layoutSubviews 放在最上面(设置了 scrollViewHeight.constant 之前)会引起Crash
    [super layoutSubviews];
    
    for (int i = 0; i < count; i++) {
        UIView *view = self.scrollView.subviews[i];
        
        CGRect rightRect = self.scrollView.bounds;
        rightRect.origin.x = CGRectGetWidth(self.scrollView.frame) * (i);
        
        view.frame = rightRect;
    }
}


#pragma mark - Initial Methods

- (void)addDefineSubView
{
    // scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    self.scrollView = scrollView;
    
    [self addSubview:self.scrollView];
    
    // auto layout
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(kHeightScrollView);
    }];
    
    // page control
    HXSPageControl *pageControl = [[HXSPageControl alloc] init];
    UIImage *normalImage   = [UIImage imageNamed:@"ic_circle_normal"];
    UIImage *selectedImage = [UIImage imageNamed:@"ic_circle_selected"];
    NSArray *imageArray = @[selectedImage,normalImage];//添加自定义PageControl图片
    [pageControl updateImages:imageArray];
    self.pageControl = pageControl;
    
    [self addSubview:self.pageControl];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(kHeightPageControl);
        make.bottom.mas_equalTo(self.mas_bottom).offset(10);
    }];
}


#pragma mark - Setter Getter Methods

- (NSMutableArray *)slideItems
{
    if (nil == _slideItems) {
        _slideItems = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return _slideItems;
}

- (NSMutableArray *)imageViews
{
    if (nil == _imageViews) {
        _imageViews = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return _imageViews;
}

- (void)handleClickPageControl:(UIPageControl *)control
{
    [self.animationTimer pauseTimer];
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    
    [self.scrollView scrollRectToVisible:CGRectMake(control.currentPage * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
}

- (void)totalPage
{
    if (self.totalPageCount > 0) {
        if (self.totalPageCount > 1) {
            self.scrollView.scrollEnabled = YES;
            self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
            [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
        } else {
            self.scrollView.scrollEnabled = YES;
        }
        [self configContentViews];
    }
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
    [self.pageControl setCurrentPage:_currentPageIndex];
}


#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        
        CGRect rightRect = self.scrollView.bounds;
        rightRect.origin.x = CGRectGetWidth(self.scrollView.frame) * (counter ++);
        
        contentView.frame = rightRect;
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.scrollView addSubview:contentView];
    }
    if (self.totalPageCount > 1) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
    if(self.totalPageCount == 1) {
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * self.totalPageCount + 1, _scrollView.frame.size.height)];
    } else if(self.totalPageCount == 2) {
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * (self.totalPageCount + 1), _scrollView.frame.size.height)];
    } else {
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * self.totalPageCount, _scrollView.frame.size.height)];
    }
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.imageViews.count > 0) {
        id set = (self.totalPageCount == 1)?[NSSet setWithObjects:@(previousPageIndex),@(_currentPageIndex),@(rearPageIndex), nil]:@[@(previousPageIndex),@(_currentPageIndex),@(rearPageIndex)];
        for (NSNumber *tempNumber in set) {
            NSInteger tempIndex = [tempNumber integerValue];
            if ([self isValidArrayIndex:tempIndex]) {
                [self.contentViews addObject:self.imageViews[tempIndex]];
            }
        }
    }
}

- (BOOL)isValidArrayIndex:(NSInteger)index
{
    if (index >= 0 && index <= self.totalPageCount - 1) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}


#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrollViewStartContentOffsetX = scrollView.contentOffset.x;
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (self.totalPageCount == 2) {
        if (_scrollViewStartContentOffsetX < contentOffsetX) {
            UIView *tempView = (UIView *)[self.contentViews lastObject];
            tempView.frame = (CGRect){{2 * CGRectGetWidth(scrollView.frame),0},tempView.frame.size};
        } else if (_scrollViewStartContentOffsetX > contentOffsetX) {
            UIView *tempView = (UIView *)[self.contentViews firstObject];
            tempView.frame = (CGRect){{0,0},tempView.frame.size};
        }
    }
    
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self configContentViews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(self.slideItems.count > 1) {
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
    }
}


#pragma mark -
#pragma mark - 响应事件

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.animationTimer pauseTimer];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    NSInteger index = imageView.tag - kTagBasic;
    
    if(self.slideItems.count > index) {
        HXSStoreAppEntryEntity *entity = [self.slideItems objectAtIndex:index];
        if(self.eventDelegate && [self.eventDelegate respondsToSelector:@selector(didSelectedLink:)]) {
            [self.eventDelegate didSelectedLink:entity.linkURLStr];
            
            [HXSUsageManager trackEvent:@"credit_banner" parameter:@{@"title":entity.titleStr}];
        }
    }
}

- (void)animationTimerDidFired:(NSTimer *)timer
{
    if(self.slideItems.count > 1) {
        int page = self.scrollView.contentOffset.x/CGRectGetWidth(self.scrollView.frame) + 1;
        CGPoint newOffset = CGPointMake(page*CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
        [self.scrollView setContentOffset:newOffset animated:YES];
    }
}

@end

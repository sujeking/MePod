//
//  HXSGuideViewController.m
//  Animation
//
//  Created by hudezhi on 15/8/2.
//  Copyright (c) 2015年 59store. All rights reserved.
//

#import "HXSGuideViewController.h"

@interface GuidePageView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIButton    *entryButton;

@end

@implementation GuidePageView

@end

@interface HXSGuideViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView  *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *pageViewArr;

@end

@implementation HXSGuideViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initialScrollView];
    
    [self.view bringSubviewToFront:self.pageControl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    DLog(@"%s dealloc.", __FILE__);
}


#pragma mark - Override Methods

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _scrollView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    CGFloat width = _scrollView.width;
    
    for(int i = 0; i < [self.pageViewArr count]; i++) {
        GuidePageView *pageView = [self.pageViewArr objectAtIndex:i];
        pageView.frame = CGRectMake(i * width, 0, width, _scrollView.height);
    }

    // scrollview content size
    _scrollView.contentSize = CGSizeMake(width * [self.pageViewArr count], _scrollView.height);
    
    [self.view layoutIfNeeded];
}


#pragma mark - Initial Methods

- (void)initialScrollView
{
    NSArray *imageNameArr = @[@"img_01_wenzi",
                              @"img_02_wenzi",
                              @"img_03_wenzi",
                              @"img_04_wenzi",
                              @"img_05_wenzi"];
    NSArray *backgroundImageNameArr = @[@"img_01_beijing",
                                        @"img_02_beijing",
                                        @"img_03_beijing",
                                        @"img_04_beijing",
                                        @"img_05_beijing"];
    NSArray *backgroundColors = @[[UIColor colorWithHexString:@"#9d0a12"],
                                  [UIColor colorWithHexString:@"#3baabd"],
                                  [UIColor colorWithHexString:@"#f6b62e"],
                                  [UIColor colorWithHexString:@"#0a7798"],
                                  [UIColor colorWithHexString:@"#fc922e"]];
    
    NSMutableArray *viewMArr = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (int i = 0; i < [imageNameArr count]; i++) {
        UIImage *image = [UIImage imageNamed:[imageNameArr objectAtIndex:i]];
        UIImage *backgroundImage = [UIImage imageNamed:backgroundImageNameArr[i]];
        
        GuidePageView *pageView = [[[NSBundle mainBundle] loadNibNamed:@"GuidePageView"
                                                                 owner:nil
                                                               options:nil] firstObject];
        [pageView.backgroundImageView setImage:backgroundImage];
        [pageView.contentImageView setImage:image];
        pageView.entryButton.hidden = (i != (imageNameArr.count -1));
        [viewMArr addObject:pageView];
        pageView.backgroundColor = backgroundColors[i];
        [pageView.entryButton addTarget:self action:@selector(start59StoreNow) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:pageView];
    }
    
    self.pageViewArr = viewMArr;
    
    [self.pageControl setNumberOfPages:[viewMArr count]];
}

#pragma mark -  Action Methods

- (void)performBlock
{
    if(self.block) {
        self.block();
        self.block = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)start59StoreNow
{
    self.view.userInteractionEnabled = NO;

    [self performBlock];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x < 0) {
        return;
    }
    
    int page = (int)scrollView.contentOffset.x / scrollView.width;
    
    [self.pageControl setCurrentPage:page];
    
    // start APP
    CGFloat padding = 0;
    if (320 == [UIScreen mainScreen].bounds.size.width) {
        padding = 50;
    } else {
        padding = 80;
    }
    if (scrollView.contentOffset.x > (scrollView.width * ([self.pageViewArr count] - 1) + padding)) {
        [self start59StoreNow];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = (int)((scrollView.contentOffset.x + 2.0)/scrollView.width);
    
    [self.pageControl setCurrentPage:page];
}

@end

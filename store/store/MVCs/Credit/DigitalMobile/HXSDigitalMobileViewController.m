//
//  HXSDigitalMobileViewController.m
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileViewController.h"

// Controllers
#import "HXSDigitalMobileHotViewController.h"
#import "HXSDigitalMobileListViewController.h"
#import "HXSWebViewController.h"

// Model
#import "HXSDigitalMobileModel.h"
#import "HXSSlideItem.h"

// Views
#import "HXSBannerHeaderView.h"
#import "HXSDigitalMobileScrollableTabBar.h"
#import "HXSLoadingView.h"

static NSString * const kHotCategoryName = @"热门";
static NSInteger const kHeightScrollabelTabBar = 44;

@interface HXSDigitalMobileViewController () <UIPageViewControllerDelegate,
                                              UIPageViewControllerDataSource,
                                              HXSDigitalMobileScrollableTabBarDelegate,
                                              HXSClickEventDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollview;
@property (weak, nonatomic) IBOutlet HXSBannerHeaderView *bannerHeaderView;
@property (weak, nonatomic) IBOutlet HXSDigitalMobileScrollableTabBar *scrollabelTabBar;
@property (weak, nonatomic) IBOutlet UIView *digitalMobileView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeaderViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *digitalMobileViewHeightConstraint;

@property (nonatomic, strong) UIPageViewController  *pageController;
@property (nonatomic, assign) NSInteger             currentPage;
@property (nonatomic, strong) NSMutableArray        *pageViewControllersArr;

@property (nonatomic, strong) HXSDigitalMobileModel *digitalMobileModel;
@property (nonatomic, strong) NSArray               *categoriesArr;

@end

@implementation HXSDigitalMobileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialBaseScrollView];
    
    [self refreshViewController];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.digitalMobileViewHeightConstraint.constant = self.view.height - kHeightScrollabelTabBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Initial methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"分期商城";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_queations"] style:UIBarButtonItemStylePlain target:self action:@selector(borronInfoBtnPressed:)];
}

- (void)initialBaseScrollView
{
    __weak typeof(self) weakSelf = self;
    [self.baseScrollview addRefreshHeaderWithCallback:^{
        [weakSelf refreshViewController];
    }];
}

- (void)initialPageViewController
{
    if (nil != self.pageController) {
        [self.pageController.view removeFromSuperview];
        [self.pageController removeFromParentViewController];
        self.pageController = nil;
    }
    
    NSNumber *spineLocationNumber = [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMax];
    NSDictionary *options = [NSDictionary dictionaryWithObject:spineLocationNumber
                                                        forKey:UIPageViewControllerOptionSpineLocationKey];
    _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                    options:options];
    self.pageController.view.backgroundColor = [UIColor whiteColor];
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    [self addChildViewController:self.pageController];
    [self.digitalMobileView addSubview:self.pageController.view];
    [self.pageController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.digitalMobileView);
    }];
    [self.pageController didMoveToParentViewController:self];
    
    UIViewController *initialVC = [self viewControllerAtIndex:0]; // deafult is first one
    NSArray *array = [NSArray arrayWithObjects:initialVC, nil];
    [self.pageController setViewControllers:array
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES
                                 completion:nil];
}


#pragma mark - Setter Getter Methods

- (HXSDigitalMobileModel *)digitalMobileModel
{
    if (nil == _digitalMobileModel) {
        _digitalMobileModel = [[HXSDigitalMobileModel alloc] init];
    }
    
    return _digitalMobileModel;
}

- (NSMutableArray *)pageViewControllersArr
{
    if (nil == _pageViewControllersArr) {
        _pageViewControllersArr = [[NSMutableArray alloc] initWithCapacity:5];
        
        for (int i = 0; i < [self.categoriesArr count]; i++) {
            [_pageViewControllersArr addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    return _pageViewControllersArr;
}


#pragma mark - Target Methods

- (void)borronInfoBtnPressed:(id)sender
{
    NSString *url = [[ApplicationSettings instance] installmentStoreFAQURLString];
    
    HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
    webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.navigationController pushViewController:webVc animated:YES];
}


#pragma mark - Fetch Item List

- (void)refreshViewController
{
    [self fetchSlideList];
    
    [self fetchCategoryList];
}

- (void)fetchSlideList
{
    self.bannerHeaderView.eventDelegate = self;
    
    NSNumber *cityIDIntNum = [HXSLocationManager manager].currentCity.city_id;
    
    __weak typeof(self) weakSelf = self;
    [self.digitalMobileModel fetchCreditlayoutWithCityID:cityIDIntNum
                                             type:[NSNumber numberWithInt:kHXSCreditCardLayoutTypeDigitalMobile]
                                         complete:^(HXSErrorCode status, NSString *message, HXSCreditEntity *creditLayoutEntity) {
                                             [weakSelf.baseScrollview endRefreshing];
                                             if (kHXSNoError != status) {
                                                 weakSelf.bannerHeaderViewHeightConstraint.constant = 0;
                                                 return ;
                                             }
                                             
                                             [weakSelf.bannerHeaderView setSlideItemsArray:creditLayoutEntity.slidesArr];
                                             CGFloat height = [weakSelf heightOfBannerHeaderView:creditLayoutEntity.slidesArr];
                                             
                                             weakSelf.bannerHeaderViewHeightConstraint.constant = height;
                                         }];
}

- (void)fetchCategoryList
{
    self.scrollabelTabBar.scrollableTabBarDelegate = self;
    
    __weak typeof(self) weakSelf = self;
    [HXSLoadingView showLoadingInView:self.view];
    [self.digitalMobileModel fetchTipCategoryList:^(HXSErrorCode status, NSString *message, NSArray *categoryListArr) {
        [weakSelf.baseScrollview endRefreshing];
        if (kHXSNoError != status) {
            [HXSLoadingView showLoadFailInView:weakSelf.view block:^{
                [weakSelf refreshViewController];
            }];
            
            return ;
        }
        
        HXSDigitalMobileCategoryListEntity *entity = [[HXSDigitalMobileCategoryListEntity alloc] init];
        entity.categoryNameStr = kHotCategoryName;
        entity.categoryIDIntNum = @0;
        NSMutableArray *categoryMArr = [[NSMutableArray alloc] initWithObjects:entity, nil];
        [categoryMArr addObjectsFromArray:categoryListArr];
        
        weakSelf.categoriesArr = categoryMArr;
        
        [weakSelf updateScrollabelTabBar];
        
        [weakSelf initialPageViewController];
        
        [HXSLoadingView closeInView:weakSelf.view];
    }];
}

- (void)updateScrollabelTabBar
{
    NSMutableArray *itemsMArr = [[NSMutableArray alloc] initWithCapacity:5];
    for (HXSDigitalMobileCategoryListEntity *entity in self.categoriesArr) {
        NSDictionary *dic = @{kScrollBarTitle:entity.categoryNameStr};
        
        [itemsMArr addObject:dic];
    }
    
    [self.scrollabelTabBar setItems:itemsMArr
                           animated:YES
                              width:self.view.width];
    
    [self.scrollabelTabBar setSelectedIndex:0 animated:YES]; // First one
}


#pragma mark - HXSDigitalMobileScrollableTabBarDelegate

- (void)scrollableTabBar:(HXSDigitalMobileScrollableTabBar *)tabBar didSelectItemWithIndex:(int)index
{
    NSArray *array = [NSArray arrayWithObjects:[self viewControllerAtIndex:index], nil];
    
    if (0 >= [array count]) {
        return; // Do nothing
    }
    
    [tabBar setUserInteractionEnabled:NO];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.scrollabelTabBar setUserInteractionEnabled:YES];
    });
    
    if (self.currentPage > index) {
        [self.pageController setViewControllers:array
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:YES
                                     completion:nil];
    } else {
        [self.pageController setViewControllers:array
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    }
    
}


#pragma mark - HXSClickEventDelegate

- (void)onStartEvent:(HXSClickEvent *)event
{
    if(event.eventUrl && event.eventUrl.length > 0) {
        HXSWebViewController * webViewController = [HXSWebViewController controllerFromXib];
        [webViewController setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",event.eventUrl]]];
        webViewController.title = event.title;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}


#pragma mark - UIPageViewControllerDelegate, UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    
    if ((0 == index)
        || (NSNotFound == index)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    
    if (NSNotFound == index) {
        return nil;
    }
    
    index++;
    
    if (index >= [self.categoriesArr count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}


#pragma mark - Create VCs

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (index >= [self.categoriesArr count]) {
        return nil;
    }
    
    HXSDigitalMobileCategoryListEntity *categoryListEntity = [self.categoriesArr objectAtIndex:index];
    UIViewController *viewController = [self.pageViewControllersArr objectAtIndex:index];
    
    if (![viewController isKindOfClass:[UIViewController class]]) {
        __weak typeof(self) weakSelf = self;
        
        if ([categoryListEntity.categoryNameStr isEqualToString:kHotCategoryName]) {
            HXSDigitalMobileHotViewController *hotVC = [HXSDigitalMobileHotViewController controllerFromXib];
            
            hotVC.index = index;
            hotVC.categoryIDIntNum = categoryListEntity.categoryIDIntNum;
            hotVC.updateSelectionTitle = ^(NSInteger index) {
                [weakSelf.scrollabelTabBar setSelectedIndex:index animated:YES];
                weakSelf.currentPage = index;
            };
            hotVC.scrollviewScrolled = ^(CGPoint offset) {
                if (0 < offset.y) {
                    [UIView animateWithDuration:0.5
                                     animations:^{
                                         weakSelf.baseScrollview.contentOffset = CGPointMake(0, weakSelf.bannerHeaderViewHeightConstraint.constant);
                                     }];
                } else {
                    [UIView animateWithDuration:0.5
                                     animations:^{
                                         weakSelf.baseScrollview.contentOffset = CGPointZero;
                                     }];
                }
            };
            
            [self.pageViewControllersArr replaceObjectAtIndex:index withObject:hotVC];
            viewController = hotVC;
        } else {
            HXSDigitalMobileListViewController *listVC = [HXSDigitalMobileListViewController controllerFromXib];
            
            listVC.index = index;
            listVC.categoryIDIntNum = categoryListEntity.categoryIDIntNum;
            listVC.updateSelectionTitle = ^(NSInteger index) {
                [weakSelf.scrollabelTabBar setSelectedIndex:index animated:YES];
                weakSelf.currentPage = index;
            };
            listVC.scrollviewScrolled = ^(CGPoint offset) {
                if (0 < offset.y) {
                    [UIView animateWithDuration:0.5
                                     animations:^{
                                         weakSelf.baseScrollview.contentOffset = CGPointMake(0, weakSelf.bannerHeaderViewHeightConstraint.constant);
                                     }];
                } else {
                    [UIView animateWithDuration:0.5
                                     animations:^{
                                         weakSelf.baseScrollview.contentOffset = CGPointZero;
                                     }];
                }
            };
            
            [self.pageViewControllersArr replaceObjectAtIndex:index withObject:listVC];
            viewController = listVC;
        }
    }
    
    return viewController;
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[HXSDigitalMobileHotViewController class]]) {
        HXSDigitalMobileHotViewController *hotVC = (HXSDigitalMobileHotViewController *)viewController;
        
        return hotVC.index;
    } else if ([viewController isKindOfClass:[HXSDigitalMobileListViewController class]]) {
        HXSDigitalMobileListViewController *listVC = (HXSDigitalMobileListViewController *)viewController;
        
        return listVC.index;
    } else {
        return NSNotFound;
    }
}


#pragma mark - Private Methods

- (CGFloat)heightOfBannerHeaderView:(NSArray *)slidItemsArr
{
    CGFloat height = 0.0;
    
    if(0 < [slidItemsArr count]) {
        HXSSlideItem * item = [slidItemsArr objectAtIndex:0];
        CGSize size = item.getImageSize;
        CGFloat scaleOfSize = size.height/size.width;
        if (isnan(scaleOfSize)
            || isinf(scaleOfSize)) {
            scaleOfSize = 1.0;
        }
        
        height = scaleOfSize * self.view.frame.size.width;
    }
    
    return height;
}


@end

//
//  HXSSchoolPostListViewController.m
//  store
//
//  Created by  黎明 on 16/4/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSSchoolPostListViewController.h"
// Controllers
#import "HXSCommunityTagViewController.h"
#import "HXSCommunityPostingViewController.h"
#import "HXSLoginViewController.h"

// Views
#import "HXSelectionControl.h"
#import "HXSPostButton.h"

// Model

// Other
#import "HXSCommunityTagTableDelegate.h"

static CGFloat const kSelectcontrolhright = 44.0f;


@interface HXSSchoolPostListViewController ()<PostButtonDelegate>
@property (nonatomic, strong) HXSTopic             *topic;
@property (nonatomic,strong ) HXSelectionControl   *selectionControl;
@property (nonatomic,strong ) NSMutableArray       *childViewControllers;
@property (nonatomic,strong ) UIPageViewController *tagPageViewController;
@property (nonatomic        ) NSInteger            currentSelectIndex;
/**学校名称 */
@property (nonatomic, strong) NSString *siteNameStr;
/**学校id */
@property (nonatomic, strong) NSString *siteIdStr;

@end

@implementation HXSSchoolPostListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupChildViewController];
    [self setupSubViews];
    [self setupPostButtonOnView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavgationBar];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Intial Methods
- (void)setupPostButtonOnView
{
    HXSPostButton *postButton = [[HXSPostButton alloc] init];
    [postButton setDelegate:self];
    postButton.alpha = 0;
    
    CGFloat RightMargin = 30;
    CGFloat BottomMargin = 30;
    
    CGFloat x = SCREEN_WIDTH - CGRectGetWidth(postButton.frame)/2 - RightMargin;
    CGFloat y = SCREEN_HEIGHT - CGRectGetWidth(postButton.frame)/2 - BottomMargin - 64;
    
    postButton.center = CGPointMake(x, y);
    
    [self.view addSubview:postButton];
    
    [UIView animateWithDuration:1 animations:^{
        
        postButton.alpha = 1;
    }];
}

- (void)setupNavgationBar
{
    self.navigationItem.title = self.siteNameStr;
}


- (void)setupSubViews
{
    [self.view addSubview:self.selectionControl];
}

- (void)setupChildViewController
{
    HXSCommunityTagViewController *hotCommunityTagViewController         = [HXSCommunityTagViewController controllerFromXib];
    [hotCommunityTagViewController loadDataFromServerWith:HXSPostListTypeHot topicId:self.topic.idStr siteId:self.siteIdStr userId:nil];
    
    //    HXSCommunityTagViewController *focusCommunityTagViewController       = [HXSCommunityTagViewController controllerFromXib];
    //    [focusCommunityTagViewController loadDataFromServerWith:HXSPostListTypeRecommend topicId:self.topic.idStr siteId:self.siteIdStr userId:nil];
    
    HXSCommunityTagViewController *reCommendedCommunityTagViewController = [HXSCommunityTagViewController controllerFromXib];
    [reCommendedCommunityTagViewController loadDataFromServerWith:HXSPostListTypeAll topicId:self.topic.idStr siteId:self.siteIdStr userId:nil];
    
    hotCommunityTagViewController.isSchoolPost = YES;
    //    focusCommunityTagViewController.isSchoolPost = YES;
    reCommendedCommunityTagViewController.isSchoolPost = YES;
    
    [self.childViewControllers addObjectsFromArray:@[hotCommunityTagViewController,
                                                     //                                                     focusCommunityTagViewController,
                                                     reCommendedCommunityTagViewController,
                                                     ]];
    
    
    [self.tagPageViewController setViewControllers:@[hotCommunityTagViewController]
                                         direction:UIPageViewControllerNavigationDirectionForward
                                          animated:YES
                                        completion:nil];
    
    self.currentSelectIndex = 0;
    
    [self addChildViewController:self.tagPageViewController];
    
    [self.view addSubview:self.tagPageViewController.view];
    
    self.tagPageViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pageView]-0-|" options:0 metrics:nil views:@{@"pageView":self.tagPageViewController.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[pageView]-0-|" options:0 metrics:nil views:@{@"pageView":self.tagPageViewController.view}]];
    
    
    
    
    [self.tagPageViewController didMoveToParentViewController:self];
}

//选择话题
- (void)selectItemAction:(HXSelectionControl *)sender
{
    NSInteger index = sender.selectedIdx;
    
    if (index > self.currentSelectIndex) {
        
        [self.tagPageViewController setViewControllers:@[self.childViewControllers[index]]
                                             direction:UIPageViewControllerNavigationDirectionForward
                                              animated:YES
                                            completion:nil];
        
    } else {
        
        [self.tagPageViewController setViewControllers:@[self.childViewControllers[index]]
                                             direction:UIPageViewControllerNavigationDirectionReverse
                                              animated:YES
                                            completion:nil];
    }
    
    self.currentSelectIndex = index;
}

/**
 *  发帖
 */
- (void)postButtonClickAction
{
    if ([HXSUserAccount currentAccount].isLogin){
        HXSCommunityPostingViewController *communityPostingViewController = [[HXSCommunityPostingViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityPostingViewController class]) bundle:nil];
        [communityPostingViewController setPostSiteId:self.siteIdStr siteName:self.siteNameStr];
        [self.navigationController pushViewController:communityPostingViewController animated:YES];
    }else{
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            
        }];
    }
}

#pragma mark - Get Set Methods
- (HXSelectionControl *)selectionControl
{
    if (!_selectionControl) {
        
        _selectionControl = [[HXSelectionControl alloc] init];
        
        [_selectionControl setFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSelectcontrolhright)];
        
        [_selectionControl setTitles:@[@"热门",/*@"推荐",*/@"全部"]];
        
        [_selectionControl addTarget:self action:@selector(selectItemAction:) forControlEvents:UIControlEventValueChanged];
        
        [_selectionControl setSelectedIdx:0];
    }
    return _selectionControl;
}

- (UIPageViewController *)tagPageViewController
{
    if (!_tagPageViewController) {
        
        _tagPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                 navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                               options:nil];
    }
    return _tagPageViewController;
}

- (NSMutableArray *)childViewControllers
{
    if (!_childViewControllers) {
        
        _childViewControllers = [NSMutableArray array];
    }
    return _childViewControllers;
}

- (void)initCommunitySchoolListViewControllerSiteName:(NSString *)siteStr SiteId:(NSString *)siteIdStr
{
    _siteIdStr = siteIdStr;
    _siteNameStr = siteStr;
}

@end

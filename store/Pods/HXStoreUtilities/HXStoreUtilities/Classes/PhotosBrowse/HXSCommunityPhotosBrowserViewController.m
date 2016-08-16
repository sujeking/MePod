//
//  HXSCommunityPhotosBrowserViewController.m
//  store
//
//  Created by J006 on 16/4/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityPhotosBrowserViewController.h"

#import "HXSCommunityPhotosViewController.h"
#import "HXSCustomAlertView.h"
#import "Masonry.h"
#import "UIViewController+Extensions.h"

@interface HXSCommunityPhotosBrowserViewController ()<UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
HXSCommunityPhotosViewControllerDelegate>

@property (nonatomic ,strong) UIPageViewController                  *pageController;
@property (nonatomic ,strong) NSMutableArray                        *uploadImageParamArray;
@property (nonatomic ,strong) NSMutableArray                        *photoImageViewControllerArray;
@property (nonatomic ,strong) UIBarButtonItem                       *rightBarButton;        // 右上角按钮
@property (nonatomic ,strong) HXSCustomAlertView                    *alertView;             // 删除提醒弹框
@property (nonatomic ,readwrite) NSInteger                          pendingIndex;
@property (nonatomic ,readwrite) NSInteger                          currentIndex;           // 当前图片索引
@property (nonatomic ,readwrite) NSInteger                          type;
@property (nonatomic ,strong) UIImageView                           *tapImageView;
@property (weak, nonatomic) IBOutlet UILabel                        *imageIndexLabel;
@property (nonatomic ,strong) HXSPost                               *postEntity;

@end

@implementation HXSCommunityPhotosBrowserViewController

#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self initialNavigation];
    [self initThePageViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark init

- (void)setTheOriginImageView:(UIImageView *)imageView
{
    _tapImageView = imageView;
}

- (void)setThePostEntity:(HXSPost *)post
{
    _postEntity = post;
}

- (void)initCommunityPhotosBrowserWithImageParamArray:(NSMutableArray<HXSCommunitUploadImageEntity *> *)uploadImageParamArray
                                             andIndex:(NSInteger)index
                                              andType:(CommunitPhotoBrowserType)type
{
    _type = type;
    if(!uploadImageParamArray)
        return;
    _currentIndex = index;
    _uploadImageParamArray = uploadImageParamArray;
    if(!_photoImageViewControllerArray)
        _photoImageViewControllerArray = [[NSMutableArray alloc]init];
    for (HXSCommunitUploadImageEntity *entity in uploadImageParamArray)
    {
        HXSCommunityPhotosViewController *photoVC = [HXSCommunityPhotosViewController controllerFromXibWithModuleName:@"PhotosBrowse"];
        [photoVC initHXSCommunityPhotosViewControllerWithEntity:entity andWithType:_type];
        photoVC.delegate = self;
        UIImageView *imageView = entity.imageView;
        if(!imageView
           && [uploadImageParamArray indexOfObject:entity] > 2) // 3张图片以后非帖子详情界面需要设置返回图片的frame
        {
            entity.imageView = [[uploadImageParamArray objectAtIndex:2] imageView];
        }
        
        [_photoImageViewControllerArray addObject:photoVC];
    }
    if(_tapImageView)
    {
        HXSCommunityPhotosViewController *photoVC = [_photoImageViewControllerArray objectAtIndex:index];
        [photoVC setTheOriginImageView:_tapImageView];
    }
}

/**
 *  初始化导航栏
 */
- (void)initialNavigation
{
    if(_type == kCommunitPhotoBrowserTypePostUploadImage)
    {
        [_imageIndexLabel setHidden:YES];
        [self.navigationItem setRightBarButtonItem:self.rightBarButton];
    }
    else if(_type == kCommunitPhotoBrowserTypeViewImage)
    {
        [_imageIndexLabel setHidden:NO];
        _imageIndexLabel.layer.cornerRadius = 12;
        [_imageIndexLabel setClipsToBounds:YES];
    }
    [self refreshTheNavigationTitleAndTheImageIndexLabel];
}

/**
 *  初始化照片界面读取的viewcontroller
 */
- (void)initThePageViewController
{
    [self addChildViewController:self.pageController];
    [self.view addSubview:_pageController.view];
    [_pageController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.pageController didMoveToParentViewController:self];
    UIViewController *initialVC = [self viewControllerAtIndex:_currentIndex];
    NSArray *array = [NSArray arrayWithObjects:initialVC, nil];
    [self.pageController setViewControllers:array
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES
                                 completion:^(BOOL finished){
                                 }];
    if(_type == kCommunitPhotoBrowserTypeViewImage)
    {
        [self.view bringSubviewToFront:_imageIndexLabel];
    }
}

#pragma mark - UIPageViewControllerDelegate, UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    
    if ((0 == index)
        || (NSNotFound == index))
    {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    
    if (NSNotFound == index)
    {
        return nil;
    }
    
    index++;
    if (index >= [_photoImageViewControllerArray count])
    {
        return nil;
    }

    return [self viewControllerAtIndex:index];
}


- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        UIViewController *vc = [pageViewController.viewControllers lastObject];
        _currentIndex = [_photoImageViewControllerArray indexOfObject:vc];
        [self refreshTheNavigationTitleAndTheImageIndexLabel];
        [self setRightBarButton:self.rightBarButton];
    }
}

#pragma mark HXSCommunityPhotosViewControllerDelegate

- (void)removeAndBackToMainView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)noticeTheViewBrowserBGColorTurnClear
{
    [self.view setBackgroundColor:[UIColor clearColor]];
    [_imageIndexLabel setHidden:YES];
}

- (void)reportThePhoto
{
    if(_postEntity)
    {
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(reportThePhotoWithEntity:)])
        {
            [self.delegate reportThePhotoWithEntity:_postEntity];
            [self.view removeFromSuperview];
        }
    }
}

#pragma mark BarButtonAction

/**
 *  右上角按钮操作:删除
 */
- (void)rightButtonAction:(UIBarButtonItem *)rightBarButton
{
    [self.alertView show];
}

#pragma mark delImageViewAction

/**
 *  删除图片
 */
- (void)deleteTheImageView
{
    [_photoImageViewControllerArray removeObjectAtIndex:_currentIndex];
    [_uploadImageParamArray         removeObjectAtIndex:_currentIndex];
    if([_uploadImageParamArray count] == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UIViewController *initialVC = [self viewControllerAtIndex:0]; //默认第一张图
    NSArray *array = [NSArray arrayWithObjects:initialVC, nil];
    [self.pageController setViewControllers:array
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES
                                 completion:nil];
    _currentIndex = 0;
    [self refreshTheNavigationTitleAndTheImageIndexLabel];
}

#pragma mark private methods

/**
 *  返回指定的vc
 *
 *  @param index 缩印
 *
 *  @return
 */
- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (!_photoImageViewControllerArray || index >= [_photoImageViewControllerArray count])
    {
        return nil;
    }
    UIViewController *vc = [_photoImageViewControllerArray objectAtIndex:index];
    return vc;
}

/**
 * 返回指定的vc在数组里的索引
 *
 *  @param viewController
 *
 *  @return
 */
- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{
    for (NSInteger i = 0; i < [_photoImageViewControllerArray count]; i++)
    {
        if([viewController isEqual:[_photoImageViewControllerArray objectAtIndex:i]])
        {
            return i;
        }
    }
    return 0;
}

/**
 *  刷新导航栏
 */
- (void)refreshTheNavigationTitleAndTheImageIndexLabel
{
    NSString *title = [NSString stringWithFormat:@"%ld/%ld",(long)_currentIndex+1,(long)[_photoImageViewControllerArray count]];
    switch (_type)
    {
        case kCommunitPhotoBrowserTypePostUploadImage:
        {
            [self.navigationItem setTitle:title];
        }
            break;
            
        case kCommunitPhotoBrowserTypeViewImage:
        {
            [_imageIndexLabel setText:title];
        }
            break;
    }
}

#pragma mark getter setter

- (UIPageViewController *)pageController
{
    if(!_pageController)
    {
        NSNumber *spineLocationNumber = [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMax];
        NSDictionary *options = [NSDictionary dictionaryWithObject:spineLocationNumber
                                                            forKey:UIPageViewControllerOptionSpineLocationKey];
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:options];
        [self.pageController.view setBackgroundColor:[UIColor clearColor]];
        self.pageController.delegate = self;
        self.pageController.dataSource = self;
    }
    return _pageController;
}

- (UIBarButtonItem *)rightBarButton
{
    if(!_rightBarButton)
    {
        _rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"删除"
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(rightButtonAction:)];
    }
    return _rightBarButton;
}

- (HXSCustomAlertView *)alertView
{
    if(!_alertView)
    {
        _alertView = [[HXSCustomAlertView alloc]initWithTitle:@"提醒"
                                                      message:@"要删除这张照片吗?"
                                              leftButtonTitle:@"取消"
                                            rightButtonTitles:@"删除"];
        __weak typeof(self) weakSelf = self;
        [_alertView setRightBtnBlock:^{
            [weakSelf deleteTheImageView];
        }];
    }
    return _alertView;
}

@end

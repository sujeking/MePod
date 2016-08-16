//
//  HXSRobTaskViewController.m
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSKnight.h"
// Controllers
#import "HXSRobTaskViewController.h"
#import "HXSTaskHandledViewController.h"
#import "HXSWaitingToHandleViewController.h"
#import "HXSWaitingToRobViewController.h"

// Views
#import "HXSelectionControl.h"

// Model


@interface HXSRobTaskViewController ()< HXSWaitingToRobViewControllerDelegate,
                                        HXSWaitingToHandleViewControllerDelegate>

@property (nonatomic, weak) IBOutlet HXSelectionControl *selectionControl;
@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic, strong) NSMutableArray<UIViewController *> *controllers;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) NSMutableArray       *titlesArr;

@property (nonatomic, readwrite) NSInteger currentSelectIndex;
@end

@implementation HXSRobTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialNav];
    [self initialSelectionControl];
    [self initChildViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - initial
- (void)initialNav{
   self.navigationItem.title = @"抢任务赚钱";
}

- (void)initialSelectionControl{
    _titlesArr = [NSMutableArray arrayWithObjects:@"待抢单(0)", @"待处理(0)",@"已处理", nil];
    _selectionControl.titles = _titlesArr;
}

- (void)initChildViewController{
    HXSWaitingToRobViewController *waitingToRobViewController = [[HXSWaitingToRobViewController alloc]initWithNibName:nil bundle:nil];
    waitingToRobViewController.delegate = self;
    
    HXSWaitingToHandleViewController *waitingToHandleViewController = [[HXSWaitingToHandleViewController alloc]initWithNibName:nil bundle:nil];
    waitingToHandleViewController.delegate = self;
    [waitingToHandleViewController getDataCount];
    
    HXSTaskHandledViewController *taskHandledViewController = [[HXSTaskHandledViewController alloc]initWithNibName:nil bundle:nil];
    
    self.controllers = [NSMutableArray arrayWithObjects:
                        waitingToRobViewController,
                        waitingToHandleViewController,
                        taskHandledViewController,
                        nil];
    [self.pageController setViewControllers:@[waitingToRobViewController]
                                         direction:UIPageViewControllerNavigationDirectionForward
                                          animated:YES
                                        completion:nil];
    _currentSelectIndex = 0;
    
    [self addChildViewController:self.pageController];
    [self.containerView addSubview:[self.pageController view]];
    [self.pageController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
 }

#pragma mark - Target/Action
- (IBAction)selectionControlValueChanged:(id)sender{
    
    [HXSUsageManager trackEvent:kUsageEventKnightOrderTab parameter:nil];

    
    HXSelectionControl *selectionControl = (HXSelectionControl *)sender;
    NSInteger index = selectionControl.selectedIdx;
    
    if (index > _currentSelectIndex)
    {
        
        [self.pageController setViewControllers:@[_controllers[index]]
                                             direction:UIPageViewControllerNavigationDirectionForward
                                              animated:YES
                                            completion:nil];
        
    }
    else
    {
        
        [self.pageController setViewControllers:@[_controllers[index]]
                                             direction:UIPageViewControllerNavigationDirectionReverse
                                              animated:YES
                                            completion:nil];
    }
    _currentSelectIndex = index;
}

#pragma mark - HXSWaitingToRobViewControllerDelegate
- (void)waitingToRobTableReloadFinish:(NSInteger)dataCount{
    NSString *str = [NSString stringWithFormat:@"待抢单(%ld)",(long)dataCount];
    [_titlesArr replaceObjectAtIndex:0 withObject:str];
    _selectionControl.titles = _titlesArr;
    _selectionControl.selectedIdx = _currentSelectIndex;
}

#pragma mark - HXSWaitingToHandleViewControllerDelegate
- (void)waitingToHandleTableReloadFinish:(NSInteger)dataCount{
    NSString *str = [NSString stringWithFormat:@"待处理(%ld)",(long)dataCount];
    [_titlesArr replaceObjectAtIndex:1 withObject:str];
    _selectionControl.titles = _titlesArr;
    _selectionControl.selectedIdx = _currentSelectIndex;

}

#pragma mark - Get Set Methods
- (UIPageViewController *)pageController{
    if(_pageController)
        return _pageController;
    
    _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                    options:nil];
    return _pageController;
}

@end

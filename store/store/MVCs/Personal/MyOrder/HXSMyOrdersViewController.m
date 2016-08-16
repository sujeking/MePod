//
//  HXSMyOrdersViewController.m
//  store
//
//  Created by chsasaw on 14/12/5.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSMyOrdersViewController.h"

// Controllers
#import "HXSMyEachOrderViewController.h"
#import "HXSMyBoxOderViewController.h"
#import "HXSLoginViewController.h"
#import "HXSCreditOrderViewController.h"
#import "HXSPrintOrderViewController.h"

// Views
#import "HXSelectionControl.h"

// Model
#import "HXSPrintOrderInfo.h"


@interface HXSMyOrdersViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet HXSelectionControl *selectionControl;
@property (weak, nonatomic) IBOutlet UIView *myOrdersView;

- (IBAction)selectionControlValueChanged:(id)sender;

@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) NSArray              *pageContent;
@property (nonatomic, assign) NSInteger            currentPage;

@property (nonatomic, strong) HXSMyEachOrderViewController *dormEachOrderVC;
@property (nonatomic, strong) HXSMyBoxOderViewController   *boxOrderVC;
@property (nonatomic, strong) HXSCreditOrderViewController *creditOrderVC;
@property (nonatomic, strong) HXSPrintOrderViewController *printOrderVC; // 云印店

@end

@implementation HXSMyOrdersViewController


#pragma mark - UIViewController Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.isFromPersonalCenter = NO;
        self.isFromDorm = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的订单";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    
    _selectionControl.titles = @[@"夜猫店", @"花不完", @"云印店", @"零食盒"];
    
    [self createPageContent];
    
    [self initialPageViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.pageController = nil;
}


#pragma mark - Initial Methods

- (void)createPageContent
{
    NSMutableArray *contentMArr = [[NSMutableArray alloc] initWithCapacity:[self.selectionControl.titles count]];
    
    for (int i=0; i < [self.selectionControl.titles count]; i++) {
        [contentMArr addObject:[NSNumber numberWithInt:i]];
    }
    
    self.pageContent = contentMArr;
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
    _pageController.view.backgroundColor = [UIColor clearColor];
    
    self.pageController.delegate   = self;
    self.pageController.dataSource = self;
    [self.pageController.view setFrame:self.myOrdersView.frame];
    
    
    NSNumber *orderTypeNumber = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LATEST_ORDER_TYPE];
    NSInteger index = 0;
    if (nil != orderTypeNumber)
    {
        switch ([orderTypeNumber intValue]) {
            case kHXSOrderTypeStore:
                index = [_selectionControl.titles indexOfObject:@"云超市"];
                break;
                
            case kHXSOrderTypeDorm:
                index = [_selectionControl.titles indexOfObject:@"夜猫店"];
                break;
                
            case kHXSOrderTypeDrink:
                index = [_selectionControl.titles indexOfObject:@"饮品店"];
                break;
                
            case kHXSOrderTypeNewBox:
                index = [_selectionControl.titles indexOfObject:@"零食盒"];
                break;
                
            case kHXSOrderTypeEleme:
                index = [_selectionControl.titles indexOfObject:@"外卖"];
                break;
                
            case kHXSOrderTypeCharge:
            case kHXSOrderTypeInstallment:
            case kHXSOrderTypeEncashment:
            case kHXSOrderTypeOneDream:
                index = [_selectionControl.titles indexOfObject:@"花不完"];
                break;

             case kHXSOrderTypePrint:
                index = [_selectionControl.titles indexOfObject:@"云印店"];
                break;
            default:
                break;
        }
    }
    
    
    UIViewController *initialVC = [self viewControllerAtIndex:index]; // default: display first one
    NSArray *array = [NSArray arrayWithObjects:initialVC, nil];
    [self.pageController setViewControllers:array
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES
                                 completion:nil];
    [self addChildViewController:self.pageController];
    
    [self.myOrdersView addSubview:self.pageController.view];
    [self.pageController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.myOrdersView);
    }];
    
    [self.myOrdersView layoutIfNeeded];
    [self.pageController didMoveToParentViewController:self];
}


#pragma mark - Target Methods

- (void)back
{
    if (self.isFromPersonalCenter) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)selectionControlValueChanged:(id)sender
{
    HXSelectionControl *selectionControl = (HXSelectionControl *)sender;
    
    NSArray *array = [NSArray arrayWithObject:[self viewControllerAtIndex:selectionControl.selectedIdx]];
    
    if (0 >= [array count]) {
        return; // Do nothing when view controllers is empty
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self.selectionControl setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.selectionControl setUserInteractionEnabled:YES];
    });
    
    if (self.currentPage > selectionControl.selectedIdx) {
        [self.pageController setViewControllers:array
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:YES
                                     completion:^(BOOL finished) {
                                         
                                     }];
    } else {
        [self.pageController setViewControllers:array
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:^(BOOL finished) {
                                         
                                     }];
    }
}



#pragma mark - UIPageViewControllerDelegate, UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    
    if ((0 == index)
        || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [self.selectionControl.titles count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(!completed) {
        return;
    }
}

#pragma mark - Private Methods

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    if ([self.selectionControl.titles count] <= index) {
        return nil;
    }
    
    switch (index) {
        case 0:
        {
            if (nil == self.dormEachOrderVC) {
                HXSMyEachOrderViewController *orderVC = [[HXSMyEachOrderViewController alloc] initWithNibName:@"HXSMyEachOrderViewController" bundle:[NSBundle mainBundle]];
                
                orderVC.typeNumber = [self.pageContent objectAtIndex:index];
                
                __weak HXSMyOrdersViewController *weakSelf = self;
                orderVC.updateSelectionTitle = ^(NSInteger index){
                    [weakSelf.selectionControl setSelectedIdx:index];
                    weakSelf.currentPage = index;
                };
                
                self.dormEachOrderVC = orderVC;
            }
            
            return self.dormEachOrderVC;
        }
            break;
            
        case 1:
        {
            if (nil == self.creditOrderVC) {
                HXSCreditOrderViewController *orderVC = [HXSCreditOrderViewController controllerFromXib];
                
                orderVC.typeNumber = [self.pageContent objectAtIndex:index];
                
                __weak typeof(self) weakSelf = self;
                orderVC.updateSelectionTitle = ^(NSInteger index){
                    [weakSelf.selectionControl setSelectedIdx:index];
                    weakSelf.currentPage = index;
                };
                
                self.creditOrderVC = orderVC;
            }
            
            return self.creditOrderVC;
        }
            break;
            
        case 2:{
            
            if(nil == self.printOrderVC){
                HXSPrintOrderViewController *orderVC = [HXSPrintOrderViewController controllerFromXib];
                orderVC.typeNumber = [self.pageContent objectAtIndex:index];
                
                __weak typeof (self) weakSelf = self;
                
                orderVC.updateSelectionTitle = ^(NSInteger index){
                    [weakSelf.selectionControl setSelectedIdx:index];
                    weakSelf.currentPage = index;
                };
                
                self.printOrderVC  = orderVC;
            }
            return self.printOrderVC;
        }
            break;
            
        case 3:
        {
            if (nil == self.boxOrderVC) {
                HXSMyBoxOderViewController *orderVC = [[HXSMyBoxOderViewController alloc] initWithNibName:@"HXSMyBoxOderViewController" bundle:[NSBundle mainBundle]];
                
                orderVC.typeNumber = [self.pageContent objectAtIndex:index];
                
                __weak HXSMyOrdersViewController *weakSelf = self;
                orderVC.updateSelectionTitle = ^(NSInteger index){
                    [weakSelf.selectionControl setSelectedIdx:index];
                    weakSelf.currentPage = index;
                };
                
                self.boxOrderVC = orderVC;
            }
            
            return self.boxOrderVC;
        }
            break;
            
        default:
            break;
    }
    
    
    return nil;
    
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{
    if (viewController == self.dormEachOrderVC) {
        return 0;
    } else if (viewController == self.creditOrderVC) {
        return 1;
    } else if (viewController == self.printOrderVC){
        return 2;
    } else if (viewController == self.boxOrderVC) {
        return 3;
    }
    
    return NSNotFound;
    
}

- (void)replacePrintOrderInfo:(HXSPrintOrderInfo *)order
{
    [_printOrderVC replaceOrderInfo:order];
}

@end

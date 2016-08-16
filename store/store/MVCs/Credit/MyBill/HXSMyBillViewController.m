//
//  HXSMyBillViewController.m
//  store
//
//  Created by J006 on 16/2/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyBillViewController.h"

#import "HXSMyPayBillViewController.h"
#import "HXSBorrowBillViewController.h"

@interface HXSMyBillViewController ()

@property (nonatomic, strong) UISegmentedControl                    *segmentedControl;
@property (nonatomic, strong) HXSMyPayBillViewController            *myPayBillViewController;
@property (nonatomic, strong) HXSBorrowBillViewController           *borrowBillViewController;

@end

@implementation HXSMyBillViewController


#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialNavigationBar];
    [self initChildViewController];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
}


#pragma mark - init

/**
 *初始化导航栏，增加Segment控件
 */
- (void)initialNavigationBar
{
    [self.navigationItem setTitleView:self.segmentedControl];
    CGRect segmentedControlFrame = _segmentedControl.frame;
    segmentedControlFrame.size = CGSizeMake(160, 30);//顶部左右切换控件的大小
    _segmentedControl.frame = segmentedControlFrame;
}

/**
 *添加2个子vc
 */
- (void)initChildViewController
{
    [self addChildViewController:self.myPayBillViewController];
    [self addChildViewController:self.borrowBillViewController];
    [self.view addSubview:_myPayBillViewController.view];
    [_myPayBillViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_myPayBillViewController didMoveToParentViewController:self];
}


#pragma mark - segement Action

- (void)segmentValueChanged:(UISegmentedControl *)segment
{
    NSInteger selectIndex = segment.selectedSegmentIndex;
    switch (selectIndex) {
        case 1:
        {
            [self transitionFromViewController:_myPayBillViewController toViewController:_borrowBillViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
              [_borrowBillViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
              }];
            } completion:^(BOOL finished) {
                [_borrowBillViewController didMoveToParentViewController:self];
            }];
        }
            break;
            
        default:
        {
        
            [self transitionFromViewController:_borrowBillViewController toViewController:_myPayBillViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
             [_myPayBillViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
             }];
            } completion:^(BOOL finished) {
             
             [_myPayBillViewController didMoveToParentViewController:self];
            }];
        }
            break;
    }
}

#pragma mark - getter setter

- (UISegmentedControl *)segmentedControl
{
    if(!_segmentedControl){
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"消费类账单",@"分期类账单",nil];
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        _segmentedControl.selectedSegmentIndex = [self.selectedSegmentIndexIntNum integerValue];
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeZero;
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: HXS_MAIN_COLOR,
                                                                  NSFontAttributeName : [UIFont systemFontOfSize:13],
                                                                  NSShadowAttributeName:shadow}  forState:UIControlStateSelected];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                  NSFontAttributeName : [UIFont systemFontOfSize:13],
                                                                  NSShadowAttributeName:shadow}  forState:UIControlStateNormal];
        
        //UISegmentedControl - backgroundImage
        [_segmentedControl  setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        UIImage* selectedBackgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
        [_segmentedControl setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        //UISegmentedControl - divider
        [_segmentedControl setDividerImage:selectedBackgroundImage forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        [_segmentedControl setDividerImage:selectedBackgroundImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        [_segmentedControl setDividerImage:selectedBackgroundImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        [_segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [_segmentedControl.layer setMasksToBounds:YES];
        [_segmentedControl.layer setCornerRadius:3.0];//设置矩圆角半径,数值越大圆弧越大，反之圆弧越小
        [_segmentedControl.layer setBorderWidth:1.0];//边框宽度

        CGColorRef      colorref = [UIColor colorWithRGBHex:0xFFFFFF].CGColor;
        ;
        [_segmentedControl.layer setBorderColor:colorref];//边框颜色
    }
    return _segmentedControl;
}


#pragma mark - getter setter

- (HXSMyPayBillViewController *)myPayBillViewController
{
    if(!_myPayBillViewController) {
        _myPayBillViewController = [HXSMyPayBillViewController controllerFromXib];
    }
    return _myPayBillViewController;
}
 
- (HXSBorrowBillViewController *)borrowBillViewController
{
    if(!_borrowBillViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay"
                                                             bundle:[NSBundle mainBundle]];
        _borrowBillViewController = [storyboard instantiateViewControllerWithIdentifier:@"HXSBorrowBillViewController"];
    }
    return _borrowBillViewController;
}

@end

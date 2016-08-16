//
//  HXSBaseTableViewController.m
//  store
//
//  Created by hudezhi on 15/7/22.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseTableViewController.h"

#import "HXSWarningBarView.h"
#import "UIColor+Extensions.h"
#import "UIViewController+Extensions.h"


#define COLOR_MESSAGE_BACKGROUND [UIColor colorWithR:252 G:244 B:150 A:1.0]

#define TAG_NAVIGATION_TIEM_BUTTON    10000

@interface HXSBaseTableViewController ()

@end

@implementation HXSBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBarStatus];
    self.tableView.contentInset = UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initNavigationBarStatus
{
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xF5F6FB];
    self.navigationItem.backBarButtonItem = nil;
    
    if(nil == self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:(self.navigationController.viewControllers.count == 1?@"icon_back_down":@"btn_back_normal")] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem.imageInsets = self.navigationController.viewControllers.count == 1 ? UIEdgeInsetsZero : UIEdgeInsetsMake(0, -5, 0, 5);
    }
}

#pragma mark - Public Methods

- (void)showWarning:(NSString *)wStr
{
    if(wStr == nil || wStr.length == 0)
        return;
    CGFloat warningHeight = UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ? 44 : 35;
    if (!self.warnBarView) {
        self.warnBarView = [[HXSWarningBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), warningHeight)];
    }
    [self.warnBarView customWarningText:wStr];
    [self.view addSubview:self.warnBarView];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.warnBarView removeFromSuperview];
        self.warnBarView = nil;
    });
}

- (void)dismissWarning
{
    self.warnBarView.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

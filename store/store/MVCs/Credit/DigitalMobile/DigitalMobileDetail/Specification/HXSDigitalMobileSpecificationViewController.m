//
//  HXSDigitalMobileSpecificationViewController.m
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileSpecificationViewController.h"

#import "HXSDigitalMobileScrollableTabBar.h"
#import "HXSDigitalMobileSpecificationModel.h"

@interface HXSDigitalMobileSpecificationViewController () <HXSDigitalMobileScrollableTabBarDelegate,
                                                           UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet HXSDigitalMobileScrollableTabBar *scrollableTabBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) HXSDigitalMobileSpecificationModel *specificationModel;
@property (nonatomic, strong) HXSDigitalMobileSpecificationEntity *specificationEntity;


@end

@implementation HXSDigitalMobileSpecificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialScrollableTabBar];
    
    [self fetchSpecificationData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.webView.scrollView.delegate = nil;
}


#pragma mark - Intial Methos

- (void)initialNavigationBar
{
    self.navigationItem.title = @"商品详情";
}

- (void)initialScrollableTabBar
{
    self.scrollableTabBar.scrollableTabBarDelegate = self;
    
    NSDictionary *pictureDic = @{kScrollBarTitle: @"图文详情"};
    NSDictionary *paramDic = @{kScrollBarTitle: @"规格参数"};
    NSMutableArray *itemsMArr = [[NSMutableArray alloc] initWithObjects:pictureDic, paramDic, nil];
    
    [self.scrollableTabBar setItems:itemsMArr animated:YES width:SCREEN_WIDTH number:2];
    
    [self.scrollableTabBar setSelectedIndex:0 animated:YES];
}


#pragma mark - Fetch Data

- (void)fetchSpecificationData
{
    [MBProgressHUD showInView:self.view];
    
    __weak typeof(self) weakSelf = self;
    [self.specificationModel fetchItemParamWithItemID:self.itemIDIntNum
                                             complete:^(HXSErrorCode status, NSString *message, HXSDigitalMobileSpecificationEntity *entity) {
                                                 [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                 if (kHXSNoError != status) {
                                                     [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5f];
                                                     
                                                     return;
                                                 }
                                                 
                                                 weakSelf.specificationEntity = entity;
                                                 
                                                 [weakSelf displayWebView];
                                             }];
}


#pragma mark - Display Webview

- (void)displayWebView
{
    NSString *htmlStr = nil;
    if (0 == self.scrollableTabBar.selectedIndex) {
        htmlStr = self.specificationEntity.pictureDetailHTMLStr;
    } else {
        htmlStr = self.specificationEntity.paramHTMLStr;
    }
    
    htmlStr = [NSString stringWithFormat:@"<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><!-- disable iPhone inital scale --><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"><title>Demo: Adaptive Design With Media Queries</title><style>img{width:100\%% !important; height: 100\%% !important;}</style></head><body>%@</body></html>", htmlStr];
    
    self.webView.scrollView.delegate = self;
    [self.webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:HXS_SERVER_URL]];
    
    self.webView.scalesPageToFit = YES;
}


#pragma mark - HXSDigitalMobileScrollableTabBarDelegate

- (void)scrollableTabBar:(HXSDigitalMobileScrollableTabBar *)tabBar didSelectItemWithIndex:(int)index
{
    [self displayWebView];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (-100.0 > scrollView.contentOffset.y) {
        if (nil != self.hasPullDown) {
            self.hasPullDown();
        }
    }
}


#pragma mark - Setter Getter Methods

- (HXSDigitalMobileSpecificationModel *)specificationModel
{
    if (nil == _specificationModel) {
        _specificationModel = [[HXSDigitalMobileSpecificationModel alloc] init];
    }
    
    return _specificationModel;
}

@end

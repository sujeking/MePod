//
//  HXSWebViewController.m
//  store
//
//  Created by chsasaw on 14/10/30.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSWebViewController.h"
#import "MyJSInterface.h"
#import "HXSCity.h"
#import "HXSSite.h"
#import "HXSBoxEntry.h"
#import "HXSSinaWeiboManager.h"
#import "HXSQQSdkManager.h"
#import "UIImageView+AFNetworking.h"
#import "HXSWXApiManager.h"
#import "AFImageDownloader.h"
#import "HXSMediator+HXPersonalModule.h"
#import "HXSMediator+AccountModule.h"
#import "HXSMediator+LocationModule.h"
#import "HXMacrosDefault.h"
#import "MBProgressHUD+HXS.h"
#import "HXMacrosUtils.h"
#import "NSURL+QueryDictionary.h"
#import "HXSCustomAlertView.h"
#import "HXAppDeviceHelper.h"
#import "WebViewJavascriptBridge.h"
#import "UIButton+AFNetworking.h"
#import "HXSShareView.h"
#import "HXSMediator+HXLoginModule.h"

/* Hieght of the loading progress bar view */
#define LOADING_BAR_HEIGHT          2

/* Blank UIBarButtonItem creation */
#define BLANK_BARBUTTONITEM [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]

/* Unique URL triggered when JavaScript reports page load is complete */
NSString *kCompleteRPCURL = @"webviewprogress:///complete";

/* Default load values to defer to during the load process */
static const float kInitialProgressValue                = 0.1f;
static const float kBeforeInteractiveMaxProgressValue   = 0.5f;
static const float kAfterInteractiveMaxProgressValue    = 0.9f;

#pragma mark -
#pragma mark Loading Bar Private Interface
@interface HXSWebLoadingView : UIView
@end

@implementation HXSWebLoadingView
- (void)tintColorDidChange { self.backgroundColor = self.tintColor; }
@end

@interface HXSWebViewController ()<UIWebViewDelegate,
                                   UIPopoverControllerDelegate,
                                   UIScrollViewDelegate,
                                   HXSWechatPayDelegate>
{
    //State tracking for load progress of current page
    struct {
        NSInteger   loadingCount;       //Number of requests concurrently being handled
        NSInteger   maxLoadCount;       //Maximum number of load requests that was reached
        BOOL        interactive;        //Load progress has reached the point where users may interact with the content
        CGFloat     loadingProgress;    //Between 0.0 and 1.0, the load progress of the current page
    } _loadingProgressState;
}

@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;                      /* Toolbar shown along the bottom */
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *headerConstraint;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) MyJSInterface *interface;

@property (nonatomic, strong) HXSWebLoadingView *loadingBarView;        /* The loading bar, displayed when a page is being loaded */

/* Navigation Buttons */
@property (nonatomic, weak) IBOutlet UIButton *backButton;                       /* Moves the web view one page back */
@property (nonatomic, weak) IBOutlet UIButton *forwardButton;                    /* Moves the web view one page forward */
@property (nonatomic, weak) IBOutlet UIButton *reloadStopButton;                 /* Reload / Stop buttons */
@property (nonatomic, weak) IBOutlet UIButton *actionButton;                     /* Shows the UIActivityViewController */

/* Images for the Reload/Stop button */
@property (nonatomic, strong) UIImage *reloadIcon;
@property (nonatomic, strong) UIImage *stopIcon;
@property (nonatomic, strong) UIImage *reloadSelectedIcon;
@property (nonatomic, strong) UIImage *stopSelectedIcon;

@property (nonatomic, assign) BOOL hasRefreshed;

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, copy) NSString *rightNaviLink;

@property (nonatomic, strong) HXSShareView *shareView;

@end



@implementation HXSWebViewController

+ (id)controllerFromXib {
    NSBundle *bundle = [NSBundle bundleForClass:[HXSWebViewController class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreWebviewController" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    return [[HXSWebViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:bundle];
}

- (instancetype)init
{
    if (self = [super init])
        [self setup];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
        [self setup];
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
        [self setup];
    
    self.bundle = nibBundleOrNil;
    
    return self;
}

- (instancetype)initWithURL:(NSURL *)url
{
    if (self = [self init])
        _url = [self cleanURL:url];
    
    return self;
}

- (instancetype)initWithURLString:(NSString *)urlString
{
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (NSURL *)cleanURL:(NSURL *)url
{
    if (url.scheme.length == 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", [url absoluteString]]];
    }
    
    NSString *tokenStr = [[HXSMediator sharedInstance] HXSMediator_token];
    NSNumber *siteIDIntNum = [[HXSMediator sharedInstance] HXSMediator_currentSiteID];
    NSNumber *cityIDIntNum = [[HXSMediator sharedInstance] HXSMediator_currentCityID];
    NSNumber *dormentryIDIntNum = [[HXSMediator sharedInstance] HXSMediator_currentDormentryID];
    NSNumber *boxIDIntNum = [[HXSMediator sharedInstance] HXSMediator_boxID];
    
    NSString * string = [NSString stringWithString:url.absoluteString];
    if([string rangeOfString:@"?"].length > 0) {
        string = [NSString stringWithFormat:@"%@&token=%@", string, tokenStr];
    }else {
        string = [NSString stringWithFormat:@"%@?token=%@", string, tokenStr];
    }
    
    if([string rangeOfString:@"site_id"].length == 0 && [string rangeOfString:@"city_id"].length == 0 && [string rangeOfString:@"dormentry_id"].length == 0) {
        
        if (nil != siteIDIntNum) {
            string = [NSString stringWithFormat:@"%@&site_id=%@", string, siteIDIntNum];
        }
        
        if(nil != cityIDIntNum) {
            string = [NSString stringWithFormat:@"%@&city_id=%@", string, cityIDIntNum];
        }
        
        if(nil != dormentryIDIntNum) {
            string = [NSString stringWithFormat:@"%@&dormentry_id=%@", string, dormentryIDIntNum];
        }
        
        if(nil != boxIDIntNum) {
            string = [NSString stringWithFormat:@"%@&box_id=%@", string, boxIDIntNum];
        }
    }
    
    url = [NSURL URLWithString:string];
    
    return url;
}

- (void)setup
{
    //Direct ivar reference since we don't want to trigger their actions yet
    _showActionButton = YES;
    _showLoadingBar = YES;
    
    //Set the initial default style as full screen (But this can be easily overwritten)
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWebView:)
                                                 name:kLoginCompleted
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWebView:)
                                                 name:kLogoutCompleted
                                               object:nil];
}

- (void)updateWebView:(NSNotification *)notification
{
    [self.webView reload];
}

- (void)setUpToolBarButtons
{
    //set up the back button
    UIImage *backButtonImage = [[UIImage imageNamed:@"web_icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *backButtonSelectedImage = [[UIImage imageNamed:@"web_icon_back_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.backButton setShowsTouchWhenHighlighted:YES];
    [self.backButton setImage:backButtonImage forState:UIControlStateNormal];
    [self.backButton setImage:backButtonSelectedImage forState:UIControlStateHighlighted];
    
    //set up the forward button (Don't worry about the frame at this point as it will be hidden by default)
    UIImage *forwardButtonImage = [[UIImage imageNamed:@"web_icon_forward"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *forwardButtonSelectedImage = [[UIImage imageNamed:@"web_icon_forward_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.forwardButton setShowsTouchWhenHighlighted:YES];
    [self.forwardButton setImage:forwardButtonImage forState:UIControlStateNormal];
    [self.forwardButton setImage:forwardButtonSelectedImage forState:UIControlStateHighlighted];
    
    [self.reloadStopButton setShowsTouchWhenHighlighted:YES];
    
    self.reloadIcon = [[UIImage imageNamed:@"web_icon_refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.reloadSelectedIcon = [[UIImage imageNamed:@"web_icon_refresh_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.stopIcon   = [[UIImage imageNamed:@"web_icon_stop"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.stopSelectedIcon   = [[UIImage imageNamed:@"web_icon_stop_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.reloadStopButton setImage:self.reloadIcon forState:UIControlStateNormal];
    [self.reloadStopButton setImage:self.reloadSelectedIcon forState:UIControlStateHighlighted];
    
    //if desired, show the action button
    if (self.showActionButton) {
        [self.actionButton setShowsTouchWhenHighlighted:YES];
        
        [self.actionButton setImage:[[UIImage imageNamed:@"web_icon_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.actionButton setImage:[[UIImage imageNamed:@"web_icon_share_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.contentMode = UIViewContentModeRedraw;
    self.webView.scrollView.delegate = self;
    self.webView.keyboardDisplayRequiresUserAction = NO;
    self.webView.scalesPageToFit = YES;
    
    self.interface = [[MyJSInterface alloc] init];
    self.interface.currentViewController = self;

#if DEBUG
    [WebViewJavascriptBridge enableLogging];
#endif
    WebViewJavascriptBridge *bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [bridge setWebViewDelegate:self];
    
    [self.interface setUpWithBridge:bridge];
    

    //Set up the loading bar
    CGFloat y = self.webView.scrollView.contentInset.top;
    self.loadingBarView = [[HXSWebLoadingView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.view.frame), LOADING_BAR_HEIGHT)];
    self.loadingBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //set the tint color for the loading bar
    if (self.loadingBarTintColor == nil) {
        if (self.navigationController && self.navigationController.view.window.tintColor)
            self.loadingBarView.backgroundColor = self.navigationController.view.window.tintColor;
        else if (self.view.window.tintColor)
            self.loadingBarView.backgroundColor = self.view.window.tintColor;
        else
            self.loadingBarView.backgroundColor = [UIColor whiteColor];
    }else {
        self.loadingBarView.backgroundColor = self.loadingBarTintColor;
    }
    
    [self setUpToolBarButtons];
    
    self.toolbarItems = self.toolbar.items;
    self.toolbar.barStyle = UIBarStyleDefault;
    self.toolbar.translucent = NO;
//    self.toolbar.barTintColor = HXS_TEXT_COLOR;
    self.toolbar.tintColor = UIColorFromRGB(0xffffff);
    self.toolbar.backgroundColor = UIColorFromRGB(0xffffff);
    
    [self initialNavigationBar];
}

- (void)cartRefreshed:(NSNotification *)noti {
    BOOL suc = [noti.object boolValue];
    if(suc) {
        [MBProgressHUD showDrawInViewWithoutIndicator:self.view status:@"添加购物车成功" afterDelay:1.0f];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
     * Don't enable scroll navigation
    [self followScrollView:self.webView usingTopConstraint:self.headerConstraint];
    [self setShouldScrollWhenContentFits:NO];
    [self showNavbar];
     */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartRefreshed:) name:kAddToCartNotification object:nil];
    
    //start loading the initial page
    if (self.url && self.webView.request == nil)
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAddToCartNotification object:nil];
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)dealloc
{
    self.webView.delegate = nil;
    self.interface.currentViewController = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    [self initialNavigationLeftItem];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.exclusiveTouch = YES;
    [refreshBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [refreshBtn setImage:[UIImage imageNamed:@"ic_renovate"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(tokenRefreshed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *refreshBarBtn = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    
    self.navigationItem.rightBarButtonItem = refreshBarBtn;
}

- (void)tokenRefreshed
{
    if (self.hasRefreshed) {
        return;
    }
    
    self.hasRefreshed = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [self.webView reload];

    [self performSelector:@selector(updateRefreshButtonStatus)
               withObject:nil
               afterDelay:1];
}

- (void)updateRefreshButtonStatus
{
    self.hasRefreshed = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // This enables the user to scroll down the navbar by tapping the status bar.
    return YES;
}

#pragma mark -
#pragma mark Manual Property Accessors
- (void)setUrl:(NSURL *)url
{
    if (self.url == url)
        return;
    
    _url = [self cleanURL:url];
    
    if (self.webView.loading)
        [self.webView stopLoading];
    
    [self.webView performSelector:@selector(loadRequest:)
                       withObject:[NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1]
                       afterDelay:0.5];
}

- (void)setLoadingBarTintColor:(UIColor *)loadingBarTintColor
{
    if (loadingBarTintColor == self.loadingBarTintColor)
        return;
    
    _loadingBarTintColor = loadingBarTintColor;
    
    self.loadingBarView.backgroundColor = self.loadingBarTintColor;
}

#pragma mark -
#pragma mark WebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL shouldStart = YES;
    NSURL * url = request.URL;
    DLog(@"%@", url.absoluteString);
    
    if([url.scheme isEqualToString:@"hxstore"]) {
        NSDictionary * paramDic = [url uq_queryDictionary];
        
        if([url.host isEqualToString:@"login"]) {
            UINavigationController *nav = [[HXSMediator sharedInstance] HXSMediator_loginNavigationController];
            [self presentViewController:nav animated:YES completion:nil];
        }else if([url.host isEqualToString:@"copy"]) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            
            pasteboard.string = paramDic?[paramDic objectForKey:@"text"]:@"";
            
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"温馨提示"
                                                                              message:@"内容已复制到粘贴板"
                                                                      leftButtonTitle:@"好的"
                                                                    rightButtonTitles:nil];
            [alertView show];
        } else if([url.host isEqualToString:@"share"] && paramDic != nil) {
            NSString * title = [paramDic objectForKey:@"title"];
            NSString * text = [paramDic objectForKey:@"text"];
            NSString * imageString = [paramDic objectForKey:@"image_url"];
            NSString * urlString = [paramDic objectForKey:@"url"];
            int type = [[paramDic objectForKey:@"type"] intValue];
            
            if ((4 == type)
                || (5 == type)) { // QQ空间,好友 直接发送imageUrl
                [self shareTo:type title:title text:text image:nil imageUrl:imageString url:urlString];
                
                return NO;
            }
            
            UIImage * image = nil;
            if(imageString) {
                image = [[UIImageView sharedImageDownloader].imageCache imageforRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageString]] withAdditionalIdentifier:imageString];
                if(!image) {
                    if(!self.imageView) {
                        self.imageView = [[UIImageView alloc] init];
                    }
                    
                    __weak typeof(self) weakSelf = self;
                    
                    [MBProgressHUD showInView:self.view status:@"获取分享资源..."];
                    [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageString]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                        BEGIN_MAIN_THREAD
                        [[UIImageView sharedImageDownloader].imageCache addImage:image
                                                                      forRequest:request
                                                        withAdditionalIdentifier:[request.URL absoluteString]];
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        [weakSelf shareTo:type title:title text:text image:image imageUrl:imageString url:urlString];
                        END_MAIN_THREAD
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                        BEGIN_MAIN_THREAD
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:@"获取资源失败" afterDelay:1.0f];
                        END_MAIN_THREAD
                    }];
                }else {
                    [self shareTo:type title:title text:text image:image imageUrl:imageString url:urlString];
                }
            }else {
                [self shareTo:type title:title text:text image:image imageUrl:imageString url:urlString];
            }
        }else if([url.host isEqualToString:@"finish"]) {
            [self close];
        }
        
        return NO;
    }
    
    //if the URL is the load completed notification from JavaScript
    if ([request.URL.absoluteString isEqualToString:kCompleteRPCURL])
    {
        [self finishLoadProgress];
        return NO;
    }
    
    //If the URL contrains a fragement jump (eg an anchor tag), check to see if it relates to the current page, or another
    //If we're merely jumping around the same page, don't perform a new loading bar sequence
    BOOL isFragmentJump = NO;
    if (request.URL.fragment)
    {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];
    if (shouldStart && !isFragmentJump && isHTTP && isTopLevelNavigation && navigationType != UIWebViewNavigationTypeBackForward)
    {
        //Save the URL in the accessor property
        _url = [request URL];
        DLog(@"_url is %@.", _url);
        [self resetLoadProgress];
    }
    
    return shouldStart;
}

- (void)shareTo:(int)type title:(NSString *)title text:(NSString *)text image:(UIImage *)image imageUrl:(NSString *)imageUrl url:(NSString *)url
{
    if(type == 0) { // 微信好友
        [[HXSWXApiManager sharedManager] shareToWeixinWithTitle:title text:text image:image url:url timeLine:NO callback:nil];
    }else if(type == 1) { // 微信朋友圈
        [[HXSWXApiManager sharedManager] shareToWeixinWithTitle:title text:text image:image url:url timeLine:YES callback:nil];
    }else if(type == 2) { // 微博
        [[HXSSinaWeiboManager sharedManager] shareToWeiboWithText:text image:image callback:nil];
    }else if(type == 3) { // 短信
        UIViewController *viewController = [[HXSMediator sharedInstance] HXSMediator_addressBookViewController:@{@"messageBody":text}];
        
        if ([viewController isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    } else if (4 == type) { // QQ空间
        [[HXSQQSdkManager sharedManager] shareToZoneWithTitle:title
                                                         text:text
                                                        image:imageUrl
                                                          url:url
                                                     callback:nil];
    } else if (5 == type) { // QQ好友
        [[HXSQQSdkManager sharedManager] shareToQQWithTitle:title
                                                       text:text
                                                      image:imageUrl
                                                        url:url
                                                   callback:nil];
    } else {
        // Do nothing
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //increment the number of load requests started
    _loadingProgressState.loadingCount++;
    
    //keep track if this is the highest number of concurrent requests
    _loadingProgressState.maxLoadCount = MAX(_loadingProgressState.maxLoadCount, _loadingProgressState.loadingCount);
    
    //start tracking the load state
    [self startLoadProgress];
    
    //update the navigation bar buttons
    [self refreshButtonsState];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self handleLoadRequestCompletion];
    [self refreshButtonsState];
    
    //see if we can set the proper page title at this point
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSString *jsbridge = [self.webView stringByEvaluatingJavaScriptFromString:@"JSON.stringify(window.WebViewJavascriptBridge)"];
    //老版本html5页面没有引用jssdk，所以通过注入的方式获得HXSJSBridge
    if(jsbridge.length == 0) {
        NSString* jsPath = [self.bundle pathForResource:@"hxsjssdk" ofType:@"js"];
        NSString* jsString = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
        [self.webView stringByEvaluatingJavaScriptFromString:jsString];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self handleLoadRequestCompletion];
    [self refreshButtonsState];
}

#pragma mark -
#pragma mark Button Callbacks
- (IBAction)backButtonTapped:(id)sender
{
    [self.webView goBack];
    [self refreshButtonsState];
}

- (IBAction)forwardButtonTapped:(id)sender
{
    [self.webView goForward];
    [self refreshButtonsState];
}

- (IBAction)reloadStopButtonTapped:(id)sender
{
    if (self.webView.isLoading)
        [self.webView stopLoading];
    else
        [self.webView reload];
    
    [self refreshButtonsState];
}

#pragma mark Override Navigtaion Left Item Methods

- (void)turnBack
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self close];
    }
}

- (void)close
{
    if(self.beingPresentedModally && !self.onTopOfNavigationControllerStack) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:self.modalCompletionHandler];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark Action Item Event Handlers
- (IBAction)actionButtonTapped:(id)sender
{
    NSString *textToShare = self.navigationItem.title;
    
    NSURL *urlToShare = self.url;
    
    NSArray *activityItems = @[textToShare, urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                            
                                                                            applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [activityVC.view setTintColor:HXS_TEXT_COLOR];
        activityVC.popoverPresentationController.sourceView = (UIView *)(sender);
    }
    
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

#pragma mark -
#pragma mark Page Load Progress Tracking Handlers
- (void)resetLoadProgress
{
    memset(&_loadingProgressState, 0, sizeof(_loadingProgressState));
    [self setLoadingProgress:0.0f];
}

- (void)startLoadProgress
{
    //If we haven't started loading yet, set the progress to small, but visible value
    if (_loadingProgressState.loadingProgress < kInitialProgressValue)
    {
        //reset the loading bar
        CGRect frame = self.loadingBarView.frame;
        frame.size.width = CGRectGetWidth(self.view.bounds);
        frame.origin.x = -frame.size.width;
        frame.origin.y = self.webView.scrollView.contentInset.top;
        self.loadingBarView.frame = frame;
        self.loadingBarView.alpha = 1.0f;
        
        //add the loading bar to the view
        if (self.showLoadingBar)
            [self.view insertSubview:self.loadingBarView aboveSubview:self.webView];
        
        //kickstart the loading progress
        [self setLoadingProgress:kInitialProgressValue];
        
        //show that loading started in the status bar
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        if (self.reloadStopButton) {
            [self.reloadStopButton setImage:self.stopIcon forState:UIControlStateNormal];
            [self.reloadStopButton setImage:self.stopSelectedIcon forState:UIControlStateHighlighted];
        }
    }
}

- (void)incrementLoadProgress
{
    float progress          = _loadingProgressState.loadingProgress;
    float maxProgress       = _loadingProgressState.interactive ? kAfterInteractiveMaxProgressValue : kBeforeInteractiveMaxProgressValue;
    float remainingPercent  = (float)_loadingProgressState.loadingCount / (float)_loadingProgressState.maxLoadCount;
    float increment         = (maxProgress - progress) * remainingPercent;
    progress                = fmin((progress+increment), maxProgress);
    
    [self setLoadingProgress:progress];
}

- (void)finishLoadProgress
{
    //hide the activity indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //reset the load progress
    [self refreshButtonsState];
    [self setLoadingProgress:1.0f];
    
    //in case it didn't succeed yet, try setting the page title again
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (self.reloadStopButton) {
        [self.reloadStopButton setImage:self.reloadIcon forState:UIControlStateNormal];
        [self.reloadStopButton setImage:self.reloadSelectedIcon forState:UIControlStateHighlighted];
    }
}

- (void)setLoadingProgress:(CGFloat)loadingProgress
{
    // progress should be incremental only
    if ((loadingProgress > _loadingProgressState.loadingProgress)
        || (loadingProgress == 0))
    {
        _loadingProgressState.loadingProgress = loadingProgress;
        
        //Update the loading bar progress to match
        if (self.showLoadingBar)
        {
            CGRect frame = self.loadingBarView.frame;
            frame.origin.x = -CGRectGetWidth(self.loadingBarView.frame) + (CGRectGetWidth(self.view.bounds) * _loadingProgressState.loadingProgress);
            
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.loadingBarView.frame = frame;
            } completion:^(BOOL finished) {
                //once loading is complete, fade it out
                if (loadingProgress >= 1.0f - FLT_EPSILON)
                {
                    [UIView animateWithDuration:0.2f animations:^{
                        self.loadingBarView.alpha = 0.0f;
                    }];
                }
            }];
        }
    }
}

- (void)handleLoadRequestCompletion
{
    //decrement the number of concurrent requests
    _loadingProgressState.loadingCount--;
    
    //update the progress bar
    [self incrementLoadProgress];
    
    //Query the webview to see what load state JavaScript perceives it at
    NSString *readyState = [self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    //interactive means the page has loaded sufficiently to allow user interaction now
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive)
    {
        _loadingProgressState.interactive = YES;
        
        //if we're at the interactive state, attach a Javascript listener to inform us when the page has fully loaded
        NSString *waitForCompleteJS = [NSString stringWithFormat:   @"window.addEventListener('load',function() { "
                                       @"var iframe = document.createElement('iframe');"
                                       @"iframe.style.display = 'none';"
                                       @"iframe.src = '%@';"
                                       @"document.body.appendChild(iframe);"
                                       @"}, false);", kCompleteRPCURL];
        
        [self.webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
        
        //see if we can set the proper page title yet
        self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        
        self.view.backgroundColor = [UIColor clearColor];
        
        //finally, if the app desires it, disable the ability to tap and hold on links
        if (self.disableContextualPopupMenu)
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    }
    
    BOOL isNotRedirect = self.url && [self.url isEqual:self.webView.request.URL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self finishLoadProgress];
    }
}

#pragma mark -
#pragma mark Button State Handling
- (void)refreshButtonsState
{
    //update the state for the back button
    if (self.webView.canGoBack)
        [self.backButton setEnabled:YES];
    else
        [self.backButton setEnabled:NO];
    
    if (self.webView.canGoForward)
        [self.forwardButton setEnabled:YES];
    else
        [self.forwardButton setEnabled:NO];
}

#pragma mark -
#pragma mark UIWebView Attrbutes
- (UIView *)webViewContentView
{
    //loop through the views inside the webview, and pull out the one that renders the HTML content
    for (UIView *view in self.webView.scrollView.subviews)
    {
        if ([NSStringFromClass([view class]) rangeOfString:@"WebBrowser"].location != NSNotFound)
            return view;
    }
    
    return nil;
}

- (BOOL)webViewPageWidthIsDynamic
{
    //A bit of a crazy JavaScript that scans the HTML for a <meta name="viewport"> tag and retrieves its contents
    NSString *metaDataQuery =   @"(function() {"
    @"var metaTags = document.getElementsByTagName('meta');"
    @"for (i=0; i<metaTags.length; i++) {"
    @"if (metaTags[i].name=='viewport') {"
    @"return metaTags[i].getAttribute('content');"
    @"}"
    @"}"
    @"})()";
    
    NSString *pageViewPortContent = [self.webView stringByEvaluatingJavaScriptFromString:metaDataQuery];
    if ([pageViewPortContent length] == 0)
        return NO;
    
    //remove all white space and make sure it's all lower case
    pageViewPortContent = [[pageViewPortContent stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    
    //check if the max page zoom is locked at 1
    if ([pageViewPortContent rangeOfString:@"maximum-scale=1"].location != NSNotFound)
        return YES;
    
    //check if zooming is intentionally disabled
    if ([pageViewPortContent rangeOfString:@"user-scalable=no"].location != NSNotFound)
        return YES;
    
    //check if width is set to align to the width of the device
    if ([pageViewPortContent rangeOfString:@"width=device-width"].location != NSNotFound)
        return YES;
    
    //check if initial scale is being forced (Apple seem to blanket apply this in Safari)
    if ([pageViewPortContent rangeOfString:@"initial-scale=1"].location != NSNotFound)
        return YES;
    
    return NO;
}

#pragma mark -
#pragma mark State Tracking
- (BOOL)beingPresentedModally
{
    // Check if we have a parentl navigation controller being presented modally
    if (self.navigationController)
        return ([self.navigationController presentingViewController] != nil);
    else // Check if we're directly being presented modally
        return ([self presentingViewController] != nil);
    
    return NO;
}

- (BOOL)onTopOfNavigationControllerStack
{
    if (self.navigationController == nil)
        return NO;
    
    if ([self.navigationController.viewControllers count] && [self.navigationController.viewControllers indexOfObject:self] > 0)
        return YES;
    
    return NO;
}

#pragma mark -
#pragma mark Pay Callback
- (void)wechatPayCallBack:(HXSWechatPayStatus)status message:(NSString *)message result:(NSDictionary *)result {
    [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.0f];
    
    [self tokenRefreshed];
}

- (void)payCallBack:(NSString *)status message:(NSString *)message result:(NSDictionary *)result {
    [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.0f];
    
    [self tokenRefreshed];
}

#pragma mark -
#pragma mark SET UP NAVIGATION RIGHT BUTTON
- (NSString *)setUpNavigationRightButton:(NSDictionary *)button {
    NSString *typeStr;
    NSString *titleStr;
    NSString *linkStr;
    NSString *imageStr;
    SET_NULLTONIL(typeStr, [button objectForKey:@"type"]);
    SET_NULLTONIL(titleStr, [button objectForKey:@"title"]);
    SET_NULLTONIL(linkStr, [button objectForKey:@"link"]);
    SET_NULLTONIL(imageStr, [button objectForKey:@"image"]);
    
    if([typeStr isEqualToString:@"share"]) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.exclusiveTouch = YES;
        [shareBtn setFrame:CGRectMake(0, 0, 40, 40)];
        [shareBtn setImage:[UIImage imageNamed:@"ic_fenxiangBig"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(onClickshareBtn) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
        
        self.navigationItem.rightBarButtonItem = shareBarBtn;
    }else if(linkStr.length > 0) {
        self.rightNaviLink = linkStr;
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.exclusiveTouch = YES;
        [shareBtn setFrame:CGRectMake(0, 0, 40, 40)];
        if(imageStr.length > 0) {
            [shareBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:imageStr]];
        }else {
            [shareBtn setTitle:titleStr forState:UIControlStateNormal];
        }
        
        [shareBtn addTarget:self action:@selector(onClickRightBtn) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
        
        self.navigationItem.rightBarButtonItem = shareBarBtn;
    }else {
        UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        refreshBtn.exclusiveTouch = YES;
        [refreshBtn setFrame:CGRectMake(0, 0, 40, 40)];
        [refreshBtn setImage:[UIImage imageNamed:@"ic_renovate"] forState:UIControlStateNormal];
        [refreshBtn addTarget:self action:@selector(tokenRefreshed) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *refreshBarBtn = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
        
        self.navigationItem.rightBarButtonItem = refreshBarBtn;
    }
    
    return @"YES";
}

- (void)onClickshareBtn {
    [self.interface.bridge callHandler:@"getShareInfo" data:nil responseCallback:^(id responseData) {
        NSLog(@"%@", responseData);
        if (self.shareView) {
            
            [self.shareView close];
            self.shareView = nil;
        }
        
        if(![responseData isKindOfClass:[NSDictionary class]]) {
            responseData = [NSDictionary dictionary];
        }
        
        NSArray *types = [responseData objectForKey:@"type"];
        HXSShareParameter *parameter = [[HXSShareParameter alloc] init];
        
        parameter.shareTypeArr = @[@(kHXSShareTypeWechatMoments),
                                   @(kHXSShareTypeWechatFriends),
                                   @(kHXSShareTypeQQFriends),
                                   @(kHXSShareTypeQQMoments),
                                   @(kHXSShareTypeCopyLink)];
        if([types isKindOfClass:[NSArray class]] && types.count > 0) {
            parameter.shareTypeArr = types;
        }
        
        parameter.titleStr = [responseData objectForKey:@"title"]?:self.title;
        parameter.textStr = [responseData objectForKey:@"content"];
        parameter.imageURLStr = [responseData objectForKey:@"image"];
        parameter.shareURLStr = (0 < [[responseData objectForKey:@"link"] length]) ? [responseData objectForKey:@"link"] : self.webView.request.URL.absoluteString;
        
        self.shareView = [[HXSShareView alloc] initShareViewWithParameter:parameter callBack:nil];
        [self.shareView show];
    }];
}

- (void)onClickRightBtn {
    [self.interface openRouter:self.rightNaviLink];
}

@end

//
//  AppDelegate.m
//  store
//
//  Created by chsasaw on 14-10-11.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "AppDelegate.h"

#import "HXSGexinSdkManager.h"
#import "HXSSinaWeiboManager.h"
#import "HXSQQSdkManager.h"
#import "HXSRenrenManager.h"
#import "HXSWXApiManager.h"
#import "HXSUpdateTokenRequest.h"
#import "HXSDeviceUpdateRequest.h"
#import "HXSWebViewController.h"
#import "HXSDormCartManager.h"
#import "HXSAlipayManager.h"
#import "HXSLaunchViewController.h"
#import "HXSGPSLocationManager.h"
#import "HXSElemeRestaurant.h"
#import "HXSMessageCenterViewController.h"
#import "AFNetworking.h"
#import "HXSDigitalMobileConfirmOrderViewController.h"
#import "HXSMediator.h"
#import "HXSBestPayApiManager.h"
#import "UDManager.h"

#import "HXSRobTaskViewController.h"
#import "HXSTaskDetialViewController.h"
#import "HXSTaskQRCodeViewController.h"
#import "HXSTaskHandledViewController.h"
#import "HXSWaitingToHandleViewController.h"
#import "HXSWaitingToRobViewController.h"
#import "HXSMyFilesPrintViewController.h"
#import "UIWindow+Extension.h"
#import "HXStoreWebService.h"
#import <JSPatch/JSPatch.h>


#define kChanelKey          @"A1000"//渠道key
#define kMobclickKey        @"5444c89afd98c5d6dc003391"//友盟统计key
#define kJSPatchKey         @"a9622b8763562d8c"             // JSPatch appKey

@interface AppDelegate ()

@property (nonatomic, assign) BOOL   ifAlerting;
@property (nonatomic, strong) NSURL  *urlFromOtherApp;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupJSPath];
    
    [self setupCache];
    
    [self setupInitialStatusOfBusiness];
    
    [self setupRemoteNotificationWithOptions:launchOptions];
    
    [self setupUserAgent];
    
    [self setupFMDeviceManager];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.viewController = [[HXSLaunchViewController alloc] initWithNibName:@"HXSLaunchViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[HXSGexinSdkManager sharedInstance] stopSdk];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[HXSGexinSdkManager sharedInstance] startSdk];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBoxOrderHasPayed object:nil];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog(@"deviceToken:%@", token);
    
    // [3]:向个推服务器注册deviceToken
    [[HXSGexinSdkManager sharedInstance] setDeviceToken:token data:deviceToken];
    [[HXSGexinSdkManager sharedInstance] setAlias:[HXAppDeviceHelper uniqueDeviceIdentifier]];
    [[HXSDeviceUpdateRequest currentRequest] setDeviceToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    [[HXSGexinSdkManager sharedInstance] setDeviceToken:@"" data:nil];
    
    DLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    DLog(@"userinfo is %@", userinfo);
    
    // others
    if (nil != userinfo) {
        NSData *userInfoData = [NSJSONSerialization dataWithJSONObject:userinfo
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
        NSString *userInfoStr = [[NSString alloc] initWithData:userInfoData encoding:NSUTF8StringEncoding];
        [[NSUserDefaults standardUserDefaults] setObject:userInfoStr
                                                  forKey:@"payload"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self showApnsPayload];
    }
    
    // message
    NSString *payload = nil;
    
    if(DIC_HAS_STRING(userinfo, @"payload")) {
        SET_NULLTONIL(payload, [userinfo objectForKey:@"payload"]);
    }
    
    if([payload rangeOfString:@"url"].length == 0) {
        // update unread message
        [HXSMessageModel fetchUnreadMessage];
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if([url.scheme isEqualToString:@"file"] && !_urlFromOtherApp)
    {
        [self copyTheDocumentFromOtherAppAndJumpToICloudWithFileURL:url];
    }
    
    [[HXSMediator sharedInstance] performActionWithUrl:url completion:^(NSDictionary *info) {
        id result = [info objectForKey:@"result"];
        if([result isKindOfClass:[UIViewController class]]) {
            HXSBaseNavigationController * nav = [[HXSBaseNavigationController alloc] initWithRootViewController:result];
            [self.rootViewController presentViewController:nav animated:YES completion:nil];
        }else if([result isKindOfClass:[UINavigationController class]]) {
                [self.rootViewController presentViewController:result animated:YES completion:nil];
        }
    }];

    return [[HXSSinaWeiboManager sharedManager] handleOpenURL:url]
    || [[HXSRenrenManager sharedManager] handleOpenURL:url]
    || [[HXSWXApiManager sharedManager] handleOpenURL:url]
    || [[HXSQQSdkManager sharedManager] handleOpenURL:url]
    || [[HXSAlipayManager sharedManager] handleOpenURL:url]
    || [[HXSBestPayApiManager sharedManager] handleOpenURL:url];
}

#pragma mark - Public Methods

+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (RootViewController *) rootViewController
{
    UIViewController * controller;
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0") && ([UIApplication sharedApplication].windows.count > 0)) {
        controller = [UIApplication sharedApplication].windows[0].rootViewController;
    }
    else {
        controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    if([controller isKindOfClass:[RootViewController class]]) {
        return (RootViewController *)controller;
    }else if([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)controller;
        for(UIViewController * root in nav.viewControllers) {
            if([root isKindOfClass:[RootViewController class]]) {
                return (RootViewController *)root;
            }
        }
    }
    
    return nil;
}


#pragma mark - Set up Methods

- (void)setupJSPath
{
    // JSPatch 初始化
    [JSPatch startWithAppKey:kJSPatchKey];
    
    [JSPatch sync];
}

- (void)setupCache
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:200 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [HXSDirectoryManager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[HXSDirectoryManager getDocumentsDirectory]]];
    [HXSDirectoryManager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[HXSDirectoryManager getLibraryDirectory]]];
}

- (void)setupInitialStatusOfBusiness
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    // Override point for customization after application launch.
#if !DEBUG
    [MobClick startWithAppkey:kMobclickKey reportPolicy:REALTIME channelId:kChanelKey];
#endif
    ///
    [[HXSGexinSdkManager sharedInstance] startSdk];
    
    [self initCustomUniversal];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self initCustomControlPhone];
    }
    
    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_LAUNCH parameter:nil];
    
    [[HXSGPSLocationManager instance] startPositioning];
    
    // update unread message
    [HXSMessageCenterViewController sharedManager]; // initial for listening the notification
    [HXSMessageModel fetchUnreadMessage];
    
    // 初始化Udesk   e4ffb1aa618267ac1690c5d59c42f79b
    [UDManager initWithAppkey:@"e4ffb1aa618267ac1690c5d59c42f79b" domianName:@"59store.udesk.cn"];
    
    // delete eleme cart
    [HXSElemeRestaurant MR_truncateAll];
}

- (void)setupRemoteNotificationWithOptions:(NSDictionary *)launchOptions
{
    // remote notification
    // [2-EXT]: 获取启动时收到的APN
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (nil != message) {
        DLog(@"launchOptions message is %@.", message);
        NSData *userInfoData = [NSJSONSerialization dataWithJSONObject:message
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
        NSString *userInfoStr = [[NSString alloc] initWithData:userInfoData encoding:NSUTF8StringEncoding];
        [[NSUserDefaults standardUserDefaults] setObject:userInfoStr forKey:@"payload"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSelector:@selector(showApnsPayload) withObject:nil afterDelay:3.0f];
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    self.urlFromOtherApp = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self.urlFromOtherApp)
        {
            [self copyTheDocumentFromOtherAppAndJumpToICloudWithFileURL:self.urlFromOtherApp];
            self.urlFromOtherApp = nil;
        }
    });
}

- (void)setupUserAgent
{
    //设置webview的user-agent
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"]) {
        
        NSString *userAgent = [NSString stringWithFormat:@"%@/%@; iOS %@; %.0fX%.0f/%0.1f", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleNameKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] systemVersion], SCREEN_WIDTH*[[UIScreen mainScreen] scale],SCREEN_HEIGHT*[[UIScreen mainScreen] scale], [[UIScreen mainScreen] scale]];
        if (userAgent) {
            if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                NSMutableString *mutableUserAgent = [userAgent mutableCopy];
                if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                    userAgent = mutableUserAgent;
                }
            }
        }
        
        NSString *userAgentStr = [NSString stringWithFormat:@"%@; %@; %@", [HXAppDeviceHelper modelString], userAgent,[NSString stringWithFormat:@"IsJailbroken/%d",[HXAppDeviceHelper isJailbroken]]];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":userAgentStr}];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setupFMDeviceManager
{
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc] initWithCapacity:5];
#if DEBUG
    [options setValue:@"allowd" forKey:@"allowd"];
    
    [options setValue:@"sandbox" forKey:@"env"];
#endif
    
    [options setValue:@"59store" forKey:@"partner"];
    
    manager->initWithOptions(options);
}


#pragma mark - Initial Methods

- (void)initCustomUniversal
{    
    // UINavigationBar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:HXS_MAIN_COLOR] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setBarTintColor:HXS_MAIN_COLOR];
    
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeZero;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                         NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
                                                         NSShadowAttributeName:shadow};
    [UINavigationBar appearance].shadowImage = [[UIImage alloc] init];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
}

- (void)initCustomControlPhone
{
    // UITabBar
    [UITabBar appearance].backgroundColor = [UIColor whiteColor];
    [UITabBar appearance].backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    [UITabBar appearance].shadowImage = [UIImage imageWithColor:HXS_BORDER_COLOR];
    [UITabBar appearance].selectionIndicatorImage = [UIImage imageWithColor:[UIColor clearColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleDefault];
    
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: HXS_MAIN_COLOR,
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                                        NSShadowAttributeName:shadow}
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL,
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                                        NSShadowAttributeName:shadow}
                                             forState:UIControlStateNormal];
}

- (void)showApnsPayload
{
    NSString *payload = [[NSUserDefaults standardUserDefaults] objectForKey:@"payload"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"payload"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (0 < [payload length]) {
        NSDictionary *userinfo = [NSJSONSerialization JSONObjectWithData:[payload dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        DLog(@"showApnsPayload userinfo is %@.", userinfo);
        
        if(![userinfo isKindOfClass:[NSDictionary class]]) {
            userinfo = [NSDictionary dictionary];
        }
        
        NSDictionary *apnsDic = [userinfo objectForKey:@"aps"];
        NSDictionary *alertDic = [apnsDic objectForKey:@"alert"];
        NSString *bodyStr = [alertDic objectForKey:@"body"];
        NSDictionary *bodyDic = [NSJSONSerialization JSONObjectWithData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];;
        
        NSNumber *codeNum = nil;
        if(DIC_HAS_NUMBER(bodyDic, @"code")){
            codeNum = [bodyDic objectForKey:@"code"];
        }
        
        if(nil != codeNum){
            // 社区评论推送
            if ([codeNum intValue] == HXSNoticePushTypeCommuniyCommend) {
                RootViewController *rootVC = [AppDelegate sharedDelegate].rootViewController;
                [rootVC setSelectedIndex:kHXSTabBarCommunity];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getNoticeMsg" object:bodyDic];
            }
            else if([codeNum intValue] == kHXNoticePushKnightHaveTask){// 骑士：有新任务可抢
                
                [self noticePushKnightHaveTaskWithInfo:bodyDic];
                
            }else if ([codeNum intValue] == kHXNoticePushKnightOrderCancle){// 骑士：订单被用户取消
                
                [self noticePushKnightOrderStatusUpadateWithInfo:bodyDic];
                
            }else if([codeNum intValue] == kHXNoticePushKnightOrderSendingCancle){ // 骑士：配送中的订单被用户取消
                
                [self noticePushKnightOrderStatusUpadateWithInfo:bodyDic];
            }
        }
                             

    }
}

- (void)showPayload:(NSString *)payload
{
    NSDictionary *userinfo = [NSJSONSerialization JSONObjectWithData:[payload dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if(![userinfo isKindOfClass:[NSDictionary class]]) {
        userinfo = [NSDictionary dictionary];
    }
    
    NSNumber *codeNum = nil;
    if(DIC_HAS_NUMBER(userinfo, @"code")){
        codeNum = [userinfo objectForKey:@"code"];
    }
    
    if(nil != codeNum){
        
        if ([codeNum intValue] == HXSNoticePushTypeCommuniyCommend) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getNoticeMsg" object:payload];
            
        }else if([codeNum intValue] == kHXNoticePushKnightHaveTask){
            
            [self noticePushKnightHaveTaskWithInfo:userinfo];
            
        }else if([codeNum intValue] == kHXNoticePushKnightOrderCancle){
            
            [self noticePushKnightOrderStatusUpadateWithInfo:userinfo];
            
        }else if([codeNum intValue] == kHXNoticePushKnightOrderSendingCancle){
            
            [self noticePushKnightOrderStatusUpadateWithInfo:userinfo];
            
        }else{
            NSString *msg = nil;
            if( DIC_HAS_STRING(userinfo, @"msg")) {
                SET_NULLTONIL(msg, [userinfo objectForKey:@"msg"]);
            }
            NSString *url = nil;
            if(DIC_HAS_STRING(userinfo, @"url")) {
                SET_NULLTONIL(url, [userinfo objectForKey:@"url"]);
            }
            //封装的alertView
            if(msg && msg.length > 0 && url && url.length > 0) {
                //封装的alertView
                HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"推送消息"
                                                                                  message:msg
                                                                          leftButtonTitle:@"取消"
                                                                        rightButtonTitles:@"查看"];
                alertView.rightBtnBlock = ^{
                    [[AppDelegate sharedDelegate] showURL:url];
                };
                [alertView show];
            }
            
            
        }
    
    }
}

- (void)showURL:(NSString *)url
{
    DLog(@"url  %@", url);
    
    if(url && [url isKindOfClass:[NSString class]] && url.length > 0) {
        HXSWebViewController * controller = [HXSWebViewController controllerFromXib];
        [controller setUrl:[NSURL URLWithString:url]];
        
        HXSBaseNavigationController * nav = [[HXSBaseNavigationController alloc] initWithRootViewController:controller];
        [self.rootViewController presentViewController:nav animated:YES completion:nil];
    }
}


#pragma mark - PushNoticeMethods
// 骑士有新任务可抢
- (void)noticePushKnightHaveTaskWithInfo:(NSDictionary *)userInfo{
    
    UIViewController *viewController = [self visibleViewController];
    
    // 处在抢任务挣钱，订单详情，订单二维码界面时不弹窗提示
    BOOL notShowAlert = [viewController isKindOfClass:[HXSRobTaskViewController class]]
    || [viewController isKindOfClass:[HXSTaskDetialViewController class]]
    || [viewController isKindOfClass:[HXSTaskQRCodeViewController class]]
    || [viewController isKindOfClass:[HXSTaskHandledViewController class]]
    || [viewController isKindOfClass:[HXSWaitingToHandleViewController class]]
    || [viewController isKindOfClass:[HXSWaitingToRobViewController class]]
    ||[viewController isKindOfClass:[HXSCustomAlertView class]];
    
    if(notShowAlert){
        [[NSNotificationCenter defaultCenter] postNotificationName:KnightHaveNewTask object:userInfo];
    }else{
        NSString *msg = nil;
        if( DIC_HAS_STRING(userInfo, @"msg")) {
            SET_NULLTONIL(msg, [userInfo objectForKey:@"msg"]);
        }
        
        if(!_ifAlerting){
            
            HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"推送消息" message:msg leftButtonTitle:@"取消" rightButtonTitles:@"查看"];
            _ifAlerting = YES;
            alert.rightBtnBlock = ^{
                
                HXSRobTaskViewController * controller = [[HXSRobTaskViewController alloc] initWithNibName:nil bundle:nil];
                HXSBaseNavigationController * nav = [[HXSBaseNavigationController alloc] initWithRootViewController:controller];
                [self.rootViewController presentViewController:nav animated:YES completion:nil];
                _ifAlerting = NO;
                
            };
            alert.leftBtnBlock = ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:KnightHaveNewTask object:userInfo];
                _ifAlerting = NO;
            };
            [alert show];
        }
    }
}

// 骑士订单状态改变
- (void)noticePushKnightOrderStatusUpadateWithInfo:(NSDictionary *)userInfo{
    
    UIViewController *viewController = [self visibleViewController];
    BOOL notShowAlert = [viewController isKindOfClass:[HXSRobTaskViewController class]]
    || [viewController isKindOfClass:[HXSTaskDetialViewController class]]
    || [viewController isKindOfClass:[HXSTaskQRCodeViewController class]]
    || [viewController isKindOfClass:[HXSTaskHandledViewController class]]
    || [viewController isKindOfClass:[HXSWaitingToHandleViewController class]]
    || [viewController isKindOfClass:[HXSWaitingToRobViewController class]]
    ||[viewController isKindOfClass:[HXSCustomAlertView class]];;
    
    if(notShowAlert){
        [[NSNotificationCenter defaultCenter] postNotificationName:KnightOrderStatusUpdate object:userInfo];
    }else{
        
        NSString *msg = nil;
        if( DIC_HAS_STRING(userInfo, @"msg")) {
            SET_NULLTONIL(msg, [userInfo objectForKey:@"msg"]);
        }
        
        if(!_ifAlerting){
            
            HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"推送消息" message:msg leftButtonTitle:@"取消" rightButtonTitles:@"查看"];
            _ifAlerting = YES;
            alert.rightBtnBlock = ^{
                
                _ifAlerting = NO;
                
                NSDictionary *dic = [userInfo objectForKey:@"data"];
                NSString *deliveryOrderIdStr = [dic objectForKey:@"delivery_order_id"];
                if(deliveryOrderIdStr && [deliveryOrderIdStr isKindOfClass:[NSString class]]){
                    
                    HXSTaskDetialViewController *taskDetialViewController = [[HXSTaskDetialViewController alloc]initWithNibName:nil bundle:nil];
                    
                    HXSTaskOrder *taskOrder = [[HXSTaskOrder alloc]init];
                    taskOrder.deliveryOrderIdStr = deliveryOrderIdStr;
                    [taskDetialViewController setTaskOrderEntity:taskOrder];
                    HXSBaseNavigationController * nav = [[HXSBaseNavigationController alloc] initWithRootViewController:taskDetialViewController];
                    [self.rootViewController presentViewController:nav animated:YES completion:nil];
                }
                
            };
            [alert show];
        }
    }
}



/**
 *  获取从其他程序打开的文件地址并拷贝到本地
 *
 *  @param url
 */
- (void)copyTheDocumentFromOtherAppAndJumpToICloudWithFileURL:(NSURL *)url
{
    
    UIViewController *currentVC = [self.window topVisibleViewController];
    
    if([currentVC isKindOfClass:[HXSMyFilesPrintViewController class]])
    {
        HXSMyFilesPrintViewController *printVC = (HXSMyFilesPrintViewController *)currentVC;
        
        [printVC refreshThePrintVCWithURL:url];
    }
    else
    {
        HXSMyFilesPrintViewController *printVC = [HXSMyFilesPrintViewController createFilesPrintVCWithURL:url];
        HXSBaseNavigationController *navi = [[HXSBaseNavigationController alloc]initWithRootViewController:printVC];
        [self.rootViewController  presentViewController:navi animated:YES completion:nil];
    }
}


/*
 //获取当前屏幕显示的viewcontroller
 */

- (UIViewController *)visibleViewController {
    UIViewController *rootViewController = self.window.rootViewController;;
    return [self getVisibleViewControllerFrom:rootViewController];
}

- (UIViewController *)getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}


@end

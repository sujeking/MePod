//
//  HXSLaunchViewController.m
//  store
//
//  Created by chsasaw on 15/5/11.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSLaunchViewController.h"

#import "HXSGuideViewController.h"
#import "HXSLaunchAdRequest.h"
#import "SDWebImageDownloader.h"
#import "HXSGPSLocationManager.h"
#import "HXSWebViewController.h"
#import "UIImage+GIF.h"

#define kHXDLaunchAd @"kHXDLaunchAd"

@interface HXSLaunchAd : NSObject

@property (nonatomic, copy) NSString * image_url;
@property (nonatomic, copy) NSString * background_color;
@property (nonatomic, assign) int display_times;
@property (nonatomic, assign) int displayed_times;
@property (nonatomic, assign) long start_time;
@property (nonatomic, assign) long end_time;
@property (nonatomic, copy) NSString * link;

@end

@implementation HXSLaunchAd

- (id)initWithDictionary:(NSDictionary *)dic {
    if(self = [super init]) {
        if(!dic || ![dic objectForKey:@"image_url"]) {
            return nil;
        }
        
        if(DIC_HAS_NUMBER(dic, @"start_time")) {
            self.start_time = [[dic objectForKey:@"start_time"] longValue];
        }else {
            self.start_time = 0;
        }
        
        if(DIC_HAS_NUMBER(dic, @"end_time")) {
            self.end_time = [[dic objectForKey:@"end_time"] longValue];
        }else {
            self.end_time = 0;
        }
        
        if(DIC_HAS_NUMBER(dic, @"display_times") || DIC_HAS_STRING(dic, @"display_times")) {
            self.display_times = [[dic objectForKey:@"display_times"] intValue];
        }else {
            self.display_times = 0;
        }
        
        if(DIC_HAS_NUMBER(dic, @"displayed_times")) {
            self.displayed_times = [[dic objectForKey:@"displayed_times"] intValue];
        }else {
            self.displayed_times = 0;
        }
        
        if(DIC_HAS_STRING(dic, @"image_url")) {
            self.image_url = [dic objectForKey:@"image_url"];
        }
        
        if(DIC_HAS_STRING(dic, @"background_color")) {
            self.background_color = [dic objectForKey:@"background_color"];
        }else {
            self.background_color = @"#ffffff";
        }
        
        if(DIC_HAS_STRING(dic, @"link")){
            self.link = [dic objectForKey:@"link"];
        }
    }
    
    return self;
}

- (NSDictionary *)encodeAsDic {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if(self.image_url) {
        [dic setObject:self.image_url forKey:@"image_url"];
    }
    
    if(self.link){
        [dic setObject:self.link forKey:@"link"];
    }
    
    if(self.background_color) {
        [dic setObject:self.background_color forKey:@"background_color"];
    }
    
    [dic setObject:[NSNumber numberWithInt:self.displayed_times] forKey:@"displayed_times"];
    
    [dic setObject:[NSNumber numberWithInt:self.display_times] forKey:@"display_times"];
    
    [dic setObject:[NSNumber numberWithLong:self.start_time] forKey:@"start_time"];
    
    [dic setObject:[NSNumber numberWithLong:self.end_time] forKey:@"end_time"];
    
    return dic;
}

@end

@interface HXSLaunchViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *imageContainerView;
@property (nonatomic, weak) IBOutlet UIButton *skipButton;

@property (nonatomic, assign) BOOL gotoLaunchAdLink;

@property (nonatomic, strong) HXSLaunchAdRequest * request;
@property (nonatomic, assign, getter=isShowAdImageView) BOOL showAdImageView;

@end

#define DISPLAY_AD_TIME  2

@implementation HXSLaunchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.showAdImageView = NO;
    
    if(![HXSUserAccount currentAccount].strToken) {
        [[HXSUserAccount currentAccount] updateToken];
    }
    
    [self initialPrama];
    
    [[HXSGPSLocationManager instance] updateSiteInfo];
    
    [self getLaunchAd];
    
    [self showLaunchAd];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLaunchAd) name:@"launchad_cache_finished" object:nil];
    
    //最长在这个页面停留5秒，跳到下一个页面
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf showGuide];
    });
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)initialPrama
{
    self.skipButton.layer.cornerRadius = 3;
    self.skipButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.skipButton.layer.borderWidth = 1;
    [self.skipButton setBackgroundColor:[UIColor colorWithR:0 G:0 B:0 A:0.4]];
    [self.skipButton addTarget:self action:@selector(skipButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.skipButton setHidden:YES];
    
    // 点击图片跳转
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClicked)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    
}

//如果lanunchAd存在且符合条件，展示launchAD，否则展示默认的image
- (void)showLaunchAd
{
    NSDictionary *launchAdDic = [[NSUserDefaults standardUserDefaults] objectForKey:kHXDLaunchAd];
    HXSLaunchAd * launchAd = [[HXSLaunchAd alloc] initWithDictionary:launchAdDic];
    if (!launchAd) { //launchAd不存在
        self.imageView.userInteractionEnabled = NO;
        [self.skipButton setHidden:YES];
        
        return;
    }
    
    if (launchAd.displayed_times >= launchAd.display_times) { //已经达到或超过预订的显示次数,删除图片
        NSString *imagePathDir = [HXSDirectoryManager getCachesDirectory];
        imagePathDir = [imagePathDir stringByAppendingPathComponent:@"LaunchAd"];
        [[NSFileManager defaultManager] removeItemAtPath:imagePathDir error:nil];
        
        self.imageView.userInteractionEnabled = NO;
        [self.skipButton setHidden:YES];
        
        return;
    }
    
    if (launchAd.start_time > [[NSDate date] timeIntervalSince1970] || launchAd.end_time < [[NSDate date] timeIntervalSince1970]) { //当前时间不在预订的显示时间段内
        self.imageView.userInteractionEnabled = NO;
        [self.skipButton setHidden:YES];
        
        return;
    }
    
    NSString *imagePath = [HXSDirectoryManager getAdImagePath:launchAd.image_url];
    NSData *imageData   = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image      = [UIImage sd_animatedGIFWithData:imageData];
    
    if(image) {
        //图片下载完了才显示
        self.view.backgroundColor = [UIColor colorWithHexString:launchAd.background_color];
        self.imageView.image = image;
        launchAd.displayed_times += 1;
        [[NSUserDefaults standardUserDefaults] setObject:[launchAd encodeAsDic] forKey:kHXDLaunchAd];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.showAdImageView = YES;
        self.imageView.userInteractionEnabled = YES;
        [self.skipButton setHidden:NO];
    }else {
        [self cacheLaunchAdImage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showGuide
{
    if (nil != self.presentedViewController) {
        return;
    }
    
    NSString *appVersionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *firstLaunchKeyStr = [NSString stringWithFormat:@"first_launch_%@", appVersionStr];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:firstLaunchKeyStr]
       && !IPAD)
    {
        self.gotoLaunchAdLink = NO;
        
        __weak typeof(self) weakSelf = self;
        
        HXSGuideViewController * guideViewController = [[HXSGuideViewController alloc] initWithNibName:@"HXSGuideViewController" bundle:nil];
        
        guideViewController.block = ^{
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:firstLaunchKeyStr];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [weakSelf showRootViewController];
        };
        [self presentViewController:guideViewController animated:NO completion:nil];
    }else {
        [self showRootViewController];
    }
}

- (void)showRootViewController
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RootViewController * rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
    
    if(self.gotoLaunchAdLink){
        UINavigationController *nav = [rootViewController.viewControllers objectAtIndex:0];
        
        NSDictionary *launchAdDic = [[NSUserDefaults standardUserDefaults] objectForKey:kHXDLaunchAd];
        HXSLaunchAd * currentAd = [[HXSLaunchAd alloc] initWithDictionary:launchAdDic];
        
        HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
        webVc.url = [NSURL URLWithString:[currentAd.link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [nav pushViewController:webVc animated:NO];
    }
    
    [AppDelegate sharedDelegate].window.rootViewController = rootViewController;
    [AppDelegate sharedDelegate].viewController = rootViewController; // make sure release this class instance
}

- (void)getLaunchAd
{
    __weak typeof(self) weakSelf = self;
    
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    [self.request requestWithCityID:locationMgr.currentCity.city_id
                             siteID:siteIdIntNum
                      completeBlock:^(HXSErrorCode errorcode, NSString *msg, NSDictionary *data) {
                          if(errorcode == kHXSNoError) {
                              NSDictionary *launchAdDic = [[NSUserDefaults standardUserDefaults] objectForKey:kHXDLaunchAd];
                              HXSLaunchAd * currentAd = [[HXSLaunchAd alloc] initWithDictionary:launchAdDic];
                              HXSLaunchAd * newAd = [[HXSLaunchAd alloc] initWithDictionary:data];
                              if ((!currentAd || ![currentAd.image_url isEqualToString:newAd.image_url]) && newAd) {
                                  newAd.displayed_times = 0;
                                  [[NSUserDefaults standardUserDefaults] setObject:[newAd encodeAsDic] forKey:kHXDLaunchAd];
                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                  [weakSelf cacheLaunchAdImage];
                              }
                          }else { //下载失败
                              DLog(@"获取launchAd失败");
                          }
                          [weakSelf showNext];
                      }];
}

- (void)showNext
{
    NSDictionary *launchAdDic = [[NSUserDefaults standardUserDefaults] objectForKey:kHXDLaunchAd];
    HXSLaunchAd *launchAd = [[HXSLaunchAd alloc] initWithDictionary:launchAdDic];
    
    if(self.isShowAdImageView) {
        NSString *imagePath = [HXSDirectoryManager getAdImagePath:launchAd.image_url];
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        UIImage *image = [UIImage sd_animatedGIFWithData:imageData];
        
        WS(weakSelf);
        if(image && image.duration > 0){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(image.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf showGuide];
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DISPLAY_AD_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf showGuide];
            });
        }
    } else {
        if (nil == launchAd) {
            [self showGuide];
        } else {
            WS(weakSelf);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DISPLAY_AD_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf showGuide];
            });
        }
        
    }
}

//将launchAd里面图片缓存到本地
- (void)cacheLaunchAdImage {
    NSDictionary *launchAdDic = [[NSUserDefaults standardUserDefaults] objectForKey:kHXDLaunchAd];
    HXSLaunchAd * currentAd = [[HXSLaunchAd alloc] initWithDictionary:launchAdDic];
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:currentAd.image_url] options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        BEGIN_MAIN_THREAD
        if(data) {
            [data writeToFile:[HXSDirectoryManager getAdImagePath:currentAd.image_url] atomically:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"launchad_cache_finished" object:nil];
        }
        END_MAIN_THREAD
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"launchad_cache_finished"
                                                  object:nil];
}

#pragma mark - Setter Getter Methods

- (HXSLaunchAdRequest *)request
{
    if (nil == _request) {
        _request = [[HXSLaunchAdRequest alloc] init];
    }
    
    return _request;
}


#pragma mark - Target/Action

- (void)skipButtonClicked
{
    [self showGuide];
}

- (void)imageViewClicked
{
    NSDictionary *launchAdDic = [[NSUserDefaults standardUserDefaults] objectForKey:kHXDLaunchAd];
    HXSLaunchAd * currentAd = [[HXSLaunchAd alloc] initWithDictionary:launchAdDic];
    if(currentAd.link
       && (0 < [currentAd.link length])){
        
        self.gotoLaunchAdLink = YES;
        
       [self showGuide];
    }
}

@end
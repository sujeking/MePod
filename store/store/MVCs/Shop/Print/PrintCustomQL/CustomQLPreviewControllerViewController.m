//
//  CustomQLPreviewControllerViewController.m
//  DocInteraction
//
//  Created by J006 on 16/3/21.
//
//

#import "CustomQLPreviewControllerViewController.h"
#import "HXSShareView.h"

@interface CustomQLPreviewControllerViewController ()

/**左上角后退按钮*/
@property (nonatomic, strong) UIBarButtonItem               *backBarButton;
/**右上角分享按钮*/
@property (nonatomic, strong) UIBarButtonItem               *shareBarButton;
/**底部按钮*/
@property (nonatomic, strong) UIButton                      *bottomButton;
/**分享界面*/
@property (nonatomic, strong) HXSShareView                  *shareView;

@end

@implementation CustomQLPreviewControllerViewController


#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Don't invoke super method because memory leak
    [[self navigationItem] setHidesBackButton:YES];
    [[self navigationItem] setRightBarButtonItem:nil animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    // Don't invoke super method because memory leak
    [self initNavigation];
}


#pragma mark - init

- (void)initCustomQLPreviewWithEntity:(HXSPrintDownloadsObjectEntity*)entity
{
    _currentEntity = entity;
}

- (void)initNavigation
{
    [self.navigationItem setLeftBarButtonItem:self.backBarButton];
    [self.navigationItem setRightBarButtonItem:self.shareBarButton];
}


#pragma mark - Navigtaion Left Item Methods

- (void)turnBack
{
    if(self.navigationController.viewControllers.count == 1)
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - BarButton Action method

- (void)shareTheDocument
{
    __weak typeof(self) weakSelf = self;
    HXSShareParameter *parameter = [[HXSShareParameter alloc] init];
    parameter.shareTypeArr = @[@(kHXSShareTypeQQMoments), @(kHXSShareTypeWechatFriends),
                               @(kHXSShareTypeQQFriends), @(kHXSShareTypeWechatMoments)];
    _shareView = [[HXSShareView alloc]initShareViewWithParameter:parameter callBack:^(HXSShareResult shareResult, NSString *msg) {
        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:msg afterDelay:1.5];
    }];
    
    _shareView.shareParameter.titleStr = @"59云印";
    _shareView.shareParameter.textStr = @"我在59云印店发现了一个很实用的文档，快来看吧";
    _shareView.shareParameter.imageURLStr = nil;
    _shareView.shareParameter.shareURLStr = @"http://yemao.59store.com/share?hxfrom=59print";
    [_shareView show];
}

- (void)printAction:(UIButton*)button
{
    DLog(@"print");
}


#pragma mark - getter setter

- (UIButton *)bottomButton
{
    if(!_bottomButton) {
        CGFloat main_width = [UIScreen mainScreen].bounds.size.width;
        CGFloat main_height = [UIScreen mainScreen].bounds.size.height;
        _bottomButton = [[UIButton alloc]initWithFrame:CGRectMake(0, main_height-44, main_width, 44)];
        [_bottomButton setBackgroundColor:[UIColor blueColor]];
        [_bottomButton setTitle:@"打印" forState:UIControlStateNormal];
        [_bottomButton.titleLabel setTextColor:[UIColor whiteColor]];
        [_bottomButton addTarget:self action:@selector(printAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

- (UIImageView *)fileIconImageView
{
    if(!_fileIconImageView) {
        _fileIconImageView = [[UIImageView alloc]init];
    }
    return _fileIconImageView;
}

- (UIBarButtonItem *)shareBarButton
{
    if(!_shareBarButton) {
        UIImage *shareImage = [UIImage imageNamed:@"ic_shape"];
        _shareBarButton =[[UIBarButtonItem alloc] initWithImage:shareImage
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(shareTheDocument)];
        
    }
    return _shareBarButton;
}

- (UIBarButtonItem *)backBarButton
{
    if(!_backBarButton)
    {
        UIImage *backImage = [UIImage imageNamed:@"btn_back_normal"];
        _backBarButton =[[UIBarButtonItem alloc] initWithImage:backImage
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(turnBack)];
        
    }
    return _backBarButton;
}

@end

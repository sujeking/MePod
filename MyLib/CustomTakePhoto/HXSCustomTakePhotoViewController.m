//
//  HXSCustomTakePhotoViewController.m
//  store
//
//  Created by  黎明 on 16/7/20.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCustomTakePhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "HXSFinishTakePhotoView.h"



static CGFloat x = 10;
static CGFloat y = 173;
static CGFloat height = 222;



@interface HXSCustomTakePhotoViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *captureStillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

@property (nonatomic, weak) IBOutlet UILabel *tipLabel;

@end

@implementation HXSCustomTakePhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getAuthorization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.captureSession)
    {
        [self.captureSession stopRunning];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - Initial Methods

//获取授权
- (void)getAuthorization
{
    /*
     AVAuthorizationStatusNotDetermined = 0,// 未进行授权选择
     
     AVAuthorizationStatusRestricted,　　　　// 未授权，且用户无法更新，如家长控制情况下
     
     AVAuthorizationStatusDenied,　　　　　　 // 用户拒绝App使用
     
     AVAuthorizationStatusAuthorized,　　　　// 已授权，可使用
     */
    //此处获取摄像头授权
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
    {
        case AVAuthorizationStatusAuthorized:       //已授权，可使用    The client is authorized to access the hardware supporting a media type.
        {
            [self createCamera];
            
            break;
        }
        case AVAuthorizationStatusNotDetermined:    //未进行授权选择     Indicates that the user has not yet made a choice regarding whether the client can access the hardware.
        {
            //则再次请求授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted) {    //用户授权成功
                    [self createCamera];
                    
                    return;
                } else {        //用户拒绝授权
                    [self displayAlertView];
                    
                    return;
                }
            }];
            break;
        }
        default:                                    //用户拒绝授权/未授权
        {
            [self displayAlertView];
            
            break;
        }
    }
    
}


- (void)createCamera
{
    BEGIN_MAIN_THREAD
    
    [self initAVF];
    
    [self setupSubView];
    
    [self.captureSession startRunning];
    
    END_MAIN_THREAD
}

- (void)initAVF
{
    NSDictionary *outSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self captureDevice] error:nil];
    
    self.captureStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.captureStillImageOutput setOutputSettings:outSettings];
    
    
    if ([self.captureSession canAddInput:self.captureDeviceInput])
    {
        [self.captureSession addInput:self.captureDeviceInput];
    }
    
    if ([self.captureSession canAddOutput:self.captureStillImageOutput])
    {
        [self.captureSession addOutput:self.captureStillImageOutput];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.previewLayer.frame = [[UIScreen mainScreen] bounds];
    
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
}

- (AVCaptureDevice *)captureDevice
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == AVCaptureDevicePositionBack)
        {
            return device;
        }
    }
    return nil;
}

- (void)setupSubView
{
    self.tipLabel.numberOfLines = 2;
    
    switch (self.takePhotoType) {
        case kHXSTakePhotoTypeCardUp:
        {
            self.tipLabel.text = @"请将身份证正面置于此区域内";
        }
            break;
        case kHXSTakePhotoTypeCardDown:
        {
            self.tipLabel.text = @"请将身份证反面置于此区域内";
        }
            break;
        case kHXSTakePhotoTypeCardHandle:
        {
            self.tipLabel.text = @"请用户本人手持《身份证正面》面对镜头，将其上半身置于此区域内";
        }
            break;
        default:
            break;
    }
}


#pragma mark - ACTION

- (IBAction)cancelTakePhoto:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)takePhoto:(id)sender
{
    WS(weakSelf);
    
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    AVCaptureConnection * videoConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection)
    {
        DLog(@"take photo failed!");
        return;
    }
    [videoConnection setVideoOrientation:avcaptureOrientation];
    
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (!imageDataSampleBuffer) {
            return;
        }
        
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage * image = [UIImage imageWithData:imageData];
        
        image = [weakSelf fixOrientation:image];
        
        image = [weakSelf scaleToSize:image size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        //中间框区域
        CGRect rect = CGRectMake(x, y, SCREEN_WIDTH - 2 * x, height);
        image = [weakSelf cropImage:image rect:rect];
        HXSFinishTakePhotoView *finishTakePhotoView = [[HXSFinishTakePhotoView alloc] initWithImage:image];
        [finishTakePhotoView setReTakePhotoBlock:^(HXSFinishTakePhotoView *view) {
            [view removeFromSuperview];
        }];
        
        [finishTakePhotoView setTakePhotoDoneBlock:^(UIImage *img) {
            
            [weakSelf dismissViewControllerWithImage:img];
        }];

        [weakSelf.view addSubview:finishTakePhotoView];
    }];
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

- (void)dismissViewControllerWithImage:(UIImage *)image
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(takePhotoDoneFinishAndGetImage:)])
    {
        [self.delegate performSelector:@selector(takePhotoDoneFinishAndGetImage:) withObject:image];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




/**
 *  缩放
 *
 *  @param img
 *  @param size
 *
 *  @return
 */
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
/**
 *  裁剪
 *
 *  @param image
 *  @param rect
 *
 *  @return
 */
- (UIImage *)cropImage:(UIImage *)image rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGImageRef subImgeRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, subImgeRef);
    image = [UIImage imageWithCGImage:subImgeRef];
    UIGraphicsEndImageContext();
    
    return image;
}


/**
 *  矫正照片方向
 *
 *  @param srcImg
 *
 *  @return
 */
- (UIImage *)fixOrientation:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


#pragma mark - Alert View

- (void)displayAlertView
{
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒"
                                                                      message:@"请在iPhone的“设置-隐私-相机”选项中，允许59store访问你的相机"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"去设置"];
    
    __weak typeof(self) weakSelf = self;
    alertView.leftBtnBlock = ^(){
        [weakSelf dismissViewControllerAnimated:YES
                                     completion:nil];
    };
    
    alertView.rightBtnBlock = ^(){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=Privacy"]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy"]];
        }
    };
    
    [alertView show];
}

@end

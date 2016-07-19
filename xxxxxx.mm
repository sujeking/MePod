//
//  ViewController.m
//  kkk
//
//  Created by sujeking on 16/7/19.
//  Copyright © 2016年 sujeking. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, weak) IBOutlet UIImageView *imageview;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSubData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.session startRunning];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initSubData
{
    NSDictionary *outSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    
    self.session = [[AVCaptureSession alloc] init];
    self.deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self captureDevice] error:nil];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.stillImageOutput setOutputSettings:outSettings];
    
    
    if ([self.session canAddInput:self.deviceInput]) {
        [self.session addInput:self.deviceInput];
    }
    
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.videoPreviewLayer.frame = self.view.bounds;
//    [self.view.layer insertSublayer:self.videoPreviewLayer atIndex:0];
}

- (AVCaptureDevice *)captureDevice
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            return device;
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];

    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [videoConnection setVideoOrientation:avcaptureOrientation];
    
    __weak typeof(self)ws = self;
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                       completionHandler:^(CMSampleBufferRef imageDataSampleBuffer,
                                                                           NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage * image = [UIImage imageWithData:imageData];
        NSLog(@"image size = %@",NSStringFromCGSize(image.size));
        
       ws.imageview.image = image;
       return;
                                                 
       CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                                                                   imageDataSampleBuffer,
                                                                                                                       kCMAttachmentMode_ShouldPropagate);
                                                           
                                                           
                                                           
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
        //无权限
        return ;
        }
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:imageData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {

        }];
                                                           
                                                           
    }];
}

-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}




@end

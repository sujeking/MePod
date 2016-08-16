//
//  HXSCustomAlertView.m
//  store
//
//  Created by ArthurWang on 15/7/30.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSCustomAlertView.h"

#import "HXAppDeviceHelper.h"
#import "UIWindow+Extension.h"

static HXSCustomAlertView *alertViewSingle = nil;

@interface HXSCustomAlertView ()<UIAlertViewDelegate>

@property (nonatomic, assign) BOOL didRightToLeft;

@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSString *otherButtonTitle;

@property (nonatomic, strong) UIAlertView       *alertView;
@property (nonatomic, strong) UIAlertController *alertVC;

@end

@implementation HXSCustomAlertView

+ (instancetype)shareAlertView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == alertViewSingle) {
            alertViewSingle = [[[self class] alloc] init];
        }
    });
    
    return alertViewSingle;
}


#pragma mark - Initail Methods

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftButtonTitle:(NSString *)cancelButtonTitle
            rightButtonTitles:(NSString *)otherButtonTitle
{
    HXSCustomAlertView *alertView = [HXSCustomAlertView shareAlertView];
    if (nil != alertView) {
        alertView.titleStr          = title;
        alertView.messageStr        = message;
        alertView.didRightToLeft    = NO;
        alertView.leftBtnBlock      = nil;
        alertView.rightBtnBlock     = nil;
        alertView.cancelButtonTitle = cancelButtonTitle;
        alertView.otherButtonTitle  = otherButtonTitle;
        
        // default, should create alert view before setting alignment
        alertView.messageLabelAlignment   = MESSAGE_LABEL_ALIGNMENT_CENTER;
    }
    
    return alertView;
}

- (void)dealloc
{
    self.titleStr           = nil;
    self.messageStr         = nil;
    self.leftBtnBlock       = nil;
    self.rightBtnBlock      = nil;
}

#pragma mark - Public Methods

- (void)show
{
//    [self closePreviousAlertView];
    
    if (SYSTEM_VERSION_LESS_THAN(@"8")) {
    
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:self.titleStr
                                                         message:self.messageStr
                                                        delegate:self
                                               cancelButtonTitle:self.cancelButtonTitle
                                               otherButtonTitles:self.otherButtonTitle, nil];
        [alert show];
        
        self.alertView = alert;
    }else {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:self.titleStr message:self.messageStr preferredStyle:UIAlertControllerStyleAlert];
        if (nil != self.cancelButtonTitle) {
            UIAlertAction *leftAction = [UIAlertAction actionWithTitle:self.cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if (nil != self.leftBtnBlock) {
                    self.leftBtnBlock();
                }
                
            }];
            
            [alertVC addAction:leftAction];
        }
        
        if (nil != self.otherButtonTitle) {
            UIAlertAction *rightAction = [UIAlertAction actionWithTitle:self.otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (nil != self.rightBtnBlock) {
                    self.rightBtnBlock();
                }
            }];
            
            [alertVC addAction:rightAction];
        }
        
        
        
        UIViewController *vc = [self getCurrentVC];
        
        if (vc.presentedViewController) {
            [vc.presentedViewController presentViewController:alertVC animated:YES completion:nil];
        }
        else {
            [vc presentViewController:alertVC animated:YES completion:nil];
        }
        
        self.alertVC = alertVC;
    }
}


#pragma mark - Close Alert View

- (void)closePreviousAlertView
{
    if (nil != self.alertView) {
        [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
        self.alertView.delegate = nil;
        self.alertView = nil;
    }
    
    if (nil != self.alertVC) {
        [self.alertVC dismissViewControllerAnimated:NO completion:nil];
        
        self.alertVC = nil;
    }
    
}

#pragma mark --- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (self.leftBtnBlock) {
            self.leftBtnBlock();
        }
    }
    if (buttonIndex == 1) {
        if (self.rightBtnBlock) {
            self.rightBtnBlock();
        }
    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    UIViewController *result = [window topVisibleViewController];
    
    return result;
}

@end

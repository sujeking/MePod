//
//  MBProgressHUD+HXS.m
//  59dorm
//
//  Created by ArthurWang on 15/9/7.
//  Copyright (c) 2015年 Huanxiao. All rights reserved.
//

#import "MBProgressHUD+HXS.h"
#import "HXSLoadingAnimation.h"


@interface LoadingBackgroundView : UIView

@end

@implementation LoadingBackgroundView

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(60, 60);
}

@end

@implementation MBProgressHUD (HXS)

+ (instancetype)showDrawInViewWithoutIndicator:(UIView *)view status:(NSString *)text afterDelay:(NSTimeInterval)delay
{
    if (nil == view) {
        return nil;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud setMode:MBProgressHUDModeCustomView];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_done"]];
    hud.detailsLabelText = text;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:16.0f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor blackColor];
    [hud hide:YES afterDelay:delay];
    
    return hud;
}

+ (instancetype)showInViewWithoutIndicator:(UIView *)view status:(NSString *)text afterDelay:(NSTimeInterval)delay
{
    if (nil == view) {
        return nil;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    hud.detailsLabelText = text;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:16.0f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor blackColor];
    
    [hud hide:YES afterDelay:delay];
    
    return hud;
}

+ (instancetype)showInViewWithoutIndicator:(UIView *)view
                                       status:(NSString *)text
                                   afterDelay:(NSTimeInterval)delay
                         andWithCompleteBlock:(void (^)())block
{

    if (nil == view) {
        return nil;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    hud.detailsLabelText = text;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:16.0f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor blackColor];
    [hud hide:YES afterDelay:delay];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
    
    return hud;

}

+ (instancetype)showInView:(UIView *)view
{
    if (nil == view) {
        return nil;
    }
    
    LoadingBackgroundView *tempView = [[LoadingBackgroundView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [tempView setBackgroundColor:[UIColor clearColor]];
    
    id <HXSLoadingAnimaitonProtocol> animation = [[HXSLoadingAnimation alloc] init];
    if ([animation respondsToSelector:@selector(setupAnimationInLayer:withSize:)]) {
        [animation setupAnimationInLayer:tempView.layer withSize:tempView.bounds.size];
        tempView.layer.speed = 1.0; // start animation
    }
    
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud setMode:MBProgressHUDModeCustomView];
    hud.customView = tempView;
    hud.margin     = 0.0f;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    hud.backgroundView.color = [UIColor clearColor];
    
    return hud;
}

+ (instancetype)showInView:(UIView *)view status:(NSString *)text
{
    if (nil == view) {
        return nil;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:16.0f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor blackColor];
    
    return hud;
}

+ (instancetype)showInView:(UIView *)view
                   customView:(UIView *)customView
                       status:(NSString *)text
                   afterDelay:(NSTimeInterval)delay{
    if (nil == view) {
        return nil;
    }

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud setMode:MBProgressHUDModeCustomView];
    [hud setCustomView:customView];

    hud.detailsLabelText = text;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:16.0f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor blackColor];
    
    [hud hide:YES afterDelay:delay];
    
    return hud;
}

+ (instancetype)showInView:(UIView *)view
                   customView:(UIView *)customView
                       status:(NSString *)text
                   afterDelay:(NSTimeInterval)delay
                completeBlock:(void (^)())block{
    
    if (nil == view) {
        return nil;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud setMode:MBProgressHUDModeCustomView];
    [hud setCustomView:customView];
    
    hud.detailsLabelText = text;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:16.0f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor blackColor];
    
    [hud hide:YES afterDelay:delay];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
    return hud;
}

@end

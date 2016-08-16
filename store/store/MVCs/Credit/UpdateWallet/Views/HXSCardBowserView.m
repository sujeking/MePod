//
//  HXSAvatarBrowser.m
//
//
//  Created by 黎明 on 15-11-1.
//

#import "HXSCardBowserView.h"

@implementation HXSCardBowserView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return self;
}

- (void)showImage:(UIImageView *)avatarImageView
{
    
    UIImage *image = avatarImageView.image;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    

    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    
    self.backgroundColor = [UIColor blackColor];
    
    self.alpha = 0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    
    imageView.image = image;
    
    imageView.tag = 1;
    
    [self addSubview:imageView];
    
    [window addSubview:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(hideImage:)];
    [self addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height - image.size.height*[UIScreen mainScreen].bounds.size.width / image.size.width)/2,
                                     [UIScreen mainScreen].bounds.size.width,
                                     image.size.height*[UIScreen mainScreen].bounds.size.width / image.size.width);
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    
    UIButton *reTakePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 33, 34, 14)];
    reTakePhotoButton.center = CGPointMake(CGRectGetWidth(self.bounds)/2, reTakePhotoButton.center.y);
    [reTakePhotoButton setTitle:@"重拍" forState:UIControlStateNormal];
    reTakePhotoButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [reTakePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reTakePhotoButton addTarget:self action:@selector(reTakePhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:reTakePhotoButton];
}

- (void)reTakePhotoButtonClick:(UIButton *)sender
{
    UIImageView *imageView = (UIImageView*)[self viewWithTag:1];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame = oldframe;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self reTakePhotoAction];
    }];
}

- (void)reTakePhotoAction
{
    if (self.reTakePhotoBlock) {
        self.reTakePhotoBlock();
    }
}


- (void)hideImage:(UITapGestureRecognizer*)tap{
        
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame = oldframe;
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
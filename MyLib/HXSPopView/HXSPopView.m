//
//  HXSPopView.m
//  aaaaaa
//
//  Created by  黎明 on 16/7/12.
//  Copyright © 2016年 suzw. All rights reserved.
//

#import "HXSPopView.h"


@interface HXSPopView()

@property (nonatomic, weak) IBOutlet UIView *popBgView;
@property (nonatomic, weak) IBOutlet UIImageView *popContentImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popContentHeightConstraint;

@property (nonatomic, strong) NSString *imageUrl;

@end

@implementation HXSPopView

- (void)awakeFromNib
{
    [self.popContentImageView.layer setCornerRadius:5.0f];
    [self.popContentImageView.layer setMasksToBounds:YES];

    [self.popContentImageView setBackgroundColor:[UIColor whiteColor]];
    [self.popContentImageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (instancetype)initWithUrl:(NSString *)imageUrl
{
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:NSStringFromClass([self class]) ofType:@"bundle"];
    if (bundlePath)
    {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    NSArray* nib = [bundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self = [nib firstObject];
    
    if (self)
    {
        self.frame = [[UIScreen mainScreen] bounds];
        self.imageUrl = imageUrl;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
    self.popContentImageView.image = [UIImage imageWithData:data];
}


- (IBAction)closeButtonClickAction:(id)sender
{
    [self close];
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];

    
    [self layoutIfNeeded];
    [UIView animateWithDuration:.5 animations:^{
    
        self.popContentHeightConstraint.constant = CGRectGetWidth(self.bounds);
        [self layoutIfNeeded];

    }];
}

- (void)close
{
    self.popContentHeightConstraint.constant = 0;

    [UIView animateWithDuration:.5 animations:^{
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
     
        [UIView animateWithDuration:.3 animations:^{
            [self setAlpha:0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

@end

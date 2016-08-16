//
//  HXSPopView.m
//  aaaaaa
//
//  Created by  黎明 on 16/7/12.
//  Copyright © 2016年 suzw. All rights reserved.
//

#import "HXSPopView.h"
#import <Masonry.h>

@interface HXSPopView()

@property (nonatomic, strong) UIView *subView;
@property (nonatomic, weak) IBOutlet UIView *popBgView;
@property (nonatomic, weak) IBOutlet UIView *popContentView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *popContentHeightConstraint;


@end

@implementation HXSPopView

- (void)awakeFromNib
{
    [self.popContentView.layer setCornerRadius:5.0f];
    [self.popContentView.layer setMasksToBounds:YES];

    [self.popContentView setBackgroundColor:[UIColor whiteColor]];
    [self.popContentView setContentMode:UIViewContentModeScaleAspectFill];
}

- (instancetype)initWithView:(UIView *)view
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
        self.subView = view;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    [self.popContentView addSubview:self.subView];
    
    WS(weakSelf);
    [self.subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.popContentView);
    }];
}


- (IBAction)closeButtonClickAction:(id)sender
{
    [self closeWithCompleteBlock:nil];
}

#pragma mark Public Method
- (void)closeWithCompleteBlock:(void(^)())block
{
    self.popContentHeightConstraint.constant = 0;
    
    [UIView animateWithDuration:.5 animations:^{
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.3 animations:^{
            
            [self setAlpha:0];
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
            
            if (block)
            {
                block();
            }
        }];
    }];
}


- (void)show
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];

    
    [self layoutIfNeeded];
    [UIView animateWithDuration:.5 animations:^{
    
        self.popContentHeightConstraint.constant = CGRectGetWidth(self.bounds);
        [self layoutIfNeeded];

    }];
}


@end

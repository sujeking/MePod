//
//  HXSDormHotLevelView.m
//  store
//
//  Created by hudezhi on 15/10/8.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSDormHotLevelView.h"

#define COUNT_STAR  5

@interface HXSDormHotLevelView  () {
    NSMutableArray *_hotStarImageViews;
}

- (void)setup;

@end

@implementation HXSDormHotLevelView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = 3.0;
    CGFloat starWidth = self.height;
    for (int i = 0 ; i < _hotStarImageViews.count ; i++) {
        UIImageView *imageV = _hotStarImageViews[i];
        imageV.frame = CGRectMake((starWidth + padding)*i, 0, starWidth, starWidth);
    }
}


#pragma mark - private method

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    _hotStarImageViews = [NSMutableArray array];
}


#pragma mark - getter/setter

- (void)setHotValue:(NSInteger)hotValue
{
    for (UIImageView *imageView in _hotStarImageViews) {
        [imageView removeFromSuperview];
    }
    [_hotStarImageViews removeAllObjects];
    
    int level = ceil(hotValue);
    for (int i = 0; i < COUNT_STAR; i++) {
        UIImageView *imagev = [[UIImageView alloc] init];
        imagev.backgroundColor = [UIColor clearColor];
        [self addSubview:imagev];
        
        NSString *imageName;
        if (i <= (level - 1)) {
            imageName = @"img_hot_star";
        } else {
            imageName = @"ic_starhollow";
        }
        
        imagev.image = [UIImage imageNamed:imageName];
        [_hotStarImageViews addObject:imagev];
    }
    
    if (_hotStarImageViews.count > 0) {
        [self setNeedsLayout];
    }
}

@end

//
//  HXSStarLevelView.m
//  store
//
//  Created by 沈露萍 on 16/3/5.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSStarLevelView.h"


#define BASIC_TAG  1000

@interface HXSStarLevelView ()

@property (nonatomic, strong) NSString *normalImage;
@property (nonatomic, strong) NSString *selectedImage;
@property (nonatomic, assign) NSInteger num;

@end

@implementation HXSStarLevelView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupViewWithStarCount:5
                     normalImage:@"ic_star_unselected"
                   selectedImage:@"ic_star_selected"
                       starWidth:26.0
                      starHeight:24.0
                         spacing:5.0];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupViewWithStarCount:(NSInteger)count
                   normalImage:(NSString *)normalImage
                 selectedImage:(NSString *)selectedImage
                     starWidth:(float)width
                    starHeight:(float)height
                       spacing:(float)spacing
{
    self.num = count;
    self.backgroundColor = [UIColor clearColor];
    self.normalImage = normalImage;
    self.selectedImage = selectedImage;
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * (width + spacing), 8, width, height);
        [btn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateNormal];
        btn.tag = i + BASIC_TAG;
        [btn setEnabled:YES];
        [btn addTarget:self action:@selector(matchDesc:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
    
    self.starLevel = count;
}

- (void)matchDesc:(UIButton *)sender
{
    NSInteger tag = sender.tag - BASIC_TAG;
    
    for (UIView *view in [self subviews]) {
        if (![view isKindOfClass:[UIButton class]]) {
            continue;
        }
        
        UIButton *btn = (UIButton *)view;
        
        NSInteger tagBtn = btn.tag - BASIC_TAG;
        
        if ((tagBtn >= 0)
            && (tagBtn <= tag)) {
            [btn setImage:[UIImage imageNamed:self.selectedImage] forState:UIControlStateNormal];
        } else {
            [btn setImage:[UIImage imageNamed:self.normalImage] forState:UIControlStateNormal];
        }
    }
    
    self.starLevel = tag + 1;  // 从1开始
}
@end

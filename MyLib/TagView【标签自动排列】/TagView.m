//
//  TagView.m
//  masony
//
//  Created by  jeking on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TagView.h"


#define MARGIN  10
#define HPADDING 14
#define VPADDING 5

#define ATTRIBUTE @{NSFontAttributeName:[UIFont systemFontOfSize:HPADDING]}

@interface TagView()

@property (nonatomic, assign) CGRect previousFrame;
@property (nonatomic, assign) CGFloat totalHeight;
@end

@implementation TagView

- (instancetype)initWithTags:(NSArray *)tags
{
    self = [super init];
    if (self) {
        [self initFrame];
        [self setupTags:tags];
        [self setBackgroundColor:[UIColor yellowColor]];
    }
    return self;
}

- (void)initFrame
{
    [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0)];
}


- (void)setupTags:(NSArray *)tags
{
     _previousFrame = CGRectZero;
    _previousFrame.origin.y = MARGIN;
    
    for (NSString *titleStr in tags) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        CGSize size = [titleStr sizeWithAttributes:ATTRIBUTE];
        size.width  += HPADDING*2;
        size.height += VPADDING*2;
        
        CGRect tagFrame = CGRectZero;
        
        //检测是否需要换行
        if (_previousFrame.origin.x + _previousFrame.size.width + size.width + MARGIN > self.bounds.size.width) {
            tagFrame.origin = CGPointMake(10, _previousFrame.origin.y + size.height + MARGIN);
            _totalHeight += size.height + MARGIN;
        }
        else {
            tagFrame.origin = CGPointMake(_previousFrame.origin.x + _previousFrame.size.width + MARGIN, _previousFrame.origin.y);
            _totalHeight = _totalHeight == 0 ? (size.height + MARGIN):_totalHeight;
        }
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenTagView:)];
        [label addGestureRecognizer:tap];
        [label setUserInteractionEnabled:YES];
        
        
        tagFrame.size = size;
        _previousFrame = tagFrame;

        [label setText:titleStr];
        [label setFrame:tagFrame];
        [label setFont:[UIFont systemFontOfSize:HPADDING]];
        [label setBackgroundColor:[UIColor redColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
    };
    
    _totalHeight += MARGIN;
    [self updateViewHeight:_totalHeight];
}

//更新总高度
- (void)updateViewHeight:(CGFloat)height
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = [[UIScreen mainScreen] bounds].size.height;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}

//显示
- (void)showTagView
{
    [UIView animateWithDuration:0.3 delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0
                        options:0
                     animations:^{
        
                         CGRect frame = self.frame;
                         frame.origin.y = [[UIScreen mainScreen] bounds].size.height- 48 - _totalHeight;
                         self.frame = frame;
                         
                     } completion:^(BOOL finished) {
        
    }];
  
}

//隐藏
- (void)hiddenTagView:(UITapGestureRecognizer *)sender
{
 
    __block UILabel *label = (UILabel *)sender.view;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = [[UIScreen mainScreen] bounds].size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
    
        NSLog(@"%@",label.text);
    }];
}


@end

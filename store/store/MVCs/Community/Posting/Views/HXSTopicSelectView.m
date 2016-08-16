//
//  TagView.m
//  masony
//
//  Created by  jeking on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HXSTopicSelectView.h"
#import "HXSCommunitTopicEntity.h"

#define MARGIN  15
#define HPADDING 14
#define VPADDING 5

#define ATTRIBUTE @{NSFontAttributeName:[UIFont systemFontOfSize:HPADDING]}

@interface HXSTopicSelectView()

@property (nonatomic, assign) CGRect previousFrame;
@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, strong) NSArray *topicArray;
@property (nonatomic, strong) NSString *selectedString;
@end

@implementation HXSTopicSelectView

- (instancetype)initWithTags:(NSArray *)tags key:(NSString *)key selectedString:(NSString *)value
{
    self = [super init];
    if (self) {
        [self initFrame];
        [self setupTags:tags key:key selectedString:value];
        [self setBackgroundColor:[UIColor colorWithWhite:1.000 alpha:1.000]];
    }
    return self;
}

- (void)initFrame
{
    [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0)];
}


- (void)setupTags:(NSArray *)tags key:(NSString *)key selectedString:(NSString *)valueString
{
    if ([self.topicArray isEqual:tags]) {
        return;
    }
    
    _topicArray = tags;
    
    _previousFrame = CGRectZero;
    _previousFrame.origin.y = 0;
    
    for (id obj in tags) {
        
        NSValue *value = [obj valueForKey:key];
        NSString *titleStr = (NSString *) value;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        CGSize size = [titleStr sizeWithAttributes:ATTRIBUTE];
        size.width  += HPADDING*2;
        size.height += VPADDING*2;
        
        CGRect tagFrame = CGRectZero;
        
        //检测是否需要换行
        if (_previousFrame.origin.x + _previousFrame.size.width + size.width + MARGIN > self.bounds.size.width) {
            tagFrame.origin = CGPointMake(15, _previousFrame.origin.y + size.height + 15);
            _totalHeight += size.height + MARGIN;
        }
        else {
            tagFrame.origin = CGPointMake(_previousFrame.origin.x + _previousFrame.size.width + MARGIN, _previousFrame.origin.y);
            _totalHeight = _totalHeight == 0 ? size.height : _totalHeight;
        }
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTopicAction:)];
        [label addGestureRecognizer:tap];
        [label setUserInteractionEnabled:YES];
        
        
        tagFrame.size = size;
        _previousFrame = tagFrame;
        
        [label setText:titleStr];
        if (valueString && [valueString isEqualToString:titleStr]) {
            [self setSelectStyle:label];
        } else {
            [self setNormalStyle:label];
        }
        [label setFrame:tagFrame];
        [label setFont:[UIFont systemFontOfSize:HPADDING]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
    };
    
    _totalHeight += MARGIN;
    [self updateViewHeight:_totalHeight];
}

- (void)updateAllLabelBackColor
{
    for (UILabel *label in self.subviews) {
        [self setNormalStyle:label];
    }
}



- (void)setSelectStyle:(UILabel *)label
{
    [label setBackgroundColor:[UIColor colorWithRed:0.976 green:0.647 blue:0.008 alpha:1.000]];
    [label.layer setBorderWidth:0];
    [label setTextColor:[UIColor whiteColor]];
}

- (void)setNormalStyle:(UILabel *)label
{
    [label setBackgroundColor:[UIColor colorWithWhite:1.000 alpha:1.000]];
    [label.layer setBorderColor:[[UIColor colorWithRed:0.882 green:0.886 blue:0.890 alpha:1.000] CGColor]];
    [label.layer setBorderWidth:1.0f];
    [label setTextColor:[UIColor colorWithWhite:0.557 alpha:1.000]];
}



//更新总高度
- (void)updateViewHeight:(CGFloat)height
{
    CGRect tempFrame = self.frame;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}

//隐藏
- (void)selectTopicAction:(UITapGestureRecognizer *)sender
{
    UILabel *label = (UILabel *)sender.view;
    [self updateAllLabelBackColor];
    [self setSelectStyle:label];
    
    NSInteger index = [[self subviews] indexOfObject:label];
    id obj = self.topicArray[index];
    
    if(self.selectedTopicBlock) {
        self.selectedTopicBlock(obj);
    }
}


- (NSArray *)topicArray
{
    if (!_topicArray) {
        _topicArray = [[NSArray alloc] init];
    }
    return _topicArray;
}


@end

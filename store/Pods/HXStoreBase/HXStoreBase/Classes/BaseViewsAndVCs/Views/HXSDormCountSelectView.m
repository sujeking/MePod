//
//  HXSDormCountSelectView.m
//  store
//
//  Created by chsasaw on 14/11/20.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSDormCountSelectView.h"

#import "HXSCustomPickerView.h"
#import "HXMacrosUtils.h"

@interface HXSDormCountSelectView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITextField * countField;

@property (nonatomic, strong) UILabel * statusText;

@property (nonatomic) BOOL valueChangeNotComplete;

@end

@implementation HXSDormCountSelectView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self initSubViews];
    }
    
    return self;
}

- (id)init {
    if(self = [super init]) {
        [self initSubViews];
    }
    
    return self;
}

- (void)initSubViews {
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.layer.masksToBounds = YES;
    
    self.valueChangeNotComplete = NO;
    
    _status = kHXSDormItemStatusNormal;
    
    self.statusText = [[UILabel alloc] initWithFrame:self.bounds];
    self.statusText.font = [UIFont systemFontOfSize:14.0f];
    [self.statusText setTextColor:HXS_SEPARATION_LINE_COLOR];
    [self addSubview:self.statusText];
    self.statusText.textAlignment = NSTextAlignmentRight;
    self.statusText.hidden = YES;
    
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.contentView];
    self.contentView.layer.masksToBounds = YES;
    
    self.leftButton = [[UIButton alloc] init];
    [self.leftButton setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.leftButton];
    [self.leftButton setImage:[UIImage imageNamed:@"ic_minus_normal"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"ic_minus_pressed"] forState:UIControlStateHighlighted];
    [self.leftButton addTarget:self action:@selector(minus) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightButton = [[UIButton alloc] init];
    [self.rightButton setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.rightButton];
    [self.rightButton setImage:[UIImage imageNamed:@"ic_plus_normal"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"ic_plus_pressed"] forState:UIControlStateHighlighted];
    [self.rightButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    self.countField = [[UITextField alloc] init];
    self.countField.borderStyle = UITextBorderStyleNone;
    self.countField.textColor = HXS_INFO_NOMARL_COLOR;
    self.countField.text = @"0";
    self.countField.textAlignment = NSTextAlignmentCenter;
    self.countField.adjustsFontSizeToFitWidth = YES;
    self.countField.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:self.countField];
    self.countField.enabled = NO;
    
    // initial max count
    self.maxCount = [NSNumber numberWithInt:INT_MAX];
}

- (void)setStatus:(HXSDormItemStatus)status animated:(BOOL)animated {
    _status = status;
    
    [self refreshControl:animated];
}

- (void)setCount:(int)count animated:(BOOL)animated manual:(BOOL)manual {
    //手动点击或者更新数据完成才能再次更新，否则造成数据错误
    if(manual || !self.valueChangeNotComplete) {
        [self.countField setText:[NSString stringWithFormat:@"%d", count]];
        [self refreshControl:animated];
    }
}

- (void)valueChanged {
    
    if([self.delegate respondsToSelector:@selector(countSelectView:didEndEdit:)]) {
        [self.delegate countSelectView:self didEndEdit:[self getCount]];
    }
    
    self.valueChangeNotComplete = NO;
}

- (int)getCount {
    return self.countField.text.intValue;
}

- (void)add
{
    // Only set the count is max value.
    if ([self.maxCount integerValue] <= [self getCount]) {
        return;
    }
    
    [self setCount:[self getCount]+1 animated:YES manual:YES];
    
    if([self.delegate respondsToSelector:@selector(countAdd)]) {
        [self.delegate countAdd];
    }
    
    self.valueChangeNotComplete = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(valueChanged) object:nil];
    [self performSelector:@selector(valueChanged) withObject:nil afterDelay:0.5];
}

- (void)minus
{
    [self setCount:[self getCount] - 1 animated:YES manual:YES];
    
    self.valueChangeNotComplete = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(valueChanged) object:nil];
    [self performSelector:@selector(valueChanged) withObject:nil afterDelay:0.5];
}

- (void)refreshControl:(BOOL) animated {
    [self.layer removeAllAnimations];
    
    CGSize size = self.bounds.size;
    self.leftButton.frame = CGRectMake(0, 0, size.width/3.0, size.height);
    
    self.countField.frame = CGRectMake(size.width/3.0, 0, size.width/3.0, size.height);
    self.countField.textColor = UIColorFromRGB(0x666666);
    
    self.rightButton.frame = CGRectMake(size.width*2.0/3.0, 0, size.width/3.0, size.height);
    
    self.contentView.layer.cornerRadius = self.bounds.size.height*0.5f;
    self.statusText.frame = self.bounds;
    
    self.statusText.text = [self getStatusString];
    if(self.status != kHXSDormItemStatusNormal) {
        self.contentView.hidden = YES;
        self.statusText.hidden = NO;
    }else {
        self.statusText.hidden = YES;
        self.contentView.hidden = NO;
    }
    
    self.leftButton.hidden = [self getCount] == 0;
    self.countField.hidden = [self getCount] == 0;
    self.rightButton.hidden = ([self.maxCount integerValue] <= [self getCount]);
    self.rightButton.enabled = YES;
}

- (NSString *)getStatusString {
    if(self.status == kHXSDormItemStatusClosed) {
        return @"休息中";
    }else if(self.status == kHXSDormItemStatusEmpty) {
        return @"未开通";
    }else if(self.status == kHXSDormItemStatusLackStock) {
        return @"卖光啦";
    }else {
        return @"";
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSMutableArray * array = [NSMutableArray array];
    for(int i=1; i<100; i++) {
        [array addObject:[NSString stringWithFormat:@"%d", i]];
    }
    [HXSCustomPickerView showWithStringArray:array defaultValue:self.countField.text toolBarColor:HXS_DORM_MAIN_COLOR completeBlock:^(int index, BOOL finished) {
        if(finished) {
            [self setCount:index+1 animated:YES manual:YES];
            [self valueChanged];
        }
    }];
    
    return NO;
}

@end
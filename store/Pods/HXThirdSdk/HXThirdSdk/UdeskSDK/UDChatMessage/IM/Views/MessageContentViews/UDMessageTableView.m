//
//  UDMessageTableView.m
//  UdeskSDK
//
//  Created by xuchen on 15/12/22.
//  Copyright © 2015年 xuchen. All rights reserved.
//

#import "UDMessageTableView.h"
#import "UDMessageTableViewCell.h"
#import "UDChatViewModel.h"
#import "UDFoundationMacro.h"
#import "NSArray+UDMessage.h"

@interface UDMessageTableView() <UDMessageTableViewCellDelegate>
@end

@implementation UDMessageTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.separatorColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UD_SCREEN_WIDTH, 25)];
        headView.backgroundColor = [UIColor clearColor];
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.hidden = NO;
        activity.frame = CGRectMake(headView.frame.size.width/2-10, 5, 20, 25);
        [headView addSubview:activity];
        
        self.tableHeaderView = headView;
//        headView.hidden = YES;
        
        _headView = headView;
        _activity = activity;
        
        _isRefresh = YES;
        
    }
    return self;
}

//设置ContentSize
- (void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(self.contentSize, CGSizeZero))
    {
        if (contentSize.height > self.contentSize.height)
        {
            CGPoint offset = self.contentOffset;
            offset.y += (contentSize.height - self.contentSize.height);
            self.contentOffset = offset;
        }
    }
    [super setContentSize:contentSize];
}

//开始下拉
- (void)startLoadingMoreMessages {

    self.headView.hidden = NO;
    [self.activity startAnimating];
    _isRefresh = NO;
    
}
//下拉结束
- (void)finishLoadingMoreMessages:(NSInteger)count {

    //消息小于20条移除菊花
    if (count<20) {
        
        //没有更多消息停止刷新
        [self.activity stopAnimating];
        self.headView.hidden = YES;
        [self.headView removeFromSuperview];
        [self.activity removeFromSuperview];
        self.tableHeaderView = nil;
        
        _isRefresh = NO;
        
    }else {
    
        _isRefresh = YES;
    }
    
}

//设置TabelView bottom
- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.contentInset = insets;
    self.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    insets.bottom = bottom;
    
    return insets;
}

//滚动TableView
- (void)scrollToBottomAnimated:(BOOL)animated {
    
    NSInteger rows = [self numberOfRowsInSection:0];
    
    if (rows > 0) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                     atScrollPosition:UITableViewScrollPositionBottom
                                             animated:animated];
    }
}

@end

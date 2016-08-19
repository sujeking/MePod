//
//  statusView.h
//  消息新消息
//
//  Created by  黎明 on 16/8/19.
//  Copyright © 2016年 suzw. All rights reserved.
//
/************************************************************
 *  状态指示灯,预设3个状态 最少2个,通过Action修改Status
 ***********************************************************/
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, Status) {
//    开始
    BeginStatus,
//    进行中
    DealingStatus,
//    结束
    EndStatus
};


@interface statusView : UIView
//默认3个，最多3个，最少2个
@property (nonatomic, assign) Status    status;
@property (nonatomic, assign) NSInteger statusCount;

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray <
                                                    NSString *>*)titles;

@end

//
//  HXSSubscribeProgressSingleView.h
//  59dorm
//  开通流程中单个进程
//  Created by J006 on 16/7/11.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HXSSubscribeProgressSingleViewQueueType){
    HXSSubscribeProgressSingleViewQueueTypeNormal             = 0,
    HXSSubscribeProgressSingleViewQueueTypeFirst              = 1,//总环节队列中第一个
    HXSSubscribeProgressSingleViewQueueTypeLast               = 2//总环节队列中最后一个
};

typedef NS_ENUM(NSInteger,HXSSubscribeProgressSingleViewCurrentType){
    HXSSubscribeProgressSingleViewCurrentTypeNot             = 0,//未到该环节
    HXSSubscribeProgressSingleViewCurrentTypeCurrent         = 1,//正好到此环节
    HXSSubscribeProgressSingleViewCurrentTypePass            = 2//已过此环节
};

@interface HXSSubscribeProgressSingleView : UIView

/**
 *  初始化
 *
 *  @param content   标题
 *  @param enableImageName 已过的环节小图片
 *  @param disableImageName 未到的环节小图片
 *  @param currentImageNane 当前环节大图片
 *  @param queueType      队列类型
 *  @param currentType 当前环节队列类型
 *  @param width     宽度
 *  @param height    高度
 *
 *  @return
 */
+ (instancetype)createSubscribeProgressSingleViewWithContent:(NSString *)content
                                          andEnableImageName:(NSString *)enableImageName
                                         andDisableImageName:(NSString *)disableImageName
                                         andCurrentImageName:(NSString *)currentImageName
                                                     andType:(HXSSubscribeProgressSingleViewQueueType)queueType
                                              andCurrentStep:(HXSSubscribeProgressSingleViewCurrentType)currentType
                                                    andWidth:(CGFloat)width
                                                   andHeight:(CGFloat)height;

@end

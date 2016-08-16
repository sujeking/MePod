//
//  HXSMyFilesPopView.h
//  store
//  自定义弹出框
//  Created by J006 on 16/6/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HXSMyFilesPopViewRotation){
    HXSMyFilesPopViewRotationLeft      = 0,//左
    HXSMyFilesPopViewRotationMiddle    = 1,//中
    HXSMyFilesPopViewRotationRight     = 2 //右
};

typedef NS_ENUM(NSInteger,HXSMyFilesPopViewDirection){
    HXSMyFilesPopViewDirectionUp      = 0,//上方
    HXSMyFilesPopViewDirectionDown    = 1//下方
};

@class HXSMyFilesPopView;

@protocol HXSMyFilesPopViewDelegate <NSObject>

@required

/**
 *  按钮点击
 *
 *  @param popView 所属的弹出总界面
 *  @param tag     按钮索引,对应给定的按钮名称集合索引
 */
- (void)buttonClick:(HXSMyFilesPopView *)popView
       andWithIndex:(NSInteger)tag;

@end

@interface HXSMyFilesPopView : UIView

@property (nonatomic, weak) id<HXSMyFilesPopViewDelegate> delegate;

/**
 *  初始化
 *
 *  @param btnNameArray 按钮名称集合
 *  @param view         被点击触发弹出框的按钮或view
 *  @param delegate     代理指定对象
 *  @param direction    方向:是在点击对象的上方还是下方
 *  @param rotation     左右位置,如果是left则与点击对象右边对齐,如果是right则与点击对象左边对齐
 *
 *  @return
 */
+ (instancetype)initTheMyFilesPopViewWithBtnNameArray:(NSArray<NSString *> *)btnNameArray
                                           targetView:(UIView *)view
                                          andDelegate:(id<HXSMyFilesPopViewDelegate>)delegate
                                     popViewDirection:(HXSMyFilesPopViewDirection)direction
                                      popViewRotation:(HXSMyFilesPopViewRotation)rotation;

/**
 *  展示弹出框
 */
- (void)showThePopView;

@end

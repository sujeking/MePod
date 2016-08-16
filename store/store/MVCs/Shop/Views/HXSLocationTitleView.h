//
//  HXSLocationTitleView.h
//  store
//
//  Created by  黎明 on 16/7/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

/************************************************************
 *  店铺列表标题View，用于显示定位信息
 ***********************************************************/

#import <UIKit/UIKit.h>

@protocol HXSLocationTitleViewDelegate <NSObject>

- (void)changeLocation;

@end

@interface HXSLocationTitleView : UIView

@property (nonatomic, strong) NSString *locationStr;
@property (nonatomic, weak) id<HXSLocationTitleViewDelegate> delegate;

@end

//
//  HXSUpgradeCreditTableViewFooterView.h
//  store
//
//  Created by  黎明 on 16/7/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSUpgradeCreditTableViewFooterViewDelegate <NSObject>

/**
 *  提交按钮点击事件
 */
- (void)submitButonClickAction;

/**
 *  查看59钱包协议
 */
- (void)loadWalletProtocalVC;

@end


@interface HXSUpgradeCreditTableViewFooterView : UIView

@property (nonatomic, assign) BOOL canSubmitStatus;
@property (nonatomic, weak) id<HXSUpgradeCreditTableViewFooterViewDelegate> delegate;

@end

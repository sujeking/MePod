//
//  HXSWalletNormalView.h
//  store
//
//  Created by ArthurWang on 16/7/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSWalletNormalViewDelegate <NSObject>

@required
- (void)clickedConsumeBtn;

- (void)clickedEncashmentBtn;

- (void)clickedInstallmentBtn;

- (void)clickedUpgradeBtn;

@end

@interface HXSWalletNormalView : UIView

+ (instancetype)createWalletNormalViewWithDelegate:(id<HXSWalletNormalViewDelegate>)delegate;

@end

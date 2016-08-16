//
//  HXSWalletUpgradingView.h
//  store
//
//  Created by ArthurWang on 16/7/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSWalletUpgradingViewDelegate <NSObject>

@required
- (void)clickedConsumeBtn;

- (void)clickedEncashmentBtn;

- (void)clickedReuploadtn;

@end

@interface HXSWalletUpgradingView : UIView

+ (instancetype)createWalletUpgradingViewWithDelegate:(id<HXSWalletUpgradingViewDelegate>)delegate;

@end

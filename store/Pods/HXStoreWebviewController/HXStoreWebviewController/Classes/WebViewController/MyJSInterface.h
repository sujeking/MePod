//
//  MyJSInterface.h
//  EasyJSWebViewSample
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSWebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface MyJSInterface : NSObject

@property (nonatomic, weak) HXSWebViewController * currentViewController;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

- (void)setUpWithBridge:(WebViewJavascriptBridge *)bridge;

//return YES or NO
- (NSString *)pushViewWithUrl:(NSString *)url AndTitle:(NSString *)title;

- (NSString *)needUserLogin;

- (NSString *)closeCurrentView;
- (NSString *)pushMyCouponView;

- (NSString *)openOrderListView:(NSString *)orderType;      // 跳转订单列表页
- (NSString *)openCreditCardView;                           // 跳转花不完页面
- (NSString *)openFindPayPasswordView;                      // 跳转找回支付密码页面
- (NSString *)openCreditPayView;                            // 跳转信用钱包页面

- (NSString *)openRouter:(NSString *)url;

//pay
- (NSString *)payWithType:(NSString *)payType AndParam:(NSString *)param;

@end
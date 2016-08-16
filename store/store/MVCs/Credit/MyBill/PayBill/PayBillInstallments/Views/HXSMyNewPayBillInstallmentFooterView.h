//
//  HXSMyNewPayBillInstallmentFooterView.h
//  store
//
//  Created by J006 on 16/2/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSMyNewPayBillInstallmentFooterViewDelegate <NSObject>

@required
/**
 *  “确定分期”通知前任View
 */
- (void)confirmInstallment;
/**
 *  “59分期协议”跳转到WebView
 */
- (void)jumpToInstallmentWebView;

@end

@interface HXSMyNewPayBillInstallmentFooterView : UIView

@property (nonatomic, weak)id<HXSMyNewPayBillInstallmentFooterViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIRenderingButton      *confirmButton;
@property (weak, nonatomic) IBOutlet UIImageView            *iconImageView;
/**59分期协议*/
@property (weak, nonatomic) IBOutlet UITextView             *contractTextView;

+ (id)myNewPayBillInstallmentFooterView;

- (void)initTheView;

@end

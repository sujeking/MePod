//
//  HXSCreditOrderDetialBottomView.h
//  store
//
//  Created by ArthurWang on 16/3/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSCreditOrderDetialBottomViewDelegate <NSObject>

@required
- (void)clickCommentBtn;
- (void)clickLogisticsBtn;
- (void)clickConfirmBtn;
- (void)clickCancelBtn;
- (void)clickPayBtn;
- (void)clickPayDownPaymentBtn;
- (void)clickOneDreamDetailBtn;

@end

@interface HXSCreditOrderDetialBottomView : UIView

- (BOOL)addSubViewsWithOrderInfo:(HXSOrderInfo *)orderInfo delegate:(id<HXSCreditOrderDetialBottomViewDelegate>)delegate;

@end

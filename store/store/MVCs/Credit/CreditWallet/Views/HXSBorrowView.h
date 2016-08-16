//
//  HXSBorrowView.h
//  store
//
//  Created by hudezhi on 15/11/5.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSBalanceView.h"


@protocol HXSBorrowViewDelegate <NSObject>

@optional
- (void)gotoWalletView;  // clickedConsumeBtn

- (void)gotoEncashmentView; // clickedEncashmentBtn

- (void)gotoInsatallmentView; // clickedInstallmentBtn

- (void)gotoUpgradeView; // clickedUpgradeBtn,  clickedReuploadtn

@end

@interface HXSBorrowView : UIView

@property (weak, nonatomic) IBOutlet HXSBalanceView *balanceView;

+ (instancetype)createBorrwViewWithDelegate:(id<HXSBorrowViewDelegate>)delegate;

- (void)updateBorrowView;

@end

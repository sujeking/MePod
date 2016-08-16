//
//  HXSPayPasswordAlertView.h
//  store
//
//  Created by ArthurWang on 15/7/30.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSPayPasswordAlertView;

@protocol HXSPayPasswordAlertViewDelegate <NSObject>

@optional
- (void)alertView:(HXSPayPasswordAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex passwd:(NSString *)passwd exemptionStatus:(NSNumber *)hasSelectedExemptionBoolNum;

@end

typedef void(^PasswordBlock)(NSString *passwordStr, NSNumber *hasSelectedExemptionBoolNum);


@interface HXSPayPasswordAlertView : UIView

// Property
@property (nonatomic, weak) id<HXSPayPasswordAlertViewDelegate> customAlertViewDelegate;

@property (nonatomic, strong) NSString      *titleStr;
@property (nonatomic, strong) NSString      *messageStr;
@property (nonatomic, strong) UIButton      *leftBtn;
@property (nonatomic, strong) UIButton      *rightBtn;
@property (nonatomic, copy)   PasswordBlock leftBtnBlock;
@property (nonatomic, copy)   PasswordBlock rightBtnBlock;

@property (nonatomic, strong) NSNumber      *displayExemptionBtnBoolNum;

// Methods

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id)delegate
              leftButtonTitle:(NSString *)cancelButtonTitle
            rightButtonTitles:(NSString *)otherButtonTitle;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftButtonTitle:(NSString *)cancelButtonTitle
            rightButtonTitles:(NSString *)otherButtonTitle;


- (void)show;
- (void)close;

@end

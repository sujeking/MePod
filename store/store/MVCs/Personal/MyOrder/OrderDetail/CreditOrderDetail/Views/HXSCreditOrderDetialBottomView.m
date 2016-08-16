//
//  HXSCreditOrderDetialBottomView.m
//  store
//
//  Created by ArthurWang on 16/3/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditOrderDetialBottomView.h"

#import "HXSLineView.h"

#define WIDTH_BUTTON   120

@interface HXSCreditOrderDetialBottomView ()

@property (nonatomic, assign) id<HXSCreditOrderDetialBottomViewDelegate> delegate;
@property (nonatomic, strong) HXSOrderInfo *orderInfo;

@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *logisticsBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UIButton *payDownPaymentBtn;
@property (nonatomic, strong) UIButton *oneDreamDetailBtn;

@property (nonatomic, strong) UIView *speratorView;
@property (nonatomic, strong) HXSLineView *lineView;

@end

@implementation HXSCreditOrderDetialBottomView

- (BOOL)addSubViewsWithOrderInfo:(HXSOrderInfo *)orderInfo delegate:(id<HXSCreditOrderDetialBottomViewDelegate>)delegate
{
    self.delegate = delegate;
    self.orderInfo = orderInfo;
    
    BOOL addSubViews = NO;
    
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    // 订单状态
    switch (orderInfo.status) {
        case kHXSOrderStautsCommitted:
        {
            if (kHXSOrderTypeOneDream == orderInfo.type) {
                [self createViewWithOneDreamDetail];
            } else {
                // "未支付"
                if (kHXSOrderInfoInstallmentNO == [orderInfo.installmentIntNum integerValue]) {
                    [self createViewWithCancelAndPayButtons];
                } else {
                    [self createViewWithCancelAndPayDownPayment];
                }
            }
            
            
            addSubViews = YES;
        }
            break;
        case kHXSOrderStautsConfirmed:
            // Do nothing
            break;
        case kHXSOrderStautsSent: // "配货中"
        {
            [self createViewWithLogisticsAndConfirmButtons];
            
            addSubViews = YES;
        }
            break;
            
        case kHXSOrderStautsWaiting: // "待发货"
        {
            [self createViewWithCancelBtn];
            
            addSubViews = YES;
        }
            break;
            
        case kHXSOrderStautsDone: // "已完成"
            if ((kHXSOrderTypeInstallment == orderInfo.type)
                && (kHXSOrderCommentStatusDonot == [orderInfo.commentStatusIntNum integerValue])) {
                [self createViewWithCommentBtn];
                
                addSubViews = YES;
            } else if (kHXSOrderTypeOneDream == orderInfo.type) {
                [self createViewWithOneDreamDetail];
                
                addSubViews = YES;
            }
            
            break;
        case kHXSOrderStautsCaneled: // "已取消"
            // Do nothing
            break;
            
        default:
            break;
    }
    
    if (addSubViews) {
        [self addSubview:self.lineView];
        
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.left.right.equalTo(self);
        }];
    }
    
    return addSubViews;
}


- (void)dealloc
{
    self.delegate = nil;
}


#pragma mark - Setter Getter Methods

- (UIButton *)commentBtn
{
    if (nil == _commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setBackgroundColor:[UIColor whiteColor]];
        [_commentBtn setTitle:@"评价" forState:UIControlStateNormal];
        [_commentBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_commentBtn setTitleColor:[UIColor colorWithRGBHex:0x07A9FA] forState:UIControlStateNormal];
        [_commentBtn addTarget:self
                        action:@selector(clickCommentBtn)
              forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _commentBtn;
}

- (UIButton *)logisticsBtn
{
    if (nil == _logisticsBtn) {
        _logisticsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logisticsBtn setBackgroundColor:[UIColor whiteColor]];
        [_logisticsBtn setTitle:@"追踪物流" forState:UIControlStateNormal];
        [_logisticsBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_logisticsBtn setTitleColor:[UIColor colorWithRGBHex:0x666666] forState:UIControlStateNormal];
        [_logisticsBtn addTarget:self
                        action:@selector(clickLogisticsBtn)
              forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _logisticsBtn;
}

- (UIButton *)confirmBtn
{
    if (nil == _confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setBackgroundColor:[UIColor colorWithRGBHex:0x07A9FA]];
        [_confirmBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self
                          action:@selector(clickConfirmBtn)
                forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _confirmBtn;
}

- (UIButton *)cancelBtn
{
    if (nil == _cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_cancelBtn setTitleColor:[UIColor colorWithRGBHex:0x666666] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self
                        action:@selector(clickCancelBtn)
              forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelBtn;
}

- (UIButton *)payBtn
{
    if (nil == _payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setBackgroundColor:[UIColor colorWithRGBHex:0xF9A502]];
        [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn addTarget:self
                       action:@selector(clickPayBtn)
             forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _payBtn;
}

- (UIButton *)payDownPaymentBtn
{
    if (nil == _payDownPaymentBtn) {
        _payDownPaymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payDownPaymentBtn setBackgroundColor:[UIColor colorWithRGBHex:0xF9A502]];
        [_payDownPaymentBtn setTitle:@"支付首付" forState:UIControlStateNormal];
        [_payDownPaymentBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_payDownPaymentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payDownPaymentBtn addTarget:self
                    action:@selector(clickPayDownPaymentBtn)
          forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _payDownPaymentBtn;
}

- (UIView *)speratorView
{
    if (nil == _speratorView) {
        _speratorView = [[UIView alloc] init];
        
        [_speratorView setBackgroundColor:[UIColor colorWithRGBHex:0xE1E2E3]];
    }
    
    return _speratorView;
}

- (HXSLineView *)lineView
{
    if (nil == _lineView) {
        _lineView = [[HXSLineView alloc] init];
        
        [_lineView setBackgroundColor:[UIColor colorWithRGBHex:0xE1E2E3]];
    }
    
    return _lineView;
}

- (UIButton *)oneDreamDetailBtn
{
    if (nil == _oneDreamDetailBtn) {
        _oneDreamDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneDreamDetailBtn setBackgroundColor:[UIColor whiteColor]];
        [_oneDreamDetailBtn setTitle:@"查看参与详情" forState:UIControlStateNormal];
        [_oneDreamDetailBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_oneDreamDetailBtn setTitleColor:[UIColor colorWithRGBHex:0x666666] forState:UIControlStateNormal];
        [_oneDreamDetailBtn addTarget:self
                               action:@selector(clickOneDreamDetailBtn)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _oneDreamDetailBtn;
}


#pragma mark - Create Sub Views

- (void)createViewWithCancelAndPayButtons
{
    [self addSubview:self.speratorView];
    
    [self.speratorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@1);
        make.top.bottom.equalTo(self);
    }];
    
    [self addSubview:self.cancelBtn];
    
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH_BUTTON);
        make.top.bottom.equalTo(self);
        make.left.mas_equalTo(self.speratorView.mas_right);
    }];
    
    [self addSubview:self.payBtn];
    
    [self.payBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH_BUTTON);
        make.left.mas_equalTo(self.cancelBtn.mas_right);
        make.top.bottom.right.equalTo(self);
    }];
}

- (void)createViewWithCancelAndPayDownPayment
{
    [self addSubview:self.speratorView];
    
    [self.speratorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@1);
        make.top.bottom.equalTo(self);
    }];
    
    [self addSubview:self.cancelBtn];
    
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH_BUTTON);
        make.top.bottom.equalTo(self);
        make.left.mas_equalTo(self.speratorView.mas_right);
    }];
    
    [self addSubview:self.payDownPaymentBtn];
    
    [self.payDownPaymentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH_BUTTON);
        make.left.mas_equalTo(self.cancelBtn.mas_right);
        make.top.bottom.right.equalTo(self);
    }];
}

- (void)createViewWithCancelBtn
{
    [self addSubview:self.cancelBtn];
    
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)createViewWithLogisticsAndConfirmButtons
{
    [self addSubview:self.speratorView];
    
    [self.speratorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@1);
        make.top.bottom.equalTo(self);
    }];
    
    [self addSubview:self.logisticsBtn];
    
    [self.logisticsBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH_BUTTON);
        make.top.bottom.equalTo(self);
        make.left.mas_equalTo(self.speratorView.mas_right);
    }];
    
    [self addSubview:self.confirmBtn];
    
    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH_BUTTON);
        make.left.mas_equalTo(self.logisticsBtn.mas_right);
        make.top.bottom.right.equalTo(self);
    }];
}

- (void)createViewWithCommentBtn
{
    [self addSubview:self.commentBtn];
    
    [self.commentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)createViewWithOneDreamDetail
{
    [self addSubview:self.oneDreamDetailBtn];
    
    [self.oneDreamDetailBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Target Methods

- (void)clickCommentBtn
{
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickCommentBtn)]) {
        [self.delegate clickCommentBtn];
    }
}

- (void)clickLogisticsBtn
{
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickLogisticsBtn)]) {
        [self.delegate clickLogisticsBtn];
    }
}

- (void)clickConfirmBtn
{
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickConfirmBtn)]) {
        [self.delegate clickConfirmBtn];
    }
}

- (void)clickCancelBtn
{
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickCancelBtn)]) {
        [self.delegate clickCancelBtn];
    }
}

- (void)clickPayBtn
{
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickPayBtn)]) {
        [self.delegate clickPayBtn];
    }
}

- (void)clickPayDownPaymentBtn
{
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickPayDownPaymentBtn)]) {
        [self.delegate clickPayDownPaymentBtn];
    }
}

- (void)clickOneDreamDetailBtn
{
    if ((nil != self.delegate)
        && [self.delegate respondsToSelector:@selector(clickOneDreamDetailBtn)]) {
        [self.delegate clickOneDreamDetailBtn];
    }
}

@end

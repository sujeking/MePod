//
//  HXSLoanDetailView.h
//  store
//
//  Created by ArthurWang on 16/7/22.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSLoanDetailView : UIView

@property (weak, nonatomic) IBOutlet UIButton *loanAgreementBtn;


+ (instancetype)createLoanDetailViewWithServiceFee:(NSNumber *)serviceFeeDoubleNum
                                            amount:(NSNumber *)amountDoubleNum;

@end

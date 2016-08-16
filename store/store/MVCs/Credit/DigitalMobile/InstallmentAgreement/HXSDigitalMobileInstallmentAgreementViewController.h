//
//  HXSDigitalMobileInstallmentAgreementViewController.h
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@protocol DigitalMobileInstallmentAgreementDelegate <NSObject>

- (void)didPassPWD;

@end

@interface HXSDigitalMobileInstallmentAgreementViewController : HXSBaseViewController

@property (nonatomic,weak) id <DigitalMobileInstallmentAgreementDelegate> delegate;

@end

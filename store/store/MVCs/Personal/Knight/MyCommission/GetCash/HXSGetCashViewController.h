//
//  HXSGetCashViewController.h
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@protocol GetCashDelegate <NSObject>

- (void)getCashSuccessed;

@end

@interface HXSGetCashViewController : HXSBaseViewController

@property (nonatomic, weak) id<GetCashDelegate> delegate;

- (void)setMaxCashAmount:(NSNumber *)totalAmount;


@end

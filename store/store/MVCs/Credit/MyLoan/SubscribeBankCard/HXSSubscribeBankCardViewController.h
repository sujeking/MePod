//
//  HXSSubscribeBankCardViewController.h
//  59dorm
//
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@protocol HXSSubscribeBankCardViewControllerDelegate <NSObject>

@optional

/**
 *  下一步:填写授权信息
 */
- (void)subscribeBankNextStep;

@end

@interface HXSSubscribeBankCardViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSSubscribeBankCardViewControllerDelegate> delegate;

+ (instancetype)createSubscribeBankCardVC;

@end

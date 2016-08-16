//
//  HXSSubscribeStudentViewController.h
//  59dorm
//
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@protocol HXSSubscribeStudentViewControllerDelegate <NSObject>

@optional

/**
 *  下一步:填写银行卡信息
 */
- (void)subscribeStudentNextStep;

@end

@interface HXSSubscribeStudentViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSSubscribeStudentViewControllerDelegate> delegate;

+ (instancetype)createSubscribeStudentVC;

@end

//
//  HXSSubscribeAuthorizeViewController.h
//  59dorm
//
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@protocol HXSSubscribeAuthorizeViewControllerDelegate <NSObject>

@optional

/**
 *  正式提交开通申请
 */
- (void)subscribeAuthoruzeNextStep;

@end

@interface HXSSubscribeAuthorizeViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSSubscribeAuthorizeViewControllerDelegate> delegate;

+ (instancetype)createSubscribeAuthorizeVC;

@end

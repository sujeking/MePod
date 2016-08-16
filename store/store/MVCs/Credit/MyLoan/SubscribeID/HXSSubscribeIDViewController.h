//
//  HXSSubscribeIDViewController.h
//  59dorm
//  身份信息
//  Created by J006 on 16/7/7.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@protocol HXSSubscribeIDViewControllerDelegate <NSObject>

@optional

/**
 *  下一步:填写学籍信息
 */
- (void)subscribeIDNextStep;

@end

@interface HXSSubscribeIDViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSSubscribeIDViewControllerDelegate> delegate;

+ (instancetype)createSubscribeIDVC;

@end

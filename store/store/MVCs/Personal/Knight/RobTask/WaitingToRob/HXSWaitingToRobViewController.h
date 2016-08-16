//
//  HXSWaitingToRobViewController.h
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@protocol HXSWaitingToRobViewControllerDelegate <NSObject>

@optional

- (void)waitingToRobTableReloadFinish:(NSInteger)dataCount;

@end

@interface HXSWaitingToRobViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSWaitingToRobViewControllerDelegate> delegate;

@end

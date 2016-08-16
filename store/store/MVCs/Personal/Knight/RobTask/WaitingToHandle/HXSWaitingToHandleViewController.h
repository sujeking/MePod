//
//  HXSWaitingToHandleViewController.h
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@protocol HXSWaitingToHandleViewControllerDelegate <NSObject>

@optional
- (void)waitingToHandleTableReloadFinish:(NSInteger)dataCount;

@end

@interface HXSWaitingToHandleViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSWaitingToHandleViewControllerDelegate> delegate;

- (void)getDataCount;

@end

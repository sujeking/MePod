//
//  HXSCommunityMessageViewController.h
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

/**
 *  社区消息
 */
@interface HXSCommunityMessageViewController : HXSBaseViewController

@property (nonatomic, copy) void (^cleanNotifacationMsgBlock)();

@end

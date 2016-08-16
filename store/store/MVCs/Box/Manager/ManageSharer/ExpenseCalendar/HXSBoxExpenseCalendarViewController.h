//
//  HXSBoxExpenseCalendarViewController.h
//  store
//
//  Created by 格格 on 16/5/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSBoxUserEntity.h"

@interface HXSBoxExpenseCalendarViewController : HXSBaseViewController

@property(nonatomic, copy) void (^removeShareCompleteBlock)();

+ (instancetype)controllerWithBoxUserEntity:(HXSBoxUserEntity *)boxUserEntity
                                   boxIdNum:(NSNumber *)boxIdNum
                                 batchNoNum:(NSNumber *)batchNoNum
                                 isBoxerNum:(NSNumber *)isBoxerNum;

@end

//
//  HXSModifyBoxInfoViewController.h
//  store
//
//  Created by 格格 on 16/7/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSBoxInfoEntity.h"

@interface HXSModifyBoxInfoViewController : HXSBaseViewController

@property (nonatomic, copy) void (^transterSuccessedBlock)();

+ (instancetype)controllerWithBoxInfo:(HXSBoxInfoEntity *)boxInfoEntity messageId:(NSString *)message_id;

@end

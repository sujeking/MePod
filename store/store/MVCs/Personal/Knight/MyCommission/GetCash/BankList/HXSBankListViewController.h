//
//  HXSBankListViewController.h
//  store
//
//  Created by 格格 on 16/5/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSBankModel.h"

@interface HXSBankListViewController : HXSBaseViewController

@property (nonatomic, copy) void (^completion)(HXSBankEntity *item);


@end

//
//  HXSPrintMainViewController.h
//  store
//  打印选择主界面
//  Created by J006 on 16/5/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@interface HXSPrintMainViewController : HXSBaseViewController

+ (instancetype)createPrintVCWithShopId:(NSNumber *)shopIdIntNum;

+ (instancetype)createPrintVC;

@end

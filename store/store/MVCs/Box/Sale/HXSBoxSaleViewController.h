//
//  HXSBoxSaleViewController.h
//  store
//
//  Created by ArthurWang on 16/5/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@class HXSBoxInfoEntity;

@interface HXSBoxSaleViewController : HXSBaseViewController

+ (instancetype)createBoxSaleVCWithBoxInfo:(HXSBoxInfoEntity *)boxInfoEntity refresh:(void (^)(void))refreshBoxInfo;

- (void)refresh;

@end

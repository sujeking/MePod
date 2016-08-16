//
//  HXSShopListViewController.h
//  store
//
//  Created by ArthurWang on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@interface HXSShopListViewController : HXSBaseViewController

/**
 *
 *
 *  @param type  int 店铺类型
 *  @param name  店铺名称
 */
+ (instancetype)createDromVCWithType:(NSNumber *)typeIntNum name:(NSString *)shopTypeNameStr;

+ (instancetype)createDromVCWithType:(NSNumber *)typeIntNum
                                name:(NSString *)shopTypeNameStr
                       andPrintBlock:(void (^)(HXSShopEntity *entity))printReturnBlock;

@end

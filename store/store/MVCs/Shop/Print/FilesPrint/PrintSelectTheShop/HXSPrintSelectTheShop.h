//
//  HXSPrintSelectTheShop.h
//  store
//
//  Created by J006 on 16/5/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HXSPrintSelectTheShop : NSObject
/**
 *  如果没有店铺则弹出店铺选择界面
 *
 *  @param viewController   指定的viewcontroller
 *  @param printReturnBlock 获取店铺对象的block
 */
- (void)selectTheShopEntityAndWithVC:(UIViewController *)viewController
                       andPrintBlock:(void (^)(HXSShopEntity *entity))printReturnBlock;

@end

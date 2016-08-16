//
//  HXSUpdateWalletViewModel.h
//  store
//
//  Created by  黎明 on 16/8/1.
//  Copyright © 2016年 huanxiao. All rights reserved.
//
/************************************************************
 *  HXSUpdateWalletViewModel
 ***********************************************************/
#import <Foundation/Foundation.h>

@interface HXSUpdateWalletViewModel : NSObject

/*
 * 授权完成后，进入学籍校验接口
 */
+ (void)authorizeNextComplete:(void (^)(HXSErrorCode status, NSString *message))block
                      failure:(void(^)(NSString *errorMessage))failureBlock;

@end

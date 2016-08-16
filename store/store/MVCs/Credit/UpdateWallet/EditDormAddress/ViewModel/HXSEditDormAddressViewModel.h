//
//  HXSEditDormAddressViewModel.h
//  store
//
//  Created by  黎明 on 16/7/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//
/************************************************************
 *  编辑宿舍地址的ViewModel
 ***********************************************************/
#import <Foundation/Foundation.h>

@interface HXSEditDormAddressViewModel : NSObject

/*
 * 完善个人资料【补全宿舍地址】
 */
- (void)commitDormAddress:(NSString *)dormAddress
                 complete:(void (^)(HXSErrorCode status, NSString *message))block;
@end

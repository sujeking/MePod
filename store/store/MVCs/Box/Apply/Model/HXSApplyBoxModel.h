//
//  HXSApplyBoxModel.h
//  store
//
//  Created by ArthurWang on 16/5/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSApplyResultInfoModel.h"

#import "HXSApplyInfoEntity.h"
@interface HXSApplyBoxModel : NSObject
/**
 *  提交申请信息到服务器
 *
 *  @param model 申请人信息
 *  @param block 完成回调
 */
+ (void)commitApplyInfoToServerWithApplyInfo:(HXSApplyInfoEntity *)model
                                    complete:(void (^)(HXSErrorCode code,
                                                       NSString *message))block;

@end

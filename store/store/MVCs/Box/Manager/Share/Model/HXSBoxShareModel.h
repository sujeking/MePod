//
//  HXSBoxShareModel.h
//  store
//
//  Created by 格格 on 16/6/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSBoxShareModel : NSObject

/**
 *  分享零食盒子
 *
 *  @param name  姓名
 *  @param phone 手机
 *  @param block
 */
+ (void)shareBoxWithName:(NSString *)name phone:(NSString *)phone complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *data))block;

@end

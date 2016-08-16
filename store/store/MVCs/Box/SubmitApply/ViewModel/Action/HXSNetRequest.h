//
//  HXSNetRequest.h
//  store
//
//  Created by  黎明 on 16/6/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "HXSApplyResultInfoModel.h"

@class HXSApplyResultInfoModel;

@interface HXSNetRequest : NSObject

/**
 *  获取申请结果
 *
 *  @param block
 */
+ (void)fetchApplyResultInfoWithUid:(NSNumber *)uid complete:(void (^)(HXSErrorCode code, NSString *message, HXSApplyResultInfoModel *applyResultInfoModel))block;

@end

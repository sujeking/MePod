//
//  HXSAgreementModel.h
//  store
//
//  Created by apple on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSAgreementModel : NSObject

/*
 * 分期验证支付密码
 */
- (void)validatePayPWD:(NSString *)pwd
              Complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *result))block;

@end

//
//  HXSTarget_account.h
//  
//
//  Created by ArthurWang on 16/6/22.
//
//

#import <Foundation/Foundation.h>

@interface HXSTarget_account : NSObject

/** 获取token值 */
- (NSString *)Action_token:(NSDictionary *)paramsDic;

/** 更新token值 */
- (NSNumber *)Action_updateToken:(NSDictionary *)paramsDic;

/** 登出 */
- (NSNumber *)Action_logout:(NSDictionary *)paramsDic;

/** 获取BoxID */
- (NSNumber *)Action_boxID:(NSDictionary *)paramsDic;

@end

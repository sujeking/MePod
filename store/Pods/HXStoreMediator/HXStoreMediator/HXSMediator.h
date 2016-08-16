//
//  HXSMediator.h
//  store
//
//  Created by ArthurWang on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

/**
 *  使用说明
 *
 *  targetName 需要不带HXSTarget_ 的前缀。 在命名每个模块提供的事件Class是，需要用HXSTarget_开头。
 *
 *  actionName 需要不带Action_ 的前缀。在事件命名时，需要用Action_开头。
 */


#import <Foundation/Foundation.h>

@interface HXSMediator : NSObject

+ (instancetype)sharedInstance;

/** 远程App调用入口 */
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;

/** 本地组件调用入口 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params;

@end

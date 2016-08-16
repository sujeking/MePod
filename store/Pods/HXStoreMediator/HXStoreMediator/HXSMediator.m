//
//  HXSMediator.m
//  store
//
//  Created by ArthurWang on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMediator.h"

#define CLASS_NAME_WEB_VIEW_CONTROLLER  @"web"
#define TARGET_NAME_WEB_VIEW_CONTROLLER @"PushWebViewController"
#define KEY_URL_WEB_CONTROLLER          @"url"

@implementation HXSMediator

#pragma mark - Initial Methods

+ (instancetype)sharedInstance
{
    static HXSMediator *mediator;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[HXSMediator alloc] init];
    });
    
    return mediator;
}


#pragma mark - Public Methods

/*
 Store APP 4.0 版本没有使用远程， 结构类型也不一致
 
 scheme://[target]/[action]?[params]
 
 url sample:
 aaa://targetA/actionB?id=1234
 */

/** 远程App调用入口 */
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion
{
    if (![url.scheme isEqualToString:@"hxstore"]) {
        
        if ([url.scheme hasPrefix:@"http"]
            || [url.scheme hasPrefix:@"https"]) {
            id result = [self performTarget:CLASS_NAME_WEB_VIEW_CONTROLLER
                                     action:TARGET_NAME_WEB_VIEW_CONTROLLER
                                     params:@{KEY_URL_WEB_CONTROLLER: [url absoluteString]}];
            
            if (completion) {
                if (result) {
                    completion(@{@"result":result});
                } else {
                    completion(nil);
                }
            }
            
            return result;
        }
        
        return @(NO);
    }
    
    // 获取参数，转化为Dic
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:5];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if (2 > [elts count]) {
            continue;
        }
        
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    // 安全保护
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    
    // 调用方法
    id result = [self performTarget:url.host action:actionName params:params];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    
    return result;
}


/** 本地组件调用入口 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params
{
    NSString *targetClassString = [NSString stringWithFormat:@"HXSTarget_%@", targetName];
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
    
    Class targetClass = NSClassFromString(targetClassString);
    id target = [[targetClass alloc] init];
    SEL action = NSSelectorFromString(actionString);
    
    if (nil == target) {
        // Should display a default View
        return nil;
    }
    
    if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    } else {
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
        } else {
            return nil;
        }
    }
}

@end

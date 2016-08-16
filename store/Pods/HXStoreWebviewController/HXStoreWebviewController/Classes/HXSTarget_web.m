//
//  HXSTarget_web.m
//  store
//
//  Created by ArthurWang on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTarget_web.h"

/** webview打开url */
#import "HXSWebViewController.h"

@implementation HXSTarget_web

/** webview打开url */
// http://dddd或者https://dddd默认用webview打开  @"url" : value
- (UIViewController *)Action_PushWebViewController:(NSDictionary *)paramsDic
{
    NSString *urlStr = [paramsDic objectForKey:@"url"];
    
    HXSWebViewController *controller = [HXSWebViewController controllerFromXib];
    
    [controller setUrl:[NSURL URLWithString:urlStr]];
    
    return controller;
}

@end

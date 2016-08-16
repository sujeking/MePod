//
//  HXSTarget_web.h
//  store
//
//  Created by ArthurWang on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSTarget_web : NSObject

/** webview打开url */
// http://dddd 或者 https://dddd 默认用webview打开
- (UIViewController *)Action_PushWebViewController:(NSDictionary *)paramsDic;

@end

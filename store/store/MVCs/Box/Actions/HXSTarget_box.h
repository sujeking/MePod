//
//  HXSTarget_box.h
//  store
//
//  Created by ArthurWang on 16/4/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSTarget_box : NSObject

/** 跳转我的盒子页面 */
// hxstore://box/mybox
- (UIViewController *)Action_mybox:(NSDictionary *)paramsDic;

@end

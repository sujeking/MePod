//
//  HXSTarget_box.m
//  store
//
//  Created by ArthurWang on 16/4/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTarget_box.h"

#import "HXSBoxViewController.h"

@implementation HXSTarget_box

/** 跳转我的盒子页面 */
// hxstore://box/mybox
- (UIViewController *)Action_mybox:(NSDictionary *)paramsDic
{
    HXSBoxViewController *boxDetailVC = [HXSBoxViewController controllerFromXib];
    
    return boxDetailVC;
}

@end

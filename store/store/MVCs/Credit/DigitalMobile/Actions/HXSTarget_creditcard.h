//
//  HXSTarget_creditcard.h
//  store
//
//  Created by ArthurWang on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSTarget_creditcard : NSObject

/** 跳转分期商城页面 */
// hxstore://creditcard/tip
- (UIViewController *)Action_tip:(NSDictionary *)paramsDic;

@end

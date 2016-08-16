//
//  HXSTarget_shop.h
//  store
//
//  Created by ArthurWang on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSTarget_shop : NSObject

/** 跳转店铺列表页 */
// hxstore://shop/list?shop_type=xx&shop_type_name=xxxx
- (UIViewController *)Action_list:(NSDictionary *)paramsDic;

/** 跳转店铺详情页 */
// hxstore://shop/detail?shop_id=xxx&type=xx
- (UIViewController *)Action_detail:(NSDictionary *)paramsDic;

@end

//
//  HXSCommentViewController.h
//  store
//
//  Created by ArthurWang on 16/3/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@interface HXSCommentViewController : HXSBaseViewController

- (void)setupOrderInfo:(HXSOrderInfo *)orderInfo complete:(void (^)(void))complete;

@end

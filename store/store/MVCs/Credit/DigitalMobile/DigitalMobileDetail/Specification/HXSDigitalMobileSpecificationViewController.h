//
//  HXSDigitalMobileSpecificationViewController.h
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@interface HXSDigitalMobileSpecificationViewController : HXSBaseViewController

@property (nonatomic, strong) NSNumber *itemIDIntNum;
@property (nonatomic, copy) void (^hasPullDown)(void);

@end

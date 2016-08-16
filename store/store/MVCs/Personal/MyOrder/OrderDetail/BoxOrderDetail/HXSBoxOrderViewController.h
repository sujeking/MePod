//
//  HXSBoxOrderViewController.h
//  store
//
//  Created by ArthurWang on 15/7/26.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@interface HXSBoxOrderViewController : HXSBaseViewController

@property (nonatomic, strong) NSString *orderSNStr;
@property (nonatomic, strong) dispatch_block_t completeBlock;

@end

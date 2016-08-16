//
//  HXSMyBoxOderViewController.h
//  store
//
//  Created by ArthurWang on 15/8/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

typedef void(^updateSelectionTitle)(NSInteger index);

@interface HXSMyBoxOderViewController : HXSBaseViewController

@property (nonatomic, strong) NSNumber *typeNumber;
@property (nonatomic, copy)   updateSelectionTitle updateSelectionTitle;

@end

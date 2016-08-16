//
//  HXSDormOrderViewController.h
//  store
//
//  Created by ArthurWang on 15/7/28.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"


typedef void(^updateSelectionTitle)(NSInteger index);

@interface HXSMyEachOrderViewController : HXSBaseViewController

@property (nonatomic, strong) NSNumber *typeNumber;
@property (nonatomic, copy)   updateSelectionTitle updateSelectionTitle;

@end

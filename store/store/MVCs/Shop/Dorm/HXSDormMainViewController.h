//
//  HXSDormMainViewController.h
//  store
//
//  Created by chsasaw on 15/1/23.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@class HXSCategoryModel;

@interface HXSDormMainViewController : HXSBaseViewController

@property (nonatomic, strong) HXSCategoryModel *categoryModel;

+ (instancetype)createDromVCWithShopId:(NSNumber *)shopIdIntNum;

- (void)updateDataSource:(BOOL)isMustReload;

@end
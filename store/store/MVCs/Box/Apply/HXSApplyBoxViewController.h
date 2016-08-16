//
//  HXSApplyBoxViewController.h
//  store
//
//  Created by ArthurWang on 16/5/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@class HXSBoxInfoEntity;

@interface HXSApplyBoxViewController : HXSBaseViewController

@property (nonatomic, strong) NSString *navigationTitleStr;


+ (instancetype)createApplyBoxVCWithBoxInfo:(HXSBoxInfoEntity *)boxInfoEntity refresh:(void (^)(void))refreshBoxInfo;

- (void)refresh;

@end

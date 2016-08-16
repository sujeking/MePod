//
//  HXSSubmitApplyViewController.h
//  store
//
//  Created by ArthurWang on 16/5/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSApplyInfoEntity.h"

@class HXSBoxInfoEntity;
@class HXSApplyInfoEntity;

@interface HXSSubmitApplyViewController : HXSBaseViewController

@property (nonatomic, strong) HXSApplyInfoEntity *applyInfoEntity;

+ (instancetype)createSubmitApplyVCWithBoxInfo:(HXSBoxInfoEntity *)boxInfoEntity refresh:(void (^)(void))refreshBoxInfo;

- (void)refresh;


@end

//
//  HXSMyCommissionSectionHeader.m
//  store
//
//  Created by 格格 on 16/4/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyCommissionSectionHeader.h"

@implementation HXSMyCommissionSectionHeader

+ (id)sectionHeader
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

@end

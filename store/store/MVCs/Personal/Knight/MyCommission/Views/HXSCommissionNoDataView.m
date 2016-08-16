//
//  HXSCommissionNoDataView.m
//  store
//
//  Created by 格格 on 16/4/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommissionNoDataView.h"

@implementation HXSCommissionNoDataView

+ (id)noDataView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    
}

@end

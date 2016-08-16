//
//  HXSRobTaskNoDataView.m
//  store
//
//  Created by 格格 on 16/5/4.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSRobTaskNoDataView.h"

@implementation HXSRobTaskNoDataView

+ (id)noDataView{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class])
                                        owner:self options:nil].lastObject;
}

@end

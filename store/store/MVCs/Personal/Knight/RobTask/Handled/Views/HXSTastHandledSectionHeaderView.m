//
//  HXSTastHandledSectionHeaderView.m
//  store
//
//  Created by 格格 on 16/4/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTastHandledSectionHeaderView.h"

@implementation HXSTastHandledSectionHeaderView

+ (id)headView{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

@end

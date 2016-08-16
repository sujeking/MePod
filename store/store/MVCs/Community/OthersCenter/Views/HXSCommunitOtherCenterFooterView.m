//
//  HXSCommunitOtherCenterFooterView.m
//  store
//
//  Created by J006 on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunitOtherCenterFooterView.h"

@implementation HXSCommunitOtherCenterFooterView

#pragma mark life cycle

+ (id)communitOtherCenterFooterView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

- (void)awakeFromNib
{
}

@end

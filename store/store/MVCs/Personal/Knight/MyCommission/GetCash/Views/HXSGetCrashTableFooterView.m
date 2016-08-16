//
//  HXSGetCrashTableFooterView.m
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSGetCrashTableFooterView.h"

@implementation HXSGetCrashTableFooterView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.getCrashButton.layer.cornerRadius = 4;
}

+ (id)footerView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]lastObject];
}

@end

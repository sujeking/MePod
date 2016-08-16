//
//  HXSRootTabModel.m
//  store
//
//  Created by  黎明 on 16/8/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSRootTabModel.h"

@implementation HXSRootTabModel

@end




@interface JSONValueTransformer (HXSRootTabModel)

@end

@implementation JSONValueTransformer (HXSRootTabModel)

#pragma mark - string <-> UIColor

- (UIColor *)UIColorFromNSString:(NSString *)string
{
    return [UIColor colorWithHexString:string];
}

- (id)JSONObjectFromUIColor:(UIColor *)color
{
    return nil;
}

@end
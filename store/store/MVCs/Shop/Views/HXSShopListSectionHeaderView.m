//
//  HXSShopListSectionHeaderView.m
//  store
//
//  Created by  黎明 on 16/7/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopListSectionHeaderView.h"

@implementation HXSShopListSectionHeaderView

+ (HXSShopListSectionHeaderView *)shopListSectionHeaderView
{
    HXSShopListSectionHeaderView *shopListSectionHeaderView = [[NSBundle mainBundle] loadNibNamed:@"HXSShopListSectionHeaderView" owner:nil options:nil].firstObject;
    
    return shopListSectionHeaderView;
}


@end

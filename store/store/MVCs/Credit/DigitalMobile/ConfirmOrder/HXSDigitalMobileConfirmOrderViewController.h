//
//  HXSDigitalMobileConfirmOrderViewController.h
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@class HXSDigitalMobileParamSKUEntity;
@interface HXSDigitalMobileConfirmOrderViewController : HXSBaseViewController

- (void)initData:(HXSDigitalMobileParamSKUEntity *)paramSKUEnity andAddressInfo:(NSArray *)addressInfo;

@end

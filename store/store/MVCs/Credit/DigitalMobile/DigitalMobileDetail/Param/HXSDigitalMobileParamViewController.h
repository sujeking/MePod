//
//  HXSDigitalMobileParamViewController.h
//  store
//
//  Created by ArthurWang on 16/3/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@class HXSDigitalMobileParamSKUEntity;

typedef void(^hasSelectedSKUEntity)(HXSDigitalMobileParamSKUEntity *paramSKUEntity);

@interface HXSDigitalMobileParamViewController : HXSBaseViewController

- (void)updateItemIDIntNum:(NSNumber *)itemIDIntNum
                       sku:(HXSDigitalMobileParamSKUEntity *)skuEntity
                  complete:hasSelectedSKUEntity;

@end

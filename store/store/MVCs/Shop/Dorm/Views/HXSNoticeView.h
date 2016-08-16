//
//  HXSNoticeView.h
//  store
//
//  Created by ArthurWang on 16/1/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSShopEntity;

@interface HXSNoticeView : UIView

/**create by code*/
- (instancetype)initWithShopEntity:(HXSShopEntity *)shopEntity
                      targetMethod:(void (^)(void))sender;

/**create in Xib*/
- (instancetype)createWithShopEntity:(HXSShopEntity *)shopEntity
                        targetMethod:(void (^)(void))sender;

@end

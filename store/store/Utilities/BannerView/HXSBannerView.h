//
//  HXSBannerView.h
//  store
//
//  Created by ArthurWang on 16/1/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSStoreAppEntryEntity.h"

/**
 下单成功后的，出现的广告信息
 */
@interface HXSBannerView : UITableView

- (instancetype)initWithShopID:(NSNumber *)shopIDNum
                   dormentryID:(NSNumber *)dormentryIDNum
                         width:(CGFloat)width;

@property (nonatomic, copy) void (^loadBannerComplete)(void);
@property (nonatomic, copy) void (^didSelectedBanner)(HXSStoreAppEntryEntity *entity);

@end

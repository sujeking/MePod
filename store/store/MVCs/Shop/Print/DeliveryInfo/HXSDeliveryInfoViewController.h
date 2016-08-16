//
//  HXSDeliveryInfoViewController.h
//  store
//
//  Created by 格格 on 16/3/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
@class HXSDeliveryEntity;
@class HXSDeliveryTime;

@protocol HXSDeliveryInfoViewControllerDelegate <NSObject>

-(void)selectHXSDeliveryEntity:(HXSDeliveryEntity *)selectDeliveryEntity
                  deliveryTime:(HXSDeliveryTime *)selectDeliveryTime;

@end

@interface HXSDeliveryInfoViewController : HXSBaseViewController

@property(nonatomic,strong) NSNumber *shopIdStr;
@property(nonatomic,weak) id<HXSDeliveryInfoViewControllerDelegate>delegate;

- (void)setSelectDeliveryEntity:(HXSDeliveryEntity *)selectDeliveryEntity
             selectDeliveryTime:(HXSDeliveryTime *)selectDeliveryTime;

@end

//
//  HXSPrintSettingPrintReduceCell.h
//  store
//
//  Created by J006 on 16/3/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPrintSettingEntity.h"

typedef NS_ENUM(NSInteger, HXSPrintSettingButtonStatus){
    kHXSPrintSettingButtonStatusNormal   = 0,
    kHXSPrintSettingButtonStatusSelected = 1,
    kHXSPrintSettingButtonStatusUnable   = 2,
};

@interface HXSPrintSettingPrintReduceCell : UICollectionViewCell

@property (nonatomic, assign) HXSPrintSettingButtonStatus currentStatus;

- (void)setupCellWithPrintEntity:(HXSPrintSettingEntity *)entity
                     status:(HXSPrintSettingButtonStatus)status;

- (void)setupCellWithReduceEntity:(HXSPrintSettingReducedEntity *)entity
                           status:(HXSPrintSettingButtonStatus)status;

@end

//
//  HXSDigitalMobileParamCollectionViewCell.h
//  store
//
//  Created by ArthurWang on 16/3/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSDigitalMobileParamPropertyValueEntity;

typedef NS_ENUM(NSInteger, HXSDigitalMobileButtonStatus){
    kHXSDigitalMobileButtonStatusNormal   = 0,
    kHXSDigitalMobileButtonStatusSelected = 1,
    kHXSDigitalMobileButtonStatusUnable   = 2,
};

@interface HXSDigitalMobileParamCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) HXSDigitalMobileButtonStatus status;

- (void)setupCellWithEntity:(HXSDigitalMobileParamPropertyValueEntity *)entity status:(HXSDigitalMobileButtonStatus)status;

@end

//
//  HXSSelectCityViewController.h
//  store
//
//  Created by ranliang on 15/5/11.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@class HXSCity;

@protocol HXSCitySelectionDelegate <NSObject>

- (void)addressSelectCity:(HXSCity *)city;

@end

@interface HXSSelectCityViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSCitySelectionDelegate> delegate;
@property (nonatomic, strong) HXSCity *selectCity;

- (void)reloadData;

@end
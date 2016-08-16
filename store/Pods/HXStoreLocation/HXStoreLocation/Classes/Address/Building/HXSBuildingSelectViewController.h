//
//  HXSBuildingSelectViewController.h
//  store
//
//  Created by ArthurWang on 15/9/1.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSBuildingEntry.h"

@class HXSBuildingArea;

@protocol HXSBuildingSelectionDelegate <NSObject>

- (void)addressSelectBuilding:(HXSBuildingEntry *)building;

@end

@interface HXSBuildingSelectViewController : HXSBaseViewController

@property (nonatomic, strong) HXSBuildingArea *buildingArea;
@property (nonatomic, strong) HXSBuildingEntry *selectedBuilding;

@property (nonatomic, weak) id<HXSBuildingSelectionDelegate> delegate;

- (void)updateAddressList;

@end

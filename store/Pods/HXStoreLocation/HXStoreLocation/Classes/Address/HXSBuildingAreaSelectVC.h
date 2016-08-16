//
//  HXSBuildingAreaSelectVC.h
//  Pods
//
//  Created by 格格 on 16/7/15.
//
//

#import "HXSBaseViewController.h"

@class HXSBuildingArea,HXSCity, HXSSite;;

@protocol HXSBuildAreaSelectionDelegate <NSObject>

- (void) addressSelectBuildArea:(HXSBuildingArea *)buildingArea;

@end

@interface HXSBuildingAreaSelectVC : HXSBaseViewController

@property (nonatomic, strong) HXSSite *site;
@property (nonatomic, strong) HXSBuildingArea *selectedBuildingArea;
@property (nonatomic, weak) id<HXSBuildAreaSelectionDelegate> delegate;

- (void)updateAddressList;

@end

//
//  HXSAddressDecorationView.h
//  store
//
//  Created by hudezhi on 15/11/2.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSSelectCityViewController.h"
#import "HXSSiteSelectViewController.h"
#import "HXSBuildingAreaSelectVC.h"
#import "HXSBuildingSelectViewController.h"

#import "HXSCity.h"
#import "HXSSite.h"
#import "HXSBuildingArea.h"
#import "HXSBuildingEntry.h"

typedef NS_ENUM(NSInteger, HXSAddressSelectionType) {
    HXSAddressSelectionCity,
    HXSAddressSelectionSite,
    HXSAddressSelectionBuildingArea,
    HXSAddressSelectionBuilding,
};
@protocol HXSAddressDecorationViewDelegate <NSObject>

- (void)addressDecorationViewCurrentSelectionChange:(HXSAddressSelectionType)selectionType;

@end

@protocol HXSAddressSelectionDelegate <HXSAddressDecorationViewDelegate,HXSCitySelectionDelegate,HXSSiteSelectionDelegate,HXSBuildAreaSelectionDelegate,HXSBuildingSelectionDelegate>

@end

@interface HXSAddressDecorationView : UIScrollView

@property (strong, nonatomic) HXSCity *city;
@property (strong, nonatomic) HXSSite *site;
@property (strong, nonatomic) HXSBuildingArea *buildingArea;
@property (strong, nonatomic) HXSBuildingEntry *building;
@property (nonatomic, assign) HXSAddressSelectionType selectionDestination;

@property (nonatomic, weak) UIViewController *containerController;

- (instancetype)initWithDelegate:(id<HXSAddressSelectionDelegate>) delegate containerController:(UIViewController *)controller;
- (void)showAddressSelectionType:(HXSAddressSelectionType)type;

@end

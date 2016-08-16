//
//  HXSLocationManager.h
//  store
//
//  Created by chsasaw on 15/7/20.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXMacrosEnum.h"

@class HXSCity;
@class HXSSite;
@class HXSBuildingArea;
@class HXSBuildingEntry;
@class HXSDormNegoziante;

typedef NS_ENUM(NSInteger, HXSLocationPosition) {
    PositionNone = 0,
    
    PositionCity,
    PositionSite,
    PositionBuildingArea,
    PositionBuilding,
    PositionDorm,
    
    PositionCount,
};

//============================================================================

typedef void (^GoToDestinationCompletion)(void);

//============================================================================

@interface HXSLocationManager : NSObject

@property (nonatomic, assign) HXSLocationPosition destination;
@property (nonatomic, copy) GoToDestinationCompletion completion;

@property (nonatomic, strong) HXSCity *currentCity;
@property (nonatomic, strong) HXSSite *currentSite;
@property (nonatomic, strong) HXSBuildingArea *currentBuildingArea;
@property (nonatomic, strong) HXSBuildingEntry *buildingEntry;
@property (nonatomic, strong) HXSDormNegoziante *currentDorm;

+ (HXSLocationManager *) manager;

- (BOOL)isDormentrySelected;

// ==========================  Destination  ===============================
/*
 * @Note:  If you need access [HXSLocationManager sharedManager] in completion, make it weak,
 *         completion is a private property of HXSLocationManager.
 **/

- (void)goToDestination:(HXSLocationPosition)destination
             completion:(GoToDestinationCompletion)completion;

- (void)resetPosition:(HXSLocationPosition)position
           completion:(GoToDestinationCompletion)completion;

- (void)resetPosition:(HXSLocationPosition)position
    andViewController:(UIViewController *)vc
           completion:(void (^)(void))completion;
/**
 *  选择店长
 */
- (void)gotoSelectDormWithViewController:(UIViewController *)viewController
                              completion:(GoToDestinationCompletion)completion;


@end
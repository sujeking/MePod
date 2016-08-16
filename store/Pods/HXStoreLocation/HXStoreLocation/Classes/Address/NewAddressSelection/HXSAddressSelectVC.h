//
//  HXSAddressSelectVC.h
//  Pods
//
//  Created by 格格 on 16/7/15.
//
//

#import "HXSBaseViewController.h"

#import "HXSCity.h"
#import "HXSSite.h"
#import "HXSBuildingArea.h"
#import "HXSBuildingEntry.h"

@interface HXSAddressSelectVC : HXSBaseViewController

/** 城市 */
@property (strong, nonatomic) HXSCity           *city;
/** 学校 */
@property (strong, nonatomic) HXSSite           *site;
/** 楼区 */
@property (strong, nonatomic) HXSBuildingArea   *buildingArea;
/** 楼栋 */
@property (strong, nonatomic) HXSBuildingEntry  *building;

+ (id)controllerFromXib;

@end

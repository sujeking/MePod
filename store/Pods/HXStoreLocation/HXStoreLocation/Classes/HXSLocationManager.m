//
//  HXSLocationManager.m
//  store
//
//  Created by chsasaw on 15/7/20.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSLocationManager.h"
#import "HXSCity.h"
#import "HXSSite.h"
#import "HXSBuildingArea.h"
#import "HXSBuildingEntry.h"

#import "HXSAddressSelectVC.h"
#import "HXStoreLocation.h"
#import "HXSEntrySelectViewController.h"

#define kHXSCityInfo            @"kHXSCityInfo"
#define kHXSSiteInfo            @"kHXSSiteInfo"
#define kHXSBuildingAreaInfo    @"kHXSBuildingAreaInfo"
#define kHXSBuildingInfo        @"kHXSBuildingEntryInfo"
#define kHXSDormEntryInfo       @"kHXSDormEntryInfo"
#define kHXSDrinkEntryInfo      @"kHXSDrinkEntryInfo"
#define kHXSDormitoryInfo       @"kHXSDormitoryInfo"
#define kHXSSiteId              @"kHXSSiteId"
#define kHXSSiteName            @"kHXSSiteName"

@interface HXSLocationManager()

// ==========================  Destination  ===============================

@property(nonatomic, readonly) HXSLocationPosition currentPosition;
@property(nonatomic, readonly) HXSLocationPosition nextPosition;

@property (nonatomic, assign) BOOL hasGetLocationFromAnOther;


@end

static HXSLocationManager *_activityManager = nil;

@implementation HXSLocationManager

+ (HXSLocationManager *)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 清楚以前版本的数据
        NSDictionary *sharedManagerDic = [[NSUserDefaults standardUserDefaults] objectForKey:kSharedLocationManagerForUserDefault];
        if (nil != sharedManagerDic) {
            [[NSUserDefaults standardUserDefaults] objectForKey:kSharedLocationManagerForUserDefault];
        }
        
        NSDictionary * siteInfo = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:kHXSSiteInfo];
        if (siteInfo != nil) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHXSSiteId];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHXSSiteName];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHXSCityInfo];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHXSSiteInfo];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHXSBuildingInfo];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHXSDormEntryInfo];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHXSDormitoryInfo];
            
        }

        NSDictionary *locationManagerDic = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LOCATION_MANAGER];
        _activityManager = [[HXSLocationManager alloc] initWithDictionary:locationManagerDic];
    });

    return _activityManager;
}

+ (void)save
{
    NSDictionary *locationManagerDic = [_activityManager dictionarySavedInUserDefault];
    
    [[NSUserDefaults standardUserDefaults] setObject:locationManagerDic forKey:USER_DEFAULT_LOCATION_MANAGER];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DLog(@"-------- Save Location Info To UserDefaule: %@", locationManagerDic);
}

- (NSDictionary *)dictionarySavedInUserDefault
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    if(self.currentCity) {
        [dic setObject:[self.currentCity encodeAsDic] forKey: kHXSCityInfo];
    }
    
    if (self.currentSite) {
        [dic setObject: [self.currentSite encodeAsDic] forKey:kHXSSiteInfo];
    }
    if (self.currentBuildingArea) {
        [dic setObject: [self.currentBuildingArea encodeAsDic] forKey:kHXSBuildingAreaInfo];
    }
    
    if (self.buildingEntry) {
        [dic setObject:[self.buildingEntry encodeAsDic] forKey:kHXSBuildingInfo];
    }
    
    return dic;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self && (dictionary != nil)) {
        NSDictionary *dic = [dictionary objectForKey:kHXSCityInfo];
        if (dic.allKeys.count > 0) {
            _currentCity = [[HXSCity alloc] initWithDictionary:[dictionary objectForKey:kHXSCityInfo]];
        }
        
        dic = [dictionary objectForKey:kHXSSiteInfo];
        if (dic.allKeys.count > 0) {
            _currentSite = [[HXSSite alloc]initWithDictionary:[dictionary objectForKey:kHXSSiteInfo]];
        }
        
        dic = [dictionary objectForKey:kHXSBuildingAreaInfo];
        if (dic.allKeys.count > 0) {
            _currentBuildingArea = [HXSBuildingArea objectFromJSONObject:[dictionary objectForKey:kHXSBuildingAreaInfo]];
        }
        
        dic = [dictionary objectForKey:kHXSBuildingInfo];
        if (dic.allKeys.count > 0) {
            _buildingEntry = [[HXSBuildingEntry alloc] initWithDictionary:[dictionary objectForKey:kHXSBuildingInfo]];
        }
    }
    
    return self;
}


#pragma mark - getter/setter

- (void)setCurrentCity:(HXSCity *)currentCity {
    if(currentCity != _currentCity) {
        if(currentCity == nil || _currentCity == nil || ![_currentCity.city_id isEqual:currentCity.city_id]) {
            self.currentSite     = nil;
        }
        
        _currentCity = currentCity;
        
        [HXSLocationManager save];
        [[NSNotificationCenter defaultCenter] postNotificationName:kCityChanged object:nil];
    }
}

- (void)setCurrentSite:(HXSSite *)currentSite {
    if(currentSite != _currentSite) {
        if(currentSite == nil || _currentSite == nil || ![_currentSite.site_id isEqual:currentSite.site_id]) {
            self.buildingEntry   = nil;
        }
        
        _currentSite = currentSite;
        
        [HXSLocationManager save];
    }
}

- (void)setCurrentBuildingArea:(HXSBuildingArea *)currentBuildingArea
{
    if (currentBuildingArea != _currentBuildingArea)
    {
        if ((currentBuildingArea == nil)
            || (_currentBuildingArea == nil)
            || (![_currentBuildingArea.name isEqualToString:currentBuildingArea.name])) {
        }
        
        _currentBuildingArea = currentBuildingArea;
        
        [HXSLocationManager save];
    }
}

- (void)setBuildingEntry:(HXSBuildingEntry *)buildingEntry
{
    if (buildingEntry != _buildingEntry)
    {
        if ((buildingEntry == nil)
            || (_buildingEntry == nil)
            || (![_buildingEntry.nameStr isEqualToString:buildingEntry.nameStr])
            || (![_buildingEntry.buildingNameStr isEqualToString:buildingEntry.buildingNameStr])) {
        }
        
        _buildingEntry = buildingEntry;
        
        [HXSLocationManager save];
    }
}


#pragma mark - quick getter

- (BOOL)hasCity
{
    return (self.currentCity.city_id.intValue > 0);
}

- (BOOL)hasSite
{
    return (self.currentSite.site_id.intValue > 0);
}

- (BOOL)hasBuildingArea
{
    return (self.currentBuildingArea != nil);
    return YES;
}

- (BOOL)hasBuilding
{
    return (self.buildingEntry.nameStr.length > 0);
}


#pragma mark - Readonly Getter

// Used to select position
- (HXSLocationPosition)currentPosition
{
    if( ![self hasCity] ) {
        return PositionNone;
    } else if( ![self hasSite] ) {
        return PositionCity;
    } else if(![self hasBuildingArea]){
        return PositionSite;
    } else if ( ![self hasBuilding] ) {
        return PositionBuildingArea;
    }
    return PositionBuilding;
}

// Also readonly, if make it public
- (HXSLocationPosition)nextPosition
{
    int current = (int)self.currentPosition;
    int count = (int)PositionCount;
    
    return (current + 1)%count;
}

//============================================================================================

- (void)goToDestination:(HXSLocationPosition)destination completion:(void (^)(void))completion
{
    [self goToDestinationInSingleView:destination completion:completion];
}

- (void)resetPosition:(HXSLocationPosition)position
    andViewController:(UIViewController *)vc
           completion:(void (^)(void))completion
{
    [self resetPositionInSingleView:position andViewController:vc completion:completion];
}

- (void)resetPosition:(HXSLocationPosition)position completion:(GoToDestinationCompletion)completion
{    
    [self resetPositionInSingleView:position completion:completion];
}

- (void)gotoSelectDormWithViewController:(UIViewController *)viewController completion:(GoToDestinationCompletion)completion{
    HXSEntrySelectViewController *vc = [HXSEntrySelectViewController controllerFromXibWithModuleName:@"HXStoreLocation"];
    vc.completionBlock = completion;
    
    if(viewController.navigationController){
        [viewController.navigationController pushViewController:vc animated:YES];
    }
}

// ================================================================================================================================
// 新的选择地址界面

- (void)selectPositionInSingleView:(HXSLocationPosition)destination completion:(GoToDestinationCompletion)completion locationMgr:(HXSLocationManager *)mgr
{
    HXSAddressSelectVC *vc = [HXSAddressSelectVC controllerFromXibWithModuleName:@"HXStoreLocation"];
    vc.city     = mgr.currentCity;
    vc.site     = mgr.currentSite;
    vc.buildingArea = mgr.currentBuildingArea;
    vc.building = mgr.buildingEntry;
    
    HXSBaseNavigationController *nav = [[HXSBaseNavigationController alloc] initWithRootViewController:vc];
        
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)selectPositionInSingleView:(HXSLocationPosition)destination
                 andViewController:(UIViewController *)viewController
                        completion:(GoToDestinationCompletion)completion
                       locationMgr:(HXSLocationManager *)mgr
{
    HXSAddressSelectVC *vc = [HXSAddressSelectVC controllerFromXibWithModuleName:@"HXStoreLocation"];
    vc.city     = mgr.currentCity;
    vc.site     = mgr.currentSite;
    vc.buildingArea = mgr.currentBuildingArea;
    vc.building = mgr.buildingEntry;
    
    HXSBaseNavigationController *nav = [[HXSBaseNavigationController alloc] initWithRootViewController:vc];
    
    [viewController presentViewController:nav animated:YES completion:nil];
}

- (void)goToDestinationInSingleView:(HXSLocationPosition)destination completion:(GoToDestinationCompletion)completion
{
    
    if(destination > PositionBuilding){
        return;
    }
    
    HXSLocationManager * dst = [HXSLocationManager manager];
    
    if(dst.currentPosition >= destination) {
        if (completion) {
            completion();
        }
        
        return;
    }
    
    self.destination = destination;
    self.completion = completion;
    [self selectPositionInSingleView:destination completion:completion locationMgr:dst];
}

- (void)resetPositionInSingleView:(HXSLocationPosition)position
                andViewController:(UIViewController *)viewController
                       completion:(GoToDestinationCompletion)completion
{
    if(position > PositionBuilding){
        return;
    }
    
    self.destination = position;
    self.completion = completion;
    [self selectPositionInSingleView:position
                   andViewController:viewController
                          completion:completion
                         locationMgr:[HXSLocationManager manager]];
}

- (void)resetPositionInSingleView:(HXSLocationPosition)position completion:(GoToDestinationCompletion)completion
{
    if(position > PositionBuilding){
        return;
    }
    
    self.destination = position;
    self.completion = completion;
    [self selectPositionInSingleView:position completion:completion locationMgr:[HXSLocationManager manager]];
}

@end
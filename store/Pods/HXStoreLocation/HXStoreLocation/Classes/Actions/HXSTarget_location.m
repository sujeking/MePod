//
//  HXSTarget_location.m
//  Pods
//
//  Created by ArthurWang on 16/6/22.
//
//

#import "HXSTarget_location.h"

#import "HXSLocationManager.h"
#import "HXSSite.h"
#import "HXSCity.h"
#import "HXSBuildingEntry.h"

@implementation HXSTarget_location

- (NSNumber *)Action_siteID:(NSDictionary *)paramsDic
{
    NSNumber *siteIDIntNum = [HXSLocationManager manager].currentSite.site_id;
    
    return siteIDIntNum;
}

- (NSNumber *)Action_cityID:(NSDictionary *)paramsDic
{
    NSNumber *cityIDIntNum = [HXSLocationManager manager].currentCity.city_id;
    
    return cityIDIntNum;
}

- (NSNumber *)Action_dormentryID:(NSDictionary *)paramsDic
{
    NSNumber *dormentryIDIntNum = [HXSLocationManager manager].buildingEntry.dormentryIDNum;
    
    return dormentryIDIntNum;
}


@end

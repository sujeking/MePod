//
//  HXSAddressModel.m
//  store
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSAddressModel.h"

#import "HXSBuildingEntity.h"
#import "HXStoreWebService.h"
#import "HXMacrosUtils.h"
#import "HXSBuildingArea.h"


@implementation HXSAddressModel

- (void)fetchAllBuilding:(NSNumber *)zoneId
            WithComplete:(void (^)(HXSErrorCode code, NSString *message, NSArray *zoneList))block
{
    NSMutableDictionary *paramMDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys: zoneId, @"site_id", nil];
    
    [HXStoreWebService getRequest:HXS_LOCATION_DORMENTRY_LIST
                parameters:paramMDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError == status) {
                           
                           NSArray *buildingArr = nil;
                           if (DIC_HAS_ARRAY(data, @"groups")) {
                               buildingArr = [HXSBuildingArea arrayOfModelsFromDictionaries:[data objectForKey:@"groups"] error:nil];
                           }
                           block(status, msg, buildingArr);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

- (void)fetchAllZones:(NSNumber *)siteId
             complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *zoneList))block{
    NSDictionary *prama = @{@"site_id":siteId};
    [HXStoreWebService getRequest:HXS_LOCATION_ZONE_LIST
                       parameters:prama progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError == status) {
                                  
                                  NSMutableArray *zonesArr = [NSMutableArray array];
                                  if (DIC_HAS_ARRAY(data, @"groups")) {
                                      NSArray *arr = [data objectForKey:@"groups"];
                                      for(NSDictionary *dic in arr){
                                          HXSBuildingArea *temp = [HXSBuildingArea objectFromJSONObject:dic];
                                          [zonesArr addObject:temp];
                                      }
                                  }
                                  block(status, msg, zonesArr);
                              } else {
                                  block(status, msg, nil);
                              }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
    }];
}
@end

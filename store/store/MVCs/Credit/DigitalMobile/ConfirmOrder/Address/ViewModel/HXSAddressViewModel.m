//
//  HXSAddressViewModel.m
//  store
//
//  Created by ArthurWang on 16/6/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSAddressViewModel.h"

#import "HXSAddressEntity.h"
#import "HXSDigitalMobileAddressEntity.h"
#import "HXSBuildingEntity.h"

@implementation HXSAddressViewModel

- (void)fetchAddressWithComplete:(void (^)(HXSErrorCode code, NSString *message, HXSAddressEntity *addressInfo))block
{
    NSString *deviceToken = [HXSUserAccount currentAccount].strToken;
    NSDictionary *paramDic = @{SYNC_USER_TOKEN:deviceToken};
    
    [HXStoreWebService getRequest:HXS_TIP_ADDRESS_GET_ADDRESS
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       HXSAddressEntity *addressEntity = nil;
                       if (data.allKeys.count != 0) {
                           addressEntity = [[HXSAddressEntity alloc] initWithDictionary:data];
                       }
                       
                       block(status, msg, addressEntity);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

- (void)fetchAddressTownWithCountry:(NSNumber *)townId WithComplete:(void (^)(HXSErrorCode code, NSString *message, NSArray *streeList))block
{
    NSDictionary *paramsDic = @{@"country_id":townId};
    
    [HXStoreWebService getRequest:HXS_TIP_ADDRESS_GET_TOWN
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       NSArray *townArr = nil;
                       if (DIC_HAS_ARRAY(data, @"towns")) {
                           townArr = [HXSDigitalMobileTownAddressEntity createAddressTownWithTownArr:[data objectForKey:@"towns"]];
                       }
                       
                       block(status, msg, townArr);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

- (void)fetchAllSchoolWithFirstAddress:(NSString *)firstAddressStr
                         secondAddress:(NSString *)secondAddressStr
                              complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *schoolList))block;
{
    NSDictionary *paramsDic = @{
                                @"first_address":firstAddressStr,
                                @"second_address":secondAddressStr,
                                };
    
    [HXStoreWebService getRequest:HXS_TIP_ADDRESS_GET_ZONE_SITE_LIST
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           NSMutableArray *schoolList = [[NSMutableArray alloc] init];
                           
                           NSArray *zones = [data valueForKey:@"zones"];
                           for (NSDictionary *zone in zones) {
                               NSArray *sites = [zone valueForKey:@"sites"];
                               
                               for (NSDictionary *siteInfo in sites) {
                                   HXSSite * site = [[HXSSite alloc] initWithDictionary:siteInfo];
                                   [schoolList addObject:site];
                               }
                           }
                           
                           
                           block(kHXSNoError, msg, schoolList);
                       }else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

- (void)saveAddressInfo:(HXSAddressEntity *)addressInfo Complete:(void (^)(HXSErrorCode code, NSString *message, HXSAddressEntity *addressInfo))block
{
    NSString *deviceToken = [HXSUserAccount currentAccount].strToken;
    NSMutableDictionary *paramDic = [addressInfo getDictionary];
    [paramDic setObject:deviceToken forKey:SYNC_USER_TOKEN];
    
    [HXStoreWebService postRequest:HXS_TIP_ADDRESS_POST_ADDRESS
                 parameters:paramDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (kHXSNoError != status) {
                            block(status, msg, nil);
                            
                            return ;
                        }
                        
                        HXSAddressEntity *addressEntity = [[HXSAddressEntity alloc] initWithDictionary:data];
                        
                        block(status, msg, addressEntity);
                        
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, nil);
                    }];
    
}

- (void)fetchAllBuilding:(NSNumber *)siteId WithComplete:(void (^)(HXSErrorCode code, NSString *message, NSArray *buildingList))block
{
    NSMutableDictionary *paramMDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys: siteId, @"site_id", nil];
    
    [HXStoreWebService getRequest:HXS_DORMENTRY_LIST
                parameters:paramMDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError == status) {
                           
                           NSArray *buildingArr = nil;
                           if (DIC_HAS_ARRAY(data, @"groups")) {
                               buildingArr = [HXSBuildingEntity createBuildingEntityWithGroupsArr:[data objectForKey:@"groups"]];
                           }
                           
                           block(status, msg, buildingArr);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

@end

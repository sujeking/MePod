//
//  HXSSiteListRequest.m
//  store
//
//  Created by chsasaw on 14/10/28.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSSiteListRequest.h"

#import "HXSCity.h"
#import "HXSSite.h"
#import "HXSZone.h"
#import "HXMacrosUtils.h"


@interface HXSSiteListRequest ()

@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation HXSSiteListRequest

- (void)getCityListWithToken:(NSString *)token
                    complete:(void (^)(HXSErrorCode, NSString *, NSArray *))block
{
    if (token == nil) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    [HXStoreWebService getRequest:HXS_CITY_LIST
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           
                           NSMutableArray * cities = [NSMutableArray array];
                           NSMutableArray * recommendCities = [NSMutableArray array];
                           if(DIC_HAS_ARRAY(data, @"recommend_cities")) {
                               NSArray * recommendDatas = [data objectForKey:@"recommend_cities"];
                               for(NSDictionary * dic in recommendDatas) {
                                   HXSCity * city = [[HXSCity alloc] initWithDictionary:dic];
                                   if(city) {
                                       [recommendCities addObject:city];
                                   }
                               }
                           }
                           
                           if(DIC_HAS_ARRAY(data, @"city_group")) {
                               NSArray * allCitiesArray = [data objectForKey:@"city_group"];
                               for (NSDictionary *cityGroup in allCitiesArray) {
                                   NSArray *citiesArrayForLetter = [cityGroup objectForKey:@"cities"];
                                   
                                   NSMutableArray *groupCities = [NSMutableArray array];
                                   for (NSDictionary *dic in citiesArrayForLetter) {
                                       HXSCity *city = [[HXSCity alloc] initWithDictionary:dic];
                                       city.sectionTitle = [cityGroup objectForKey:@"initial"];
                                       [groupCities addObject:city];
                                   }
                                   
                                   if (groupCities.count > 0) {
                                       [cities addObject:groupCities];
                                   }
                               }
                           }
                           
                            block(kHXSNoError, msg, @[recommendCities, cities]);
                       }else {
                            block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                   }];
}


- (void)getSiteListWithToken:(NSString *)token
                   onlyStore:(BOOL)onlyStore
                      cityId:(NSNumber *)cityId
                    complete:(void (^)(HXSErrorCode, NSString *, NSArray *))block
{
    if (token == nil || cityId == nil) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:cityId forKey:@"city_id"];
    [dic setObject:@(onlyStore) forKey:@"store_only"];
    
    [HXStoreWebService getRequest:HXS_CITY_SITE_LIST
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           NSMutableArray * zones = [NSMutableArray array];
                           NSArray * datas = [data objectForKey:@"zones"];
                           for(NSDictionary * dic in datas) {
                               HXSZone * zone = [[HXSZone alloc] initWithDictionary:dic];
                               if(zone) {
                                   [zones addObject:zone];
                               }
                           }
                            block(kHXSNoError, msg, zones);
                       } else {
                            block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

- (void)searchSiteListWithToken:(NSString *)token
                       keywords:(NSString *)keywords
                       complete:(void (^)(HXSErrorCode, NSString *, NSArray *))block
{
    if (token == nil) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    if (keywords == nil) {
        block(kHXSParamError, @"请填写内容", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:keywords forKey:@"keywords"];
    
    [HXStoreWebService getRequest:HXS_SITE_SEARCH
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           NSMutableArray * sites = [NSMutableArray array];
                           NSArray * datas = [data objectForKey:@"sites"];
                           for(NSDictionary * dic in datas) {
                               if(NULL == dic || nil == dic || [dic isKindOfClass:[NSNull class]])
                                   continue;
                               
                               HXSSite * site = [[HXSSite alloc] initWithDictionary:dic];
                               if(site) {
                                   [sites addObject:site];
                               }
                           }
                            block(kHXSNoError, msg, sites);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

- (void)postionSiteListWithToken:(NSString *)token
                        latitude:(double)latitude
                       longitude:(double)longitude
                        complete:(void (^)(HXSErrorCode, NSString *, NSArray *))block
{
    if (token == nil) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:[NSString stringWithFormat:@"%3.5f", latitude] forKey:@"latitude"];
    [dic setObject:[NSString stringWithFormat:@"%3.5f", longitude] forKey:@"longitude"];
    
    [HXStoreWebService getRequest:HXS_SITE_POSITION
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           NSMutableArray * sites = [NSMutableArray array];
                           NSArray * datas = [data objectForKey:@"sites"];
                           for(NSDictionary * dic in datas) {
                               if(NULL == dic || nil == dic || [dic isKindOfClass:[NSNull class]])
                                   continue;
                               
                               HXSSite * site = [[HXSSite alloc] initWithDictionary:dic];
                               if(site) {
                                   [sites addObject:site];
                               }
                           }
                            block(kHXSNoError, msg, sites);
                       } else {
                            block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}


- (void)cancel
{
    if (nil != self.task) {
        [self.task cancel];
        
        self.task = nil;
    }
}




@end
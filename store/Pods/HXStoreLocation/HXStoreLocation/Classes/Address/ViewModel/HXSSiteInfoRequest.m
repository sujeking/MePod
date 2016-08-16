//
//  HXSSiteInfoRequest.m
//  store
//
//  Created by chsasaw on 14/11/21.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSSiteInfoRequest.h"
#import "HXSSite.h"
#import "HXSCity.h"

@implementation HXSSiteInfoRequest

- (void)getSiteInfoWithToken:(NSString *)token
                      siteId:(NSNumber *)site_id
                    complete:(void (^)(HXSErrorCode, NSString *, HXSSite *))block
{
    if (token == nil || site_id == nil) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:site_id forKey:SYNC_SITE_ID];

    
    [HXStoreWebService getRequest:HXS_SITE_INFO
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == 0) {
                           HXSSite * site = [[HXSSite alloc] initWithDictionary:data];
                            block(kHXSNoError, msg, site);
                       } else {
                            block(kHXSNormalError, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

- (void)seletSite:(NSNumber *)site_id
        withToken:(NSString *)token
         complete:(void (^)(HXSErrorCode, NSString *, HXSSite *))block
{
    if (token == nil || site_id == nil) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:site_id forKey:SYNC_SITE_ID];
    
    [HXStoreWebService postRequest:HXS_SITE_SELECT
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == kHXSNoError) {
                            HXSSite * site = [[HXSSite alloc] initWithDictionary:data];
                                block(kHXSNoError, msg, site);
                        } else {
                                block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block( status, msg, nil);
                    }];
    
}

- (void)fetchCityDetialInfoOfSite:(NSNumber *)site_id
                         complete:(void (^)(HXSErrorCode code, NSString * message, HXSCity * city))block{
    
    NSDictionary *prama = @{@"site_id":site_id};
    [HXStoreWebService getRequest:HXS_SITE_INFO
                       parameters:prama
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              
                            if(status == kHXSNoError) {
                                // Because the return data is site data, so have to set one by one
                                // Don't want to write the interface any more, this is the server developer's job
                                HXSCity *city = [[HXSCity alloc] init];
                                
                                city.name         = [data objectForKey:@"city_name"];
                                city.city_id      = [data objectForKey:@"city_id"];
                                city.spell_short  = [data objectForKey:@"city_spell_short"];
                                city.spell_all    = [data objectForKey:@"city_spell_all"];
                                city.provinceId   = [data objectForKey:@"province_id"];
                                city.provinceName = [data objectForKey:@"province_name"];
                                
                                block(status,msg,city);
                            } else {
                                block(status,msg,nil);
                            }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

@end

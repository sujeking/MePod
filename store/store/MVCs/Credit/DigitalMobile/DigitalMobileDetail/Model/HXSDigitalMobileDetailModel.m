//
//  HXSDigitalMobileDetailModel.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileDetailModel.h"

@implementation HXSDigitalMobileDetailModel

- (void)fetchItemDetailWithItemID:(NSNumber *)itemIDIntNum
                         complete:(void (^)(HXSErrorCode status, NSString *message, HXSDigitalMobileDetailEntity *entity))block
{
    NSDictionary *paramsDic = @{@"item_id":itemIDIntNum};
    
    [HXStoreWebService getRequest:HXS_TIP_ITEM_DETAIL
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       HXSDigitalMobileDetailEntity *entity = [HXSDigitalMobileDetailEntity createMobileDetailEntityWithDic:data];
                       
                       block(status, msg, entity);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

- (void)fetchAddressProvince:(void (^)(HXSErrorCode status, NSString *message, NSArray *addressArr))block
{
    NSDictionary *paramsDic = [[NSDictionary alloc] init];
    
    [HXStoreWebService getRequest:HXS_TIP_ADDRESS_GET_PROVINCE
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       NSMutableArray *provincesMArr = [[NSMutableArray alloc] initWithCapacity:5];
                       if (DIC_HAS_ARRAY(data, @"provinces")) {
                           NSArray *tempArr = [data objectForKey:@"provinces"];
                           
                           for (NSDictionary *dic in tempArr) {
                               HXSDigitalMobileAddressEntity *entity = [HXSDigitalMobileAddressEntity createAddressProvinceWithDic:dic];
                               
                               [provincesMArr addObject:entity];
                           }
                       }
                       
                       block(status, msg, provincesMArr);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}


/**
 *  分期购二级地址信息
 *
 *  @param block  返回结果
 */
- (void)fetchAddressCityWithProvice:(NSNumber *)proviceIDIntNum
                          completed:(void (^)(HXSErrorCode status, NSString *message, NSArray *addressArr))block
{
    NSDictionary *paramsDic = @{@"province_id":proviceIDIntNum};
    
    [HXStoreWebService getRequest:HXS_TIP_ADDRESS_GET_CITY
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       NSMutableArray *citiesMArr = [[NSMutableArray alloc] initWithCapacity:5];
                       if (DIC_HAS_ARRAY(data, @"cities")) {
                           NSArray *tempArr = [data objectForKey:@"cities"];
                           
                           for (NSDictionary *dic in tempArr) {
                               HXSDigitalMobileCityAddressEntity *entity = [HXSDigitalMobileCityAddressEntity createAddressCityWithDic:dic];
                               
                               [citiesMArr addObject:entity];
                           }
                       }
                       
                       block(status, msg, citiesMArr);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

/**
 *  分期购三级地址信息
 *
 *  @param block  返回结果
 */
- (void)fetchAddressCountryWithCity:(NSNumber *)cityIDIntNum
                          completed:(void (^)(HXSErrorCode status, NSString *message, NSArray *addressArr))block
{
    NSDictionary *paramsDic = @{@"city_id":cityIDIntNum};
    
    [HXStoreWebService getRequest:HXS_TIP_ADDRESS_GET_COUNTRY
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       NSMutableArray *countryMArr = [[NSMutableArray alloc] initWithCapacity:5];
                       if (DIC_HAS_ARRAY(data, @"countries")) {
                           NSArray *tempArr = [data objectForKey:@"countries"];
                           
                           for (NSDictionary *dic in tempArr) {
                               HXSDigitalMobileCountryAddressEntity *entity = [HXSDigitalMobileCountryAddressEntity createAddressCountryWithDic:dic];
                               
                               [countryMArr addObject:entity];
                           }
                       }
                       
                       block(status, msg, countryMArr);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}


@end

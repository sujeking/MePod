//
//  HXSShopModel.m
//  store
//
//  Created by ArthurWang on 16/1/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopModel.h"

#import "HXStoreWebService.h"
#import "HXMacrosUtils.h"

@implementation HXSShopModel

#pragma mark - Public Methods

- (void)fetchShopListWithSiteId:(NSNumber *)siteIdIntNum
                      dormentry:(NSNumber *)dormentryIDIntNum
                           type:(NSNumber *)typeIntNum
                  crossBuilding:(NSNumber *)isCrossBuilding
                       complete:(void (^)(HXSErrorCode, NSString *, NSArray *))block
{
    NSDictionary *paramsDic = @{
                                @"site_id":         siteIdIntNum,
                                @"dormentry_id":    dormentryIDIntNum,
                                @"type":            typeIntNum,
                                @"cross_building":  isCrossBuilding
                                };
    
    
    [HXStoreWebService getRequest:HXS_SHOP_LIST
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);                           
                           return ;
                       }
                       
                       if (DIC_HAS_ARRAY(data, @"shops")) {
                           NSArray *shopsArr = [data objectForKey:@"shops"];
                           
                           NSMutableArray *shopsMArr = [[NSMutableArray alloc] initWithCapacity:5];
                           
                           for (NSDictionary *dic in shopsArr) {
                               
                               HXSShopEntity *entity = [HXSShopEntity createShopEntiryWithData:dic];
                               
                               [shopsMArr addObject:entity];
                           }
                           
                           block(status, msg, shopsMArr);
                       } else {
                           block(status, msg, nil);
                       }
                       
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
    
}


@end

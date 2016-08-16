//
//  HXSShopViewModel.m
//  store
//
//  Created by ArthurWang on 16/1/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopViewModel.h"
// Controllers
#import "HXSWebViewController.h"
#import "HXSDormMainViewController.h"
#import "HXSMessageCenterViewController.h"
#import "HXSPrintMainViewController.h"
// Model
#import "HXSSlideItem.h"
// Views
#import "HXSAddressDecorationView.h"

@implementation HXSShopViewModel


#pragma mark - Public Methods

- (void)loadDromViewControllerWithShopEntity:(HXSShopEntity *)model from:(UIViewController *)superViewController
{
    HXSDormMainViewController *mainVC = [HXSDormMainViewController createDromVCWithShopId:model.shopIDIntNum];
    [superViewController.navigationController pushViewController:mainVC animated:YES];
}

- (void)loadDrinkViewControllerWithShopEntity:(HXSShopEntity *)model from:(UIViewController *)superViewController
{
    
}

- (void)loadPrintViewControllerWithShopEntity:(HXSShopEntity *)model from:(UIViewController *)superViewController
{
    HXSPrintMainViewController *printVC = [HXSPrintMainViewController createPrintVCWithShopId:model.shopIDIntNum];
    [superViewController.navigationController pushViewController:printVC animated:YES];
}

- (void)loadWebViewControllerWith:(NSURL *)urlStr from:(UIViewController *)superViewController
{
    HXSWebViewController *webViewController = [HXSWebViewController controllerFromXib];
    webViewController.url = urlStr;
    [superViewController.navigationController pushViewController:webViewController animated:YES];
}


#pragma mark - Net Request

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


- (void)fetchShopInfoWithSiteId:(NSNumber *)siteIdIntNum
                       shopType:(NSNumber *)shopTypeNum
                    dormentryId:(NSNumber *)dormentryIdIntNum
                         shopId:(NSNumber *)shopIDIntNum
                       complete:(void (^)(HXSErrorCode status, NSString *message, HXSShopEntity *shopEntity))block;
{
    NSDictionary *paramsDic = @{
                                @"site_id":siteIdIntNum,
                                @"shop_type":shopTypeNum,
                                @"dormentry_id":dormentryIdIntNum,
                                @"shop_id":shopIDIntNum,
                                };
    
    [HXStoreWebService getRequest:HXS_SHOP_INFO
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       HXSShopEntity *entity = [HXSShopEntity createShopEntiryWithData:data];
                       
                       block(status, msg, entity);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

- (void)fetchStoreAppEntriesWithSiteId:(NSNumber *)siteIdIntNum
                                  type:(NSNumber *)typeIntNum
                              complete:(void (^)(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr))block
{    
    NSDictionary *paramsDic = @{
                                @"site_id":     siteIdIntNum,
                                @"type":        typeIntNum,
                                };
    
    [HXStoreWebService getRequest:HXS_STORE_INLET
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       NSMutableArray *resultMArr = [[NSMutableArray alloc] initWithCapacity:5];
                       
                       if (DIC_HAS_ARRAY(data, @"inlets")) {
                           NSArray *entriesArr = [data objectForKey:@"inlets"];
                           
                           for (NSDictionary *dic in entriesArr) {
                               HXSStoreAppEntryEntity *entity = [HXSStoreAppEntryEntity createStoreAppEntryEntityWithDic:dic];
                               
                               [resultMArr addObject:entity];
                           }
                       }
                       
                       block(status, msg, resultMArr);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {                       
                       block(status, msg, nil);
                   }];
}


@end

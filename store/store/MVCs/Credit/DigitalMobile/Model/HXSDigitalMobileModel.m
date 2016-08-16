//
//  HXSDigitalMobileModel.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileModel.h"

#import "HXSSlideItem.h"

@implementation HXSDigitalMobileModel

- (void)fetchCreditlayoutWithCityID:(NSNumber *)cityIDNum
                               type:(NSNumber *)typeIntNum
                           complete:(void (^)(HXSErrorCode status, NSString *message, HXSCreditEntity *creditLayoutEntity))block
{
    NSDictionary *paramsDic = @{
                                @"city_id": cityIDNum,
                                @"type":    typeIntNum,
                                };
    
    [HXStoreWebService getRequest:HXS_CREDIT_LAYOUT
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           return;
                       }
                       
                       HXSCreditEntity *creditEntity = [HXSCreditEntity initWithDictionary:data];
                       
                       block(status, msg, creditEntity);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

- (void)fetchTipSlideWithCityID:(NSString *)cityIDStr
                       complete:(void (^)(HXSErrorCode, NSString *, NSArray *))block
{
    NSDictionary *paramsDic = @{@"city_id": cityIDStr};
    
    [HXStoreWebService getRequest:HXS_TIP_SLIDE
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           NSMutableArray * slideItems = [[NSMutableArray alloc] initWithCapacity:5];
                           
                           if([data isKindOfClass:[NSDictionary class]] && DIC_HAS_ARRAY(data, @"slides")) {
                               NSArray * slides = [data objectForKey:@"slides"];
                               
                               for(NSDictionary * dic in slides) {
                                   HXSSlideItem * item = (HXSSlideItem *)[HXSItemBase itemWithServerDic:dic itemType:ITEM_TYPE_SLIDE];
                                   [slideItems addObject:item];
                               }
                           }
                           block( kHXSNoError, msg, slideItems);
                       }else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

- (void)fetchTipCategoryList:(void (^)(HXSErrorCode status, NSString *message, NSArray *categoryListArr))block
{
    NSDictionary *paramsDic = [[NSDictionary alloc] init];
    
    [HXStoreWebService getRequest:HXS_TIP_CATEGORY_LIST
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       NSMutableArray *categoriesMArr = [[NSMutableArray alloc] initWithCapacity:5];
                       if (DIC_HAS_ARRAY(data, @"categories")) {
                           NSArray *listArr = [data objectForKey:@"categories"];
                           for (NSDictionary *dic in listArr) {
                               HXSDigitalMobileCategoryListEntity *entity = [HXSDigitalMobileCategoryListEntity createDigitalMobileCategoryListWithDic:dic];
                               
                               [categoriesMArr addObject:entity];
                           }
                       }
                       
                       block(status, msg, categoriesMArr);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

- (void)fetchTipItemListWithCategoryID:(NSNumber *)categoryIDIntNum
                              complete:(void (^)(HXSErrorCode status, NSString *message, NSArray *itemsArr))block
{
    NSDictionary *paramsDic = @{
                                @"category_id": categoryIDIntNum,
                                };
    
    [HXStoreWebService getRequest:HXS_TIP_ITEM_LIST
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       NSMutableArray *itemMArr = [[NSMutableArray alloc] initWithCapacity:5];
                       if (DIC_HAS_ARRAY(data, @"items")) {
                           NSArray *itemArr = [data objectForKey:@"items"];
                           
                           for (NSDictionary *dic in itemArr) {
                               HXSDigitalMobileItemListEntity *entity = [HXSDigitalMobileItemListEntity createDigitalMobileItemListWithDic:dic];
                               
                               [itemMArr addObject:entity];
                           }
                       }
                       
                       block(status, msg, itemMArr);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

- (void)fetchHotItems:(void (^)(HXSErrorCode status, NSString *message, NSArray *itemsArr))block
{
    NSDictionary *paramsDic = [[NSDictionary alloc] init];
    
    [HXStoreWebService getRequest:HXS_TIP_ITEM_HOTITEMS
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       NSMutableArray *itemMArr = [[NSMutableArray alloc] initWithCapacity:5];
                       if (DIC_HAS_ARRAY(data, @"items")) {
                           NSArray *itemArr = [data objectForKey:@"items"];
                           
                           for (NSDictionary *dic in itemArr) {
                               HXSDigitalMobileItemListEntity *entity = [HXSDigitalMobileItemListEntity createDigitalMobileItemListWithDic:dic];
                               
                               [itemMArr addObject:entity];
                           }
                       }
                       
                       block(status, msg, itemMArr);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

@end

//
//  HXSCategoryRequest.m
//  store
//
//  Created by  黎明 on 16/3/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCategoryRequest.h"

@implementation HXSCategoryRequest

+ (void)getCategoryListWith:(NSNumber *)shopId
                   shopType:(NSNumber *)shopType
                   complete:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *slideArr))block
{
    if (shopId == nil || shopType == nil)
    {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:shopId forKey:@"shop_id"];
    [dict setValue:shopType forKey:@"shop_type"];
    
    [HXStoreWebService getRequest:HXS_SHOP_CATEGORY
                parameters:dict
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           NSMutableArray * categoriesArray = [NSMutableArray array];
                           
                           //categories
                           if(DIC_HAS_ARRAY(data, @"categories")) {
                               for(NSDictionary * dic in [data objectForKey:@"categories"]) {
                                   if((NSNull *)dic == [NSNull null]) {
                                       continue;
                                   }
                                   HXSCategoryModel *categoryModel = [HXSCategoryModel initWithDict:dic];
                                   if(categoryModel) {
                                       [categoriesArray addObject:categoryModel];
                                   }
                               }
                           }
                           
                           //promotion_categories
                           NSMutableArray * promotionCategoriesArray = [NSMutableArray array];
                           if(DIC_HAS_ARRAY(data, @"recommended_categories")) {
                               for(NSDictionary * dic in [data objectForKey:@"recommended_categories"]) {
                                   if((NSNull *)dic == [NSNull null]) {
                                       continue;
                                   }
                                   HXSCategoryModel *categoryModel = [HXSCategoryModel initWithDict:dic];
                                   if(categoryModel) {
                                       [promotionCategoriesArray addObject:categoryModel];
                                   }
                               }
                           }
                           
                           NSDictionary *resultDict = @{@"categories"            :categoriesArray,
                                                        @"recommended_categories"  :promotionCategoriesArray};
                           block(kHXSNoError, msg, resultDict);
                           
                       } else {
                           block(status, msg, nil);
                       }

                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {

                       block(status, msg, nil);
    }];
}

@end

//
//  HXSPrintSettingViewModel.m
//  store
//
//  Created by J006 on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintSettingViewModel.h"

@implementation HXSPrintSettingViewModel

- (void)fetchPrintSettingWithShopId:(NSNumber *)shopID
                           Complete:(void (^)(HXSErrorCode status, NSString *message, HXSPrintTotalSettingEntity *entity))block
                            failure:(void(^)(NSString *errorMessage))failureBlock;
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:shopID forKey:@"shop_id"];
    [HXStoreWebService getRequest:HXS_PRINT_FORMATS
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           return ;
                       }
                       HXSPrintTotalSettingEntity *settingEntity;;
                       if([data isKindOfClass:[NSDictionary class]]) {
                           settingEntity = [self createPrintTotalSettingEntityWithData:data];
                       }
                       if(settingEntity)
                           block(kHXSNoError, msg, settingEntity);
                       else
                           failureBlock(msg);
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       failureBlock(msg);
                   }];

}

- (void)fetchPhotoPrintSettingWithShopId:(NSNumber *)shopID
                                Complete:(void (^)(HXSErrorCode status, NSString *message, HXSPrintTotalSettingEntity *entity))block
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:shopID forKey:@"shop_id"];
    
    [HXStoreWebService getRequest:HXS_PRINTPIC_FORMATS
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           return ;
                       }
                       HXSPrintTotalSettingEntity *settingEntity;;
                       if([data isKindOfClass:[NSDictionary class]]) {
                           settingEntity = [self createPrintTotalSettingEntityWithData:data];
                       }
                       if(settingEntity) {
                           block(kHXSNoError, nil, settingEntity);
                       } else {
                           block(kHXSNoError, nil, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}


#pragma mark - Private Methods

- (HXSPrintTotalSettingEntity *)createPrintTotalSettingEntityWithData:(NSDictionary *)dic
{
    return [[HXSPrintTotalSettingEntity alloc] initWithDictionary:dic error:nil];
}

@end

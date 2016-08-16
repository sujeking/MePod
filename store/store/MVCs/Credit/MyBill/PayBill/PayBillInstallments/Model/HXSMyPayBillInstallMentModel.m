//
//  HXSMyPayBillInstallMentModel.m
//  store
//
//  Created by J006 on 16/3/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyPayBillInstallMentModel.h"

@implementation HXSMyPayBillInstallMentModel

+ (instancetype)sharedManager
{
    static HXSMyPayBillInstallMentModel *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

- (void)myPayBillInstallMentSelectWithInstallmentAmount:(NSNumber *)installmentAmount
                                               Complete:(void (^)(HXSErrorCode status, NSString *message, NSArray *entityArray))block
                                                failure:(void(^)(NSString *errorMessage))failureBlock;
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[installmentAmount stringValue] forKey:@"installment_amount"];
    [HXStoreWebService getRequest:HXS_PAYBILLS_INSTALLMENT_SELECT
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status)
                       {
                           block(status, msg, nil);
                           return ;
                       }
                       NSMutableArray *itemArray;
                       if([data isKindOfClass:[NSDictionary class]]  && DIC_HAS_ARRAY(data, @"installment"))
                       {
                           NSArray *installmentArray = [data objectForKey:@"installment"];
                           for(NSDictionary *dic in installmentArray)
                           {
                               if(!itemArray)
                                   itemArray = [[NSMutableArray alloc]init];
                               HXSMyPayBillInstallMentSelectEntity *entity = [self createMyPayBillInstallMentSelectEntityWithData:dic];
                               [itemArray addObject:entity];
                           }
                       }
                       if(itemArray)
                           block(kHXSNoError, msg, itemArray);
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       failureBlock(msg);
                   }];
}

- (void)confirmMyPayBillInstallmentWithInstallmentAmount:(NSNumber *)installmentAmount
                                andWithInstallmentNumber:(NSNumber *)installmentNumber
                                              withBillID:(NSNumber *)billID
                                                Complete:(void (^)(HXSErrorCode status, NSString *message, HXSMyPayBillInstallMentEntity *entity))block
                                                 failure:(void(^)(NSString *errorMessage))failureBlock;
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[installmentAmount stringValue] forKey:@"installment_amount"];
    [dic setValue:[installmentNumber stringValue] forKey:@"installment_number"];
    [dic setValue:[billID stringValue] forKey:@"bill_id"];
    [HXStoreWebService postRequest:HXS_PAYBILLS_INSTALLMENT
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status)
                       {
                           block(status, msg, nil);
                           return ;
                       }
                       HXSMyPayBillInstallMentEntity *entity;
                       if([data isKindOfClass:[NSDictionary class]])
                       {
                           entity = [self createMyPayBillInstallMentEntityWithData:data];
                           block(kHXSNoError, msg, entity);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       failureBlock(msg);
                   }];
}

#pragma mark - Private Methods

- (HXSMyPayBillInstallMentSelectEntity*)createMyPayBillInstallMentSelectEntityWithData:(NSDictionary*)dic
{
    HXSMyPayBillInstallMentSelectEntity *entity = [[HXSMyPayBillInstallMentSelectEntity alloc] initWithDictionary:dic error:nil];
    
    return entity;
}

- (HXSMyPayBillInstallMentEntity *)createMyPayBillInstallMentEntityWithData:(NSDictionary *)dic
{
    HXSMyPayBillInstallMentEntity *entity = [[HXSMyPayBillInstallMentEntity alloc] initWithDictionary:dic error:nil];
    
    return entity;
}

@end

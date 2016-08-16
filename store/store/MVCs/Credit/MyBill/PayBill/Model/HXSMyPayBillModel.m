//
//  HXSMyPayBillModel.m
//  store
//
//  Created by J006 on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyPayBillModel.h"
#import "HXSMyPayBillDetailEntity.h"
#import "HXSMyPayBillListEntity.h"

@implementation HXSMyPayBillModel

+ (instancetype)sharedManager
{
    static HXSMyPayBillModel *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

- (void)fetchMyPayBillListComplete:(void (^)(HXSErrorCode status, NSString *message, NSArray *billsArr))block
                           failure:(void(^)(NSString *errorMessage))failureBlock;
{
    NSDictionary *dic = [[NSDictionary alloc]init];
    [HXStoreWebService getRequest:HXS_PAYBILLS_LIST
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           return ;
                       }
                       NSMutableArray *billsItems;
                       if([data isKindOfClass:[NSDictionary class]] && DIC_HAS_ARRAY(data, @"bills"))
                       {
                           NSArray *bills = [data objectForKey:@"bills"];
                           for(NSDictionary *dic in bills)
                           {
                               if(!billsItems)
                                   billsItems = [[NSMutableArray alloc]init];
                               HXSMyPayBillListEntity *entity = [self createPayBillListEntiryWithData:dic];
                               [billsItems addObject:entity];
                           }
                       }
                       if(billsItems)
                           block(kHXSNoError, msg, billsItems);
                       else
                           block(kHXSNoError, msg, nil);
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       failureBlock(msg);
                   }];
}

- (void)fetchMyPayBillDetailWithBillID:(NSNumber*)billID
                              complete:(void (^)(HXSErrorCode status, NSString *message, HXSMyPayBillEntity *detailEntity))block
                               failure:(void(^)(NSString *errorMessage))failureBlock;
{
    NSDictionary *paramsDic = @{@"bill_id": [billID stringValue]};
    [HXStoreWebService getRequest:HXS_PAYBILLS_DETAIL
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           return ;
                       }
                       if([data isKindOfClass:[NSDictionary class]]) {
                           HXSMyPayBillEntity *entity = [self createPayBillDetailEntiryWithData:data];
                           block(kHXSNoError, msg, entity);
                       }
                       else
                           block(kHXSNoError, msg, nil);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       failureBlock(msg);
                   }];
}


#pragma mark - Private Methods

- (HXSMyPayBillListEntity*)createPayBillListEntiryWithData:(NSDictionary *)payBillsDic
{
    return [[HXSMyPayBillListEntity alloc] initWithDictionary:payBillsDic error:nil];
}

- (HXSMyPayBillEntity*)createPayBillDetailEntiryWithData:(NSDictionary *)payBillDetailDic
{
    return [[HXSMyPayBillEntity alloc] initWithDictionary:payBillDetailDic error:nil];
}

@end

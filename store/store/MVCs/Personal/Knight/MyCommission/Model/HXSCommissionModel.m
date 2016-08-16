//
//  HXSCommissionModel.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommissionModel.h"


@implementation HXSCommissionModel

+ (void)getKnightCommissionRewardsWithPage:(NSNumber *)page
                                           Size:(NSNumber *)size
                                       complete:(void(^)(HXSErrorCode code, NSString * message, NSArray * commissions,NSNumber *allCommission))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:page forKey:@"page"];
    [dic setObject:size forKey:@"page_size"];
    
    [HXStoreWebService getRequest:HXS_KNIGHT_REWARDS_SCHEDULE
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if(kHXSNoError == status){
            NSMutableArray *resultArr = [NSMutableArray array];
            NSArray *arr = [data objectForKey:@"items"];
            if(arr){
                for(NSDictionary *dic in arr){
                    HXSCommissionEntity *temp = [HXSCommissionEntity objectFromJSONObject:dic];
                    [resultArr addObject:temp];
                }
            }
            
            NSNumber *commissions = [data objectForKey:@"money"];
            
            block(status,msg,resultArr,commissions);
        }else{
            block(status,msg,nil,nil);
        }

    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil,nil);
    }];
}

@end

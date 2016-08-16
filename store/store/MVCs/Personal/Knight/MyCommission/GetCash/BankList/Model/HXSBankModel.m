//
//  HXSBankModel.m
//  store
//
//  Created by 格格 on 16/5/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBankModel.h"

@implementation HXSBankModel

+ (void)getBankList:(void(^)(HXSErrorCode code, NSString * message,NSArray *bankList))block{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [HXStoreWebService getRequest:HXS_KNIGHT_BANK_LIST
                parameters:param
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       
                       DLog(@"--------BankList--------%@",data);
                       
                       if(kHXSNoError == status){
                           
                           NSMutableArray *resoultArr = [NSMutableArray array];
                           NSArray *arr = [data objectForKey:@"banks"];
                           if(arr){
                               for(NSDictionary *dic in arr){
                                   HXSBankEntity *temp = [HXSBankEntity objectFromJSONObject:dic];
                                   [resoultArr addObject:temp];
                               }
                           }
                           
                           block(status,msg,resoultArr);
                       
                       }else{
                           block(status,msg,nil);
                       }

    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        block(status,msg,nil);
        
    }];
}

@end

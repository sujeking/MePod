//
//  HXSCashModel.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCashModel.h"

@implementation HXSCashModel

+ (void)getKnightInfo:(void(^)(HXSErrorCode code, NSString * message, HXSKnightInfo * knightInfo))block{
    
    NSDictionary *dic = [NSDictionary dictionary];
    [HXStoreWebService getRequest:HXS_KNIGHT_SHOW
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(kHXSNoError == status){
                           HXSKnightInfo *temp = [HXSKnightInfo objectFromJSONObject:data];
                           block(status,msg,temp);
                       }else{
                           block(status,msg,nil);
                       }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

+ (void)knightWithdrawWithAmount:(NSNumber *)amount
                      bankCardNo:(NSString *)bank_card_no
                        bankName:(NSString *)bank_name
                        bankCity:(NSString *)bank_city
                    bankUserName:(NSString *)bank_user_name
                        bankSite:(NSString *)bank_site
                        bankCode:(NSString *)bank_code
                        complete:(void(^)(HXSErrorCode code, NSString * message, NSDictionary *data))block{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:amount forKey:@"amount"];
    [dic setObject:bank_card_no forKey:@"bank_card_no"];
    [dic setObject:bank_name forKey:@"bank_name"];
    [dic setObject:bank_city forKey:@"bank_city"];
    [dic setObject:bank_user_name forKey:@"bank_user_name"];
    [dic setObject:bank_site forKey:@"bank_site"];
    [dic setObject:bank_code forKey:@"bank_code"];
    
    [HXStoreWebService postRequest:HXS_KNIGHT_WITHDRAW
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);        
    }];
}

@end

//
//  HXSEditDormAddressViewModel.m
//  store
//
//  Created by  黎明 on 16/7/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSEditDormAddressViewModel.h"


#define CREDITCARD_ADD_DORM_ADDRESS @"creditcard/add/dorm/address"

@implementation HXSEditDormAddressViewModel

- (void)commitDormAddress:(NSString *)dormAddress
                complete:(void (^)(HXSErrorCode status, NSString *message))block
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:dormAddress forKey:@"dorm_address"];
    
    [HXStoreWebService postRequest:CREDITCARD_ADD_DORM_ADDRESS parameters:dict
                          progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg);
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg);
                          }];
}
@end

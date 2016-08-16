//
//  HXSApplyBoxModel.m
//  store
//
//  Created by ArthurWang on 16/5/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSApplyBoxModel.h"

@implementation HXSApplyBoxModel

+ (void)commitApplyInfoToServerWithApplyInfo:(HXSApplyInfoEntity *)model
                                    complete:(void (^)(HXSErrorCode code, NSString *message))block
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:model.applyUserNameStr forKey:@"username"];
    [dict setObject:model.applyUserDormentryIdNum forKey:@"dormentry_id"];
    [dict setObject:model.applyUserRoomStr forKey:@"room"];
    [dict setObject:model.applyUserMobileStr forKey:@"mobile"];
    [dict setObject:model.applyUserGenderNum forKey:@"gender"];
    [dict setObject:model.applyUserAdmissionDateStr forKey:@"enrollment_year"];
    [dict setObject:model.applyUserdormIdNum forKey:@"dorm_id"];

    [HXStoreWebService postRequest:HSX_BOX_APPLY parameters:dict progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status, msg);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        block(status, msg);
    }];
}
@end

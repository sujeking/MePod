//
//  HXSNetRequest.m
//  store
//
//  Created by  黎明 on 16/6/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSNetRequest.h"

#import "HXSApplyResultInfoModel.h"
@implementation HXSNetRequest

+ (void)fetchApplyResultInfoWithUid:(NSNumber *)uid complete:(void (^)(HXSErrorCode code, NSString *message, HXSApplyResultInfoModel *applyResultInfoModel))block
{
    NSDictionary *prama = @{@"uid":uid};
    
    [HXStoreWebService getRequest:HSX_BOX_APPLY_INFO parameters:prama progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        if (status == kHXSNoError) {
            HXSApplyResultInfoModel *model = [HXSApplyResultInfoModel initWithDict:data];
            block(status,msg,model);
        }
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status, msg, nil);
    }];
}
@end

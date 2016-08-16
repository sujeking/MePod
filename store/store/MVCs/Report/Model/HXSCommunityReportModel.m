//
//  HXSCommunityReportModel.m
//  store
//
//  Created by J006 on 16/5/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityReportModel.h"

@implementation HXSCommunityReportModel

- (void)fetchTheReportReasonComplete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXSCommunityReportItemEntity *> *reportReasonArray))block;
{
    [HXStoreWebService getRequest:HXS_COMMUNITY_REPORT_REASON_LIST
                parameters:nil
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status)
                       {
                           block(status, msg, nil);
                           return ;
                       }
                       NSMutableArray<HXSCommunityReportItemEntity *> *array;
                       NSArray *dataArray = [data objectForKey:@"reason_list"];
                       for (NSDictionary *dic in dataArray)
                       {
                           if(!array)
                               array = [[NSMutableArray alloc]init];
                           HXSCommunityReportItemEntity *entity = [self createReportReasonEntityWithData:dic];
                           [array addObject:entity];
                       }
                       if(array)
                       {
                           block(status,msg,array);
                       }
                       else
                       {
                           block(status,msg,nil);
                       }
                       
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

- (void)reportTheContentWithParamEntity:(HXSCommunityReportParamEntity *)entity
                               complete:(void (^)(HXSErrorCode code, NSString *message, NSString *resultStatus))block
{
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionary];
    switch (entity.reportType)
    {
        case kHXSCommunityReportTypePost:
        {
            [pramaDic setObject:entity.postIDStr forKey:@"post_id"];
            break;
        }
        case kHXSCommunityReportTypeComment:
        {
            [pramaDic setObject:entity.commentIDStr forKey:@"comment_id"];
            break;
        }
    }
    [pramaDic setObject:entity.reasonStr forKey:@"reason"];
    
    [HXStoreWebService postRequest:HXS_COMMUNITY_SUBMIT_REPORT
                 parameters:pramaDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (kHXSNoError != status)
                        {
                            block(status, msg, nil);
                            return ;
                        }
                        NSString *resultStatusStr = [data objectForKey:@"result_status"];
                        block(status,msg,resultStatusStr);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, nil);
                    }];
}

#pragma mark private methords

- (HXSCommunityReportItemEntity *)createReportReasonEntityWithData:(NSDictionary *)dic
{
    HXSCommunityReportItemEntity *entity = [[HXSCommunityReportItemEntity alloc] initWithDictionary:dic error:nil];
    
    return entity;
}

@end

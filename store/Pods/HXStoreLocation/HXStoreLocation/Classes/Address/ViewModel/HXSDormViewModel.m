//
//  HXSDormViewModel.m
//  Pods
//
//  Created by 格格 on 16/6/27.
//
//

#import "HXSDormViewModel.h"

@implementation HXSDormViewModel

+ (void) fetchDormListWithDormentryId:(NSNumber *)dormentry_id
                                 role:(NSNumber *)role
                             complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *dormList))block{
    
    NSDictionary *prama = @{
                            @"dormentry_id":dormentry_id,
                            @"role":role};
    [HXStoreWebService getRequest:HXS_DORM_LIST
                       parameters:prama
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
                              if(kHXSNoError == status){
                                  NSMutableArray *resultArray = [NSMutableArray array];
                                  NSArray *dataArray = [data objectForKey:@"dorm_list"];
                                  if(dataArray){
                                      for(NSDictionary *dic in dataArray){
                                          HXSDormNegoziante *temp = [HXSDormNegoziante objectFromJSONObject:dic];
                                          [resultArray addObject:temp];
                                      }
                                  }
                                  block(status,msg,resultArray);
                              }else{
                                  block(status,msg,nil);
                              }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

@end

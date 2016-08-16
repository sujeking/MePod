//
//  HXSDigitalMobileCommentModel.m
//  store
//
//  Created by ArthurWang on 16/3/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileCommentModel.h"

@implementation HXSDigitalMobileCommentModel

- (void)fetchCommtentListWithItemID:(NSNumber *)itemIDIntNum
                               page:(NSNumber *)pageIntNum
                         numPerPage:(NSNumber *)numPerPageIntNum
                          completed:(void (^)(HXSErrorCode status, NSString *message, NSArray *commentsArr))block
{
    NSDictionary *parameterDic = @{
                                   @"item_id":           itemIDIntNum,
                                   @"page":              pageIntNum,
                                   @"page_size":         numPerPageIntNum,
                                   };
    
    [HXStoreWebService getRequest:HXS_TIP_COMMENT_GETCOMMENT
                parameters:parameterDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       NSMutableArray *commentMArr = [[NSMutableArray alloc] initWithCapacity:5];
                       if (DIC_HAS_ARRAY(data, @"comments")) {
                           NSArray *tempArr = [data objectForKey:@"comments"];
                           
                           for (NSDictionary *dic in tempArr) {
                               HXSDigitalMobileDetailCommentEntity *commentEntity = [HXSDigitalMobileDetailCommentEntity createCommentEntityWithDic:dic];
                               
                               [commentMArr addObject:commentEntity];
                           }
                       }
                       
                       block(status, msg, commentMArr);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];
}

@end

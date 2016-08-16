//
//  HXSCommunityReportModel.h
//  store
//  举报相关Model
//  Created by J006 on 16/5/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSCommunityReportParamEntity.h"
#import "HXSCommunityReportItemEntity.h"

@interface HXSCommunityReportModel : NSObject

/**
 *  举报帖子或评论内容
 *
 *  @param entity
 *  @param block
 */
- (void)reportTheContentWithParamEntity:(HXSCommunityReportParamEntity *)entity
                               complete:(void (^)(HXSErrorCode code, NSString *message, NSString *resultStatus))block;

/**
 *  获取举报原因列表
 *
 *  @param block
 */
- (void)fetchTheReportReasonComplete:(void (^)(HXSErrorCode code, NSString *message, NSArray<HXSCommunityReportItemEntity *> *reportReasonArray))block;

@end

//
//  HXSCommunityReportViewController.h
//  store
//
//  Created by J006 on 16/5/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSCommunityReportParamEntity.h"

@interface HXSCommunityReportViewController : HXSBaseViewController

/**
 *  初始化
 *
 *  @param type  类型:举报帖子还是其他
 *  @param idStr 帖子id还是其他id
 */
- (void)initCommunityReportViewControllerWithType:(HXSCommunityReportType)type
                                        andWithID:(NSString *)idStr;

@end

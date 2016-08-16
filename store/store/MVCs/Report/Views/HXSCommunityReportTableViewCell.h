//
//  HXSCommunityReportTableViewCell.h
//  store
//
//  Created by J006 on 16/5/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSCommunityReportItemEntity.h"
#import "HXSCommunityReportParamEntity.h"

@interface HXSCommunityReportTableViewCell : UITableViewCell

/**
 *  初始化
 *
 *  @param reportEntity 举报类型
 *  @param paramEntity  举报的上传entity
 */
- (void)initCommunityReportTableViewCellWithReportEntity:(HXSCommunityReportItemEntity *)reportEntity
                                      andWithParamEntity:(HXSCommunityReportParamEntity *)paramEntity;

@end

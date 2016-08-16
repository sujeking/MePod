//
//  HXSCommunityReportParamEntity.h
//  store
//
//  Created by J006 on 16/5/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HXSCommunityReportType)
{
    kHXSCommunityReportTypePost     = 0, // 帖子举报
    kHXSCommunityReportTypeComment  = 1, // 评论举报
};

@interface HXSCommunityReportParamEntity : NSObject

@property (nonatomic ,assign) HXSCommunityReportType reportType;
@property (nonatomic ,strong) NSString *postIDStr;
@property (nonatomic ,strong) NSString *commentIDStr;
@property (nonatomic ,strong) NSString *reasonStr;

@end

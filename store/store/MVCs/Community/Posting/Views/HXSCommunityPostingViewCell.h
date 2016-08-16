//
//  HXSCommunityPostingViewCell.h
//  store
//  话题,学校
//  Created by J006 on 16/4/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HXSCommunityPostTopicOrSchoolType)
{
    kHXSCommunityPostTopicOrSchoolTypeTopic  = 0,//话题
    kHXSCommunityPostTopicOrSchoolTypeSchool = 1,//学校
};

@interface HXSCommunityPostingViewCell : UITableViewCell

- (void)initHXSCommunityPostingViewCellWithType:(HXSCommunityPostTopicOrSchoolType)type
                                   andWithTitle:(NSString *)title;

@end

//
//  HXSCommunityTopicListViewController.h
//  store
//
//  Created by  黎明 on 16/4/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
@class HXSTopic;

/**
 *  话题列表
 */
@protocol HXSCommunityTopicListDelegate <NSObject>

@optional

- (void)refreshTopicList;

@end


@interface HXSCommunityTopicListViewController : HXSBaseViewController

@property (nonatomic, strong, readonly) NSString *topicShareLinkStr;

+ (instancetype)createCommunityTopicListVCWithTopicID:(NSString *)topicIDStr
                                                title:(NSString *)titleStr
                                             delegate:(id<HXSCommunityTopicListDelegate>)delegate;

@end

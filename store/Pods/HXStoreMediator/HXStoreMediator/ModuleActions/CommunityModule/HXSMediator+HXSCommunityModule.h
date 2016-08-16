//
//  HXSMediator+HXSCommunityModule.h
//  store
//
//  Created by ArthurWang on 16/5/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMediator.h"

static NSString *kHXSMediatorTargetEleme = @"eleme";
static NSString *kHXSMediatorActionHome  = @"home";

@interface HXSMediator (HXSCommunityModule)

- (UIViewController *)HXSMediator_topicDetailViewControllerWithParams:(NSDictionary *)params;

- (UIViewController *)HXSMediator_postDetailViewControllerWithParams:(NSDictionary *)params;

@end

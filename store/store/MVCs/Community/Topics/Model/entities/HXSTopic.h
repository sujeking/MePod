//
//  HXSTopic.h
//  store
//
//  Created by 格格 on 16/4/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSTopic : HXBaseJSONModel

@property(nonatomic, strong) NSString *idStr;
@property(nonatomic, strong) NSString *titleStr;
@property(nonatomic, strong) NSString *smallImageStr;
@property(nonatomic, strong) NSString *bigImageStr;
@property(nonatomic, strong) NSString *introStr;
@property(nonatomic, strong) NSNumber *weightLongNum;
@property(nonatomic, strong) NSNumber *statusIntNum;
@property(nonatomic, strong) NSNumber *isFollowedIntNum;  //0:未关注   1:关注

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end

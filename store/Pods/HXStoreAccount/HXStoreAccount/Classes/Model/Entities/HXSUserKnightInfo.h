//
//  HXSUserKnightInfo.h
//  store
//
//  Created by ArthurWang on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

@interface HXSUserKnightInfo : HXBaseJSONModel

/**  新任务 */
@property (nonatomic, strong) NSNumber *knightNewTaskIntNum;
/**  佣金 */
@property (nonatomic, strong) NSNumber *rewardFloatNum;
@property (nonatomic, strong) NSNumber *statusIntNum; //骑士状态  0不是骑士  1是骑士

+ (instancetype)createUserKnightInfoWithDic:(NSDictionary *)dic;

@end

//
//  HXSCommissionEntity.h
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCommissionEntity : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *typeIntNum;
@property (nonatomic, strong) NSNumber *timeLongNum;
@property (nonatomic, strong) NSNumber *amountIntNum;
@property (nonatomic, strong) NSString *contentStr;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end

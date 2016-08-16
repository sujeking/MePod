//
//  HXSCreditOrderEntity.h
//  store
//
//  Created by ArthurWang on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCreditOrderEntity : NSObject

@property (nonatomic, strong) NSNumber *totalCountIntNum;    // 87
@property (nonatomic, strong) NSNumber *pageIntNum;          // 页数，默认1
@property (nonatomic, strong) NSNumber *numPerPageIntNum;    // 每页多少个，默认比如20，服务端决定

@property (nonatomic, strong) NSMutableArray *orderListArr;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

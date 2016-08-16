//
//  HXSLogisticEntity.h
//  store
//
//  Created by 沈露萍 on 16/3/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSLogisticRecordsEntity : NSObject

@property (nonatomic, strong) NSString *timeStr;  //时间
@property (nonatomic, strong) NSString *descStr;  //地点

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface HXSLogisticEntity : NSObject

@property (nonatomic, strong) NSString *logisticNumberStr; //快递单号
@property (nonatomic, strong) NSString *logisticNameStr;   //快递名称

@property (nonatomic, strong) NSMutableArray *logisticRecordsMArr;;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

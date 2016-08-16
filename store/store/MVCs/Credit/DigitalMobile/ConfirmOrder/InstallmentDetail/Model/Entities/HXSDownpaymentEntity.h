//
//  HXSDownpaymentEntity.h
//  store
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSDownpaymentEntity : NSObject

@property (strong, nonatomic) NSString *percentDesc;
@property (strong, nonatomic) NSNumber *percent;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

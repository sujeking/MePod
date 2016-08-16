//
//  HXSBankEntity.h
//  store
//
//  Created by 格格 on 16/5/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSBankEntity : HXBaseJSONModel

@property (nonatomic, strong) NSString *codeStr;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *imageStr;

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end

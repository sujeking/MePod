//
//  HXSQRCodeEntity.h
//  store
//
//  Created by 格格 on 16/5/5.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSQRCodeEntity : HXBaseJSONModel

@property (nonatomic, strong) NSString *deliveryOrderIdStr;
@property (nonatomic, strong) NSString *orderIdStr;
@property (nonatomic, strong) NSNumber *shopIdLongNum;
@property (nonatomic, strong) NSString *shopNameStr;
@property (nonatomic, strong) NSString *shopLogoStr;
@property (nonatomic, strong) NSString *codeStr;

+ (id)objectFromJSONObject:(NSDictionary *)object;

@end

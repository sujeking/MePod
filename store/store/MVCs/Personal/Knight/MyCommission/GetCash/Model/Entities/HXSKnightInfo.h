//
//  HXSKnightInfo.h
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSKnightInfo : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *idLongNum;
@property (nonatomic, strong) NSNumber *uidIntNum;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *idCardNoStr;
@property (nonatomic, strong) NSString *phoneStr;
@property (nonatomic, strong) NSNumber *statusIntNum;
@property (nonatomic, strong) NSNumber *lockTimeLongNum;
@property (nonatomic, strong) NSNumber *moneyDoubleNum;
@property (nonatomic, strong) NSString *bankCardNoStr;
@property (nonatomic, strong) NSString *bankNameStr;
@property (nonatomic, strong) NSString *bankCityStr;
@property (nonatomic, strong) NSString *bankUserNameStr;
@property (nonatomic, strong) NSString *siteNameStr;
@property (nonatomic, strong) NSNumber *enterYearIntNum;
@property (nonatomic, strong) NSNumber *educationIntNum;
@property (nonatomic, strong) NSArray  *siteIdsArr;
@property (nonatomic, strong) NSString *bankCodeStr;

+ (id)objectFromJSONObject:(NSDictionary *)object;

@end

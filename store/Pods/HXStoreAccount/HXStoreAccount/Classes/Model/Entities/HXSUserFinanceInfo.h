//
//  HXSUserFinanceInfo.h
//  store
//
//  Created by hudezhi on 15/8/6.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSUserFinanceInfo : NSObject

@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *idCardNo;
@property (nonatomic, copy) NSString *cityname;

@property (nonatomic, copy) NSString *siteName;
@property (nonatomic, copy) NSString *entranceYear;
@property (nonatomic, copy) NSString *educationName;

@property (nonatomic, copy) NSString *majorName;
@property (nonatomic, copy) NSString *dormAddress;
@property (nonatomic, assign) BOOL isSetPayPasswd;
@property (nonatomic, assign) BOOL isPayOpened;
@property (nonatomic, assign) BOOL isExemptionStatus;   // 是否开通免密支付（1:已开通； 0 未开通）

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

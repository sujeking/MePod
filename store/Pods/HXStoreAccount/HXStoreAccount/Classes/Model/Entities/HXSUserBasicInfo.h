//
//  HXSUserBasicInfo.h
//  store
//
//  Created by chsasaw on 14/10/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSUserBasicInfo : NSObject

@property (nonatomic, copy) NSNumber * uid;
@property (nonatomic, copy) NSString * uName;
@property (nonatomic, copy) NSString * nickName;

@property (nonatomic, copy) NSString * location;
@property (nonatomic, copy) NSString * longitude; // 经度
@property (nonatomic, copy) NSString * latitude;  // 纬度

@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * portrait;
@property (nonatomic, copy) NSString * portrait_medium;
@property (nonatomic, copy) NSString * portrait_big;

@property (nonatomic) int gender;
@property (nonatomic) int role;
@property (nonatomic) int level;
@property (nonatomic) int credit;
@property (nonatomic) int historycredit;

@property (nonatomic) int couponQuantity;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) int passwordFlag; // 0 没有设置   1 设置过
@property (nonatomic, assign) int signInFlag;   // 0 未签到     1 今日已签到
@property (nonatomic, strong) NSNumber *registerTimeLongNum; // 用户注册时间
@property (nonatomic, strong) NSNumber *signInCreditIntNum;  // 用户签到可获取的积分

- (id)initWithLocalDic:(NSDictionary *)dic;
- (id)initWithServerDic:(NSDictionary *)dic;

- (NSDictionary *)encodeAsLocalDic;

@end
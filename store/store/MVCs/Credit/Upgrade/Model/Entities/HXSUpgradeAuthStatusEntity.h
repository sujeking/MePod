//
//  HXSUpgradeAuthStatusEntity.h
//  store
//
//  Created by ArthurWang on 16/2/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSUpgradeAuthStatusEntity : HXBaseJSONModel

/** 芝麻信用授权  0:未授权；1:已授权 */
@property (nonatomic, strong) NSNumber *zhimaAuthStatusIntNum;
/** 通讯录授权  0:未授权；1:已授权  */
@property (nonatomic, strong) NSNumber *contactsAuthStatusIntNum;
/** 紧急联系人信息提交  0:未提交；1:已提交  */
@property (nonatomic, strong) NSNumber *emergencyContactsStatusIntNum;

// 5.0 add
/** 定位信息授权 0:未提交；1:已提交  */
@property (nonatomic, strong) NSNumber *positionStatusIntNum;
/** 通话记录授权  0:未提交；1:已提交  */
@property (nonatomic, strong) NSNumber *callRecordsStatus;

/** 身份证正面照片授权  null:未提交；url:已提交  */
@property (nonatomic, strong) NSString *idCardDirectUrlStr;
/** 身份证背面照片授权  null:未提交；url:已提交  */
@property (nonatomic, strong) NSString *idCardBackUrlStr;
/** 手持身份证照片授权  null:未提交；url:已提交  */
@property (nonatomic, strong) NSString *idCardHandheldUrlStr;



+ (instancetype)createEntityWithDictionary:(NSDictionary *)infoDic;

@end

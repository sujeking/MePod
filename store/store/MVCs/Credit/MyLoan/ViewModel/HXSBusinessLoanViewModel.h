//
//  HXSBusinessLoanViewModel.h
//  59dorm
//
//  Created by J006 on 16/7/19.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSMyLoanBankListModel.h"
#import "HXSMyLoanParamModel.h"
#import "HXSUpgradeAuthStatusEntity.h"

typedef NS_ENUM(NSInteger, HXSAuthorizeStatus){
    kHXSAuthorizeStatusNone = 0,    // 0:未授权
    kHXSAuthorizeStatusDone = 1,    // 1:已授权
};

@interface HXSBusinessLoanViewModel : NSObject

+ (instancetype)sharedManager;

/**
 *  根据图片压缩到指定大小
 *
 *  @param image
 *  @param sizeM 指定大小,目前默认为5.0M
 *
 *  @return
 */
- (NSData *)checkTheImage:(UIImage *)image
        andScaleToTheSize:(CGFloat)sizeM;

- (HXSMyLoanBankListModel *)getMyLoanBankListModel;


/**
 *  金融开通接口
 *
 *  @param block
 */
- (void)openMyLoanComplete:(void (^)(HXSErrorCode code, NSString *message, BOOL isOpen))block;

/**
 *  身份信息校验接口
 *
 *  @param model
 *  @param block
 */
- (void)addIdentifyInforWithParamModel:(HXSSubscribeIDParamModel *)model
                              Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block;

/**
 *  发送手机验证码
 *
 *  @param phoneStr 手机号码
 *  @param block
 */
- (void)fetchVerifyCodeWithPhone:(NSString *)phoneStr
                        Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block;

/**
 *  学籍信息校验接口
 *
 *  @param model
 *  @param block
 */
- (void)addSchoolIdentifyWithParamModel:(HXSSubscribeStudentParamModel *)model
                               Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block;

/**
 *  银行信息校验接口
 *
 *  @param model
 *  @param block
 */
- (void)addBankIdentifyWithParamModel:(HXSSubscribeBankParamModel *)model
                             Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block;

/**
 *  银行列表
 *
 *  @param block
 */
- (void)fetchBankListComplete:(void (^)(HXSErrorCode code, NSString *message, HXSMyLoanBankListModel *model))block;

/**
 *  设置或者修改密码
 *
 *  @param oldPasswordStr 旧密码
 *  @param newPasswordStr 新密码
 *  @param block
 */
- (void)settingThePasswordForWalletWithOldPassword:(NSString *)oldPasswordStr
                                    andNewPassword:(NSString *)newPasswordStr
                                          Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block;

/**
 *  照片上传
 *
 *  @param paramModel 参数
 *  @param block
 */
- (void)uploadThePhotoWithParam:(HXSUploadPhotoParamModel *)paramModel
                       Complete:(void (^)(HXSErrorCode code, NSString *message, NSString *urlStr))block;

/**
 *  获取授权状态
 *
 *  @param block 
 */
- (void)fetchAuthStatusComplete:(void (^)(HXSErrorCode code, NSString *message, HXSUpgradeAuthStatusEntity *model))block;

/** 授权完成后，进入学籍校验接口 */
- (void)finishAuthorzieComplete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block;

/** 定位授权 */
- (void)uploadLocationInfoWithLatitude:(double)latitude longitude:(double)longitude complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block;

/** 通讯录授权 */
- (void)uploadContactsInfo:(NSString *)contactsStr complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block;

@end

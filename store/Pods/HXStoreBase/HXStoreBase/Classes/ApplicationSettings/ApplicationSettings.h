//
//  ApplicationSettings.h
//  dorm
//
//  Created by hudezhi on 15/7/10.
//  Copyright (c) 2015年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSElemeContactInfo.h"

typedef NS_ENUM(NSInteger, HXSEnvironmentType) {
    HXSEnvironmentProduct = 0,
    HXSEnvironmentTemai,                    // 特卖环境, Dev环境
    HXSEnvironmentStage,                    // Stage测试
    HXSEnvironmentQA,                       // 测试环境

    HXSServiceURLCounts
};

//==============================================================
@class HXSFinanceOperationManager;

@interface ApplicationSettings : NSObject

+ (ApplicationSettings *)instance;
+ (void)clearInstance;

// service base surl
- (NSString*)currentServiceURL;
- (NSString*)currentHttpsServiceURL;

- (HXSEnvironmentType)currentEnvironmentType;
- (void)setCurrentEnvironmentType:(HXSEnvironmentType)type;
- (NSString *)serviceURLForEnvironmentType:(HXSEnvironmentType) type;

//  FinanceOperationManager

- (void)setFinanceOperationManager:(HXSFinanceOperationManager *)mgr;
- (HXSFinanceOperationManager*)financeOperationManager;
- (void)clearFinanceOperationManager;

// 金融协议的URL
- (NSString *)currentCreditPayAgreementURL;
- (NSString *)currentCashInstallmentAgreementURL; // 取现协议
- (NSString *)currentMobileStagingAgreementURL; // 3c数码协议
- (NSString *)currentBillStageAgreementURL; // 账单分期协议
- (NSString *)currentInvitationURL;
- (NSString *)currentBoxProtocolURL;
- (NSString *)currentPointURL;

// 忘记密码 URL
- (NSString *)currentForgetPasswordURL;

// 芝麻信用 URL
- (NSString *)currentZmCreditURL;

// 信用钱包FAQ URL
- (NSString *)huaBuWanFAQURL;
- (NSString *)WalletFAQURLString;
- (NSString *)installmentStoreFAQURLString;

// APP 3.2 申请店长
- (NSString *)registerStoreManagerBaseURL;

// APP 3.0  积分商城
- (NSString *)creditCentsURL;

// 打印说明 URL
- (NSString *)currentPrintURL;

// 举报须知 URL
- (NSString *)currentReportURL;

// 骑士注册 URL
- (NSString *)knightRegisterURL;

//==============================================================

// 饿了么 联系人地址(未登录状态时先保存)
- (HXSElemeContactInfo*)cacheElemeContactInfo;
- (void)setCacheElemeContactInfo:(HXSElemeContactInfo*)info;
- (void)clearCacheElemeContactInfo;

//  地址搜索历史
- (NSArray *)addressSearchHistoryList;
- (void)addAddressSearchHistory:(NSString *)address;

// 便利店搜索历史
- (void)addStoreSearchHistory:(NSString *)itemName;
- (NSArray *)storeSearchHistoryList;

//==============================================================

// 定位功能开关
- (BOOL)isLocationDisabled;
- (void)setLocationDisability:(BOOL)disable;

// APP 3.1 零食盒推荐隐藏
- (BOOL)isRecommendBoxHidden;
- (void)setRecommendBoxHidden:(BOOL)hidden;

//OSS SDK 根据环境切换值

- (NSString *)ossSDKAccessKeyId;

- (NSString *)ossSDKAccessKeySecret;

- (NSString *)ossSDKEndpoint;

- (NSString *)ossSDKBucketName;

- (NSString *)ossSDKDomainName;

- (NSString *)ossSDKShopLogoDomainName;

// 一元夺宝
- (NSString *)currentOneDreamDetailURL;

// 选择地址 默认学校和楼栋
- (NSNumber *)defaultSiteID;
- (NSNumber *)defaultDormentryID;

@end

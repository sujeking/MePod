//
//  ApplicationSettings.m
//  dorm
//
//  Created by hudezhi on 15/7/10.
//  Copyright (c) 2015年 Huanxiao. All rights reserved.


#import "ApplicationSettings.h"

#import "HXSFinanceOperationManager.h"
#import "HXMacrosDefault.h"

#pragma mark - Service Url
//==============================================================================
// http
NSString* const HXSServiceURLProduct      = @"http://mobileapi.59store.com";

NSString* const HXSServiceURLTest         = @"http://mobileapi.59temai.com";

NSString* const HXSServiceURLStage        = @"http://mobileapi.59store.net";

NSString* const HXSServiceURLQA           = @"http://mobileapi.59shangcheng.com";

// https
NSString* const HXSServiceHttpsURLProduct = @"https://mobileapi.59store.com";

NSString* const HXSServiceHttpsURLTest    = @"https://mobileapi.59temai.com";

//NSString* const HXSServiceHttpsURLTest    = @"https://192.168.40.160:8080";

NSString* const HXSServiceHttpsURLStage   = @"https://mobileapi.59store.net";

NSString* const HXSServiceHttpsURLQA      = @"https://mobileapi.59shangcheng.com";

#pragma mark - ApplicationSettings Keys
//==============================================================================

NSString* const kServiceURL                    = @"kServiceURL";
NSString* const kServiceURLType                = @"kServiceURLType";
NSString* const kHXSFinanceOperationManagerKey = @"kHXSFinanceOperationManagerKey";
NSString* const kHXSElemeContactCacheInfo      = @"kHXSElemeContactCacheInfo";
NSString* const kHXSAddressSearchHistoryKey    = @"kHXSAddressSearchHistoryKey";

NSString* const kHXSStoreSearchHistoryKey      = @"kHXSStoreSearchHistoryKey";

NSString* const kHXSRecommendBoxHiddenKey      = @"kHXSRecommendBoxHiddenKey";

//==============================================================================
//OSS SDK SETTING



//==============================================================================

// 以前使用了宏,兼容以前的
#define USER_DEFAULT_LOCATION_HAS_BEEN_DENIED       @"locationHasBeenDenied"


static ApplicationSettings * instance;

@interface ApplicationSettings() {
    
}

@end

@implementation ApplicationSettings

+ (ApplicationSettings *)instance {
    @synchronized(self) {
        if (!instance) {
            instance = [[ApplicationSettings alloc] init];
        }
    }
    return instance;
}

+ (void)clearInstance {
    @synchronized(self) {
        if (instance) {
            instance = nil;
        }
    }
}

- (NSString*)currentServiceURL
{
    return [self serviceURLForEnvironmentType:[self currentEnvironmentType]];
}

- (NSString*)currentHttpsServiceURL {
    return [self serviceHttpsURLForEnvironmentType:[self currentEnvironmentType]];
}

- (void)setCurrentServiceURL:(NSString*)urlString
{
    [[NSUserDefaults standardUserDefaults] setObject:urlString forKey:kServiceURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (HXSEnvironmentType)currentEnvironmentType
{
#if DEBUG
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey: kServiceURLType];
    
    return (number == nil) ? HXSEnvironmentQA : (HXSEnvironmentType)[number intValue];
#else
    return HXSEnvironmentProduct;
#endif
}

- (void)setCurrentEnvironmentType:(HXSEnvironmentType)type
{
    [[NSUserDefaults standardUserDefaults] setObject:@(type) forKey:kServiceURLType];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UPDATE_DEVICE_FINISHED];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHXSUserID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHXSToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULT_LOCATION_MANAGER];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)serviceURLForEnvironmentType:(HXSEnvironmentType) type {
    switch(type) {
        case HXSEnvironmentProduct:    return HXSServiceURLProduct;
        case HXSEnvironmentTemai:       return HXSServiceURLTest;
        case HXSEnvironmentStage:      return HXSServiceURLStage;
        case HXSEnvironmentQA:         return HXSServiceURLQA;
        default:
            break;
    }
    return @"";
}

- (NSString *)serviceHttpsURLForEnvironmentType:(HXSEnvironmentType) type {
    switch(type) {
        case HXSEnvironmentProduct:    return HXSServiceHttpsURLProduct;
        case HXSEnvironmentTemai:       return HXSServiceHttpsURLTest;
        case HXSEnvironmentStage:      return HXSServiceHttpsURLStage;
        case HXSEnvironmentQA:         return HXSServiceHttpsURLQA;
        default:
            break;
    }
    return @"";
}

// ======================= HXSFinanceOperationManager =======================

- (void)setFinanceOperationManager:(HXSFinanceOperationManager *)mgr
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:mgr];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:kHXSFinanceOperationManagerKey];
    [defaults synchronize];
}

- (HXSFinanceOperationManager*)financeOperationManager
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:kHXSFinanceOperationManagerKey];
    HXSFinanceOperationManager *mgr = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return mgr;
}

- (void)clearFinanceOperationManager
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHXSFinanceOperationManagerKey];
}

// ======================= Finance Agreement URL =======================

// 信用购开通协议
- (NSString *)creditPayAgreementURLForEnvironment:(HXSEnvironmentType) type
{
    switch(type) {
        case HXSEnvironmentProduct:
        return @"http://appdoc.59store.com/Public/html/59wallet_protocol.html";
        case HXSEnvironmentTemai:
        return @"http://appdoc.59temai.com/Public/html/59wallet_protocol.html";
        case HXSEnvironmentStage:
        return @"http://appdoc.59store.net/Public/html/59wallet_protocol.html";
        case HXSEnvironmentQA:
        return @"http://appdoc.59shangcheng.com/Public/html/59wallet_protocol.html";
        default:
            break;
    }
    return @"http://appdoc.59store.com/Public/html/59wallet_protocol.html";
}

- (NSString *)currentCashInstallmentAgreementURLForEnvironment:(HXSEnvironmentType) type // 取现协议
{
    switch(type) {
        case HXSEnvironmentProduct:
            return @"http://appdoc.59store.com/Public/html/cashinstallment_protocol.html";
        case HXSEnvironmentTemai:
            return @"http://appdoc.59temai.com/Public/html/cashinstallment_protocol.html";
        case HXSEnvironmentStage:
            return @"http://appdoc.59store.net/Public/html/cashinstallment_protocol.html";
        case HXSEnvironmentQA:
            return @"http://appdoc.59shangcheng.com/Public/html/cashinstallment_protocol.html";
        default:
            break;
    }
    return @"http://appdoc.59store.com/Public/html/cashinstallment_protocol.html";
}


- (NSString *)currentMobileStagingAgreementURLForEnvironment:(HXSEnvironmentType) type // 3c数码协议
{
    switch(type) {
        case HXSEnvironmentProduct:
            return @"http://appdoc.59store.com/Public/html/mobilestaging_protocol.html";
        case HXSEnvironmentTemai:
            return @"http://appdoc.59temai.com/Public/html/mobilestaging_protocol.html";
        case HXSEnvironmentStage:
            return @"http://appdoc.59store.net/Public/html/mobilestaging_protocol.html";
        case HXSEnvironmentQA:
            return @"http://appdoc.59shangcheng.com/Public/html/mobilestaging_protocol.html";
        default:
            break;
    }
    return @"http://appdoc.59store.com/Public/html/mobilestaging_protocol.html";
}

- (NSString *)currentBillStageAgreementURLForEnvironment:(HXSEnvironmentType) type // 账单分期协议
{
    switch(type) {
        case HXSEnvironmentProduct:
            return @"http://appdoc.59store.com/Public/html/billstage_protocal.html";
        case HXSEnvironmentTemai:
            return @"http://appdoc.59temai.com/Public/html/billstage_protocal.html";
        case HXSEnvironmentStage:
            return @"http://appdoc.59store.net/Public/html/billstage_protocal.html";
        case HXSEnvironmentQA:
            return @"http://appdoc.59shangcheng.com/Public/html/billstage_protocal.html";
        default:
            break;
    }
    return @"http://appdoc.59store.com/Public/html/billstage_protocal.html";
}

- (NSString *)invitationURLForEnvironment: (HXSEnvironmentType) type {
    switch(type) {
        case HXSEnvironmentProduct:
        return @"http://appdoc.59store.com/web/invitation";
        case HXSEnvironmentTemai:
        return @"http://appdoc.59temai.com/web/invitation";
        case HXSEnvironmentStage:
        return @"http://appdoc.59store.net/web/invitation";
        case HXSEnvironmentQA:
        return @"http://appdoc.59shangcheng.com/web/invitation";
        default:
        break;
    }
    return @"http://appdoc.59store.com/web/invitation";
}

- (NSString *)boxProtocolURLForEnvironment: (HXSEnvironmentType) type {
    switch(type) {
        case HXSEnvironmentProduct:
        return @"http://appdoc.59store.com/web/boxProtocol";
        case HXSEnvironmentTemai:
        return @"http://appdoc.59temai.com/web/boxProtocol";
        case HXSEnvironmentStage:
        return @"http://appdoc.59store.net/web/boxProtocol";
        case HXSEnvironmentQA:
        return @"http://appdoc.59shangcheng.com/web/boxProtocol";
        default:
        break;
    }
    return @"http://appdoc.59store.com/web/boxProtocol";
}

- (NSString *)pointURLForEnvironment:(HXSEnvironmentType) type
{
    switch(type) {
        case HXSEnvironmentProduct:
            return @"http://credit.59store.com";
        case HXSEnvironmentTemai:
            return @"http://credit.59temai.com";
        case HXSEnvironmentStage:
            return @"http://credit.59store.net";
        case HXSEnvironmentQA:
            return @"http://credit.59shangcheng.com";
        default:
            break;
    }
    return @"http://credit.59store.com";
}

- (NSString *)forgetPasswordURLForEnvironment:(HXSEnvironmentType) type {
    switch (type) {
        case HXSEnvironmentProduct:
            return @"http://account.59store.com/find?userAgent=app";
        case HXSEnvironmentTemai:
            return @"http://account.59temai.com/find?userAgent=app";
        case HXSEnvironmentStage:
            return @"http://account.59store.net/find?userAgent=app";
        case HXSEnvironmentQA:
            return @"http://account.59shangcheng.com/find?userAgent=app";
        default:
            break;
    }
    
    return @"http://account.59store.com/find?userAgent=app";
}

- (NSString *)zmCreditURLForEnvironment:(HXSEnvironmentType) type {
    switch (type) {
        case HXSEnvironmentProduct:
            return @"http://zm.59store.com";
        case HXSEnvironmentTemai:
            return @"http://zm.59temai.com";
        case HXSEnvironmentStage:
            return @"http://zm.59store.net";
        case HXSEnvironmentQA:
            return @"http://zm.59shangcheng.com";
        default:
            break;
    }
    
    return @"http://zm.59store.com";
}

- (NSString *)storeManagerURLForEnvironment:(HXSEnvironmentType) type {
    switch (type) {
        case HXSEnvironmentProduct:
            return @"http://gala.59store.com/static/dormapply/";
        case HXSEnvironmentTemai:
            return @"http://gala.59shangcheng.com/static/dormapply/";
        case HXSEnvironmentStage:
            return @"http://gala.59store.net/static/dormapply/";
        case HXSEnvironmentQA:
            return @"http://gala.59shangcheng.com/static/dormapply/";
        default:
            break;
    }
    
    return @"http://gala.59store.com/static/dormapply/";
}

- (NSString *)creditCentsURLForEnvironment:(HXSEnvironmentType) type
{
    switch (type) {
        case HXSEnvironmentProduct:
            return @"http://credit.59store.com/myIntegral.html";
        case HXSEnvironmentTemai:
            return @"http://credit.59temai.com/myIntegral.html";
        case HXSEnvironmentStage:
            return @"http://credit.59store.net/myIntegral.html";
        case HXSEnvironmentQA:
            return @"http://credit.59shangcheng.com/myIntegral.html";
        default:
            break;
    }
    
    return @"http://credit.59store.com/myIntegral.html";
}

- (NSString *)knightRegisterURLForEnvironment:(HXSEnvironmentType) type{
    switch (type) {
        case HXSEnvironmentProduct:
            return @"http://gala.59store.com/knight-apply/dist/index.html";
        case HXSEnvironmentTemai:
            return @"http://gala.59shangcheng.com/knight-apply/dist";
        case HXSEnvironmentStage:
            return @"http://gala.59store.net/knight-apply/dist/index.html";
        case HXSEnvironmentQA:
            return @"http://gala.59shangcheng.com/knight-apply/dist/index.html";
        default:
            break;
    }
    
    return @"http://gala.59store.com/knight-apply/dist/index.html";
}

#pragma mark OSS SDK Setting

- (NSString *)ossSDKAccessKeyId
{
    return [self ossSDKAccessKeyIdForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)ossSDKAccessKeySecret
{
    return [self ossSDKAccessKeySecretForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)ossSDKEndpoint
{
    return [self ossSDKEndpointForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)ossSDKBucketName
{
    return [self ossSDKBucketNameForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)ossSDKDomainName
{
    return [self ossSDKDomainNameForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)ossSDKShopLogoDomainName
{
    return [self ossSDKShopLogoDomainNameForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)ossSDKAccessKeyIdForEnvironment:(HXSEnvironmentType)type
{
    switch (type) {
        case HXSEnvironmentProduct:
            return @"vxHYcjeAQgjiUa1H";
        case HXSEnvironmentTemai:
            return @"vxHYcjeAQgjiUa1H";
        case HXSEnvironmentStage:
            return @"vxHYcjeAQgjiUa1H";
        case HXSEnvironmentQA:
            return @"vxHYcjeAQgjiUa1H";
        default:
            break;
    }
    
    return @"vxHYcjeAQgjiUa1H";
}

- (NSString *)ossSDKAccessKeySecretForEnvironment:(HXSEnvironmentType)type
{
    switch (type) {
        case HXSEnvironmentProduct:
            return @"I2TIn74UydTjOM7XMgsyqktsOXn7ke";
        case HXSEnvironmentTemai:
            return @"I2TIn74UydTjOM7XMgsyqktsOXn7ke";
        case HXSEnvironmentStage:
            return @"I2TIn74UydTjOM7XMgsyqktsOXn7ke";
        case HXSEnvironmentQA:
            return @"I2TIn74UydTjOM7XMgsyqktsOXn7ke";
        default:
            break;
    }
    
    return @"I2TIn74UydTjOM7XMgsyqktsOXn7ke";
}

- (NSString *)ossSDKEndpointForEnvironment:(HXSEnvironmentType)type
{
    switch (type) {
        case HXSEnvironmentProduct:
            return @"http://oss-cn-hangzhou.aliyuncs.com";
        case HXSEnvironmentTemai:
            return @"http://oss-cn-hangzhou.aliyuncs.com";
        case HXSEnvironmentStage:
            return @"http://oss-cn-hangzhou.aliyuncs.com";
        case HXSEnvironmentQA:
            return @"http://oss-cn-hangzhou.aliyuncs.com";
        default:
            break;
    }
    
    return @"http://oss-cn-hangzhou.aliyuncs.com";
}

- (NSString *)ossSDKBucketNameForEnvironment:(HXSEnvironmentType)type
{
    switch (type) {
        case HXSEnvironmentProduct:
            return @"print-identification";
        case HXSEnvironmentTemai:
            return @"print-identification";
        case HXSEnvironmentStage:
            return @"print-identification";
        case HXSEnvironmentQA:
            return @"print-identification";
        default:
            break;
    }
    
    return @"print-identification";
}

- (NSString *)ossSDKDomainNameForEnvironment:(HXSEnvironmentType)type
{
    switch (type) {
        case HXSEnvironmentProduct:
            return @"http://print-identification.oss-cn-hangzhou.aliyuncs.com";
        case HXSEnvironmentTemai:
            return @"http://print-identification.oss-cn-hangzhou.aliyuncs.com";
        case HXSEnvironmentStage:
            return @"http://print-identification.oss-cn-hangzhou.aliyuncs.com";
        case HXSEnvironmentQA:
            return @"http://print-identification.oss-cn-hangzhou.aliyuncs.com";
        default:
            break;
    }
    
    return @"http://print-identification.oss-cn-hangzhou.aliyuncs.com";
}

- (NSString *)ossSDKShopLogoDomainNameForEnvironment:(HXSEnvironmentType)type
{
    switch (type) {
        case HXSEnvironmentProduct:
            return @"http://dorm-shop-logo.oss-cn-hangzhou.aliyuncs.com/";
        case HXSEnvironmentTemai:
            return @"http://dorm-shop-logo.oss-cn-hangzhou.aliyuncs.com/";
        case HXSEnvironmentStage:
            return @"http://dorm-shop-logo.oss-cn-hangzhou.aliyuncs.com/";
        case HXSEnvironmentQA:
            return @"http://dorm-shop-logo.oss-cn-hangzhou.aliyuncs.com/";
        default:
            break;
    }
    
    return @"http://dorm-shop-logo.oss-cn-hangzhou.aliyuncs.com/";
}

- (NSString *)currentCreditPayAgreementURL
{
    return [self creditPayAgreementURLForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)currentCashInstallmentAgreementURL // 取现协议
{
    return [self currentCashInstallmentAgreementURLForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)currentMobileStagingAgreementURL // 3c数码协议

{
    return [self currentMobileStagingAgreementURLForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)currentBillStageAgreementURL // 账单分期协议
{
    return [self currentMobileStagingAgreementURLForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)currentInvitationURL
{
    return [self invitationURLForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)currentBoxProtocolURL
{
    return [self boxProtocolURLForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)currentPointURL
{
    return [self pointURLForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)currentForgetPasswordURL {
    return [self forgetPasswordURLForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)currentZmCreditURL {
    return [self zmCreditURLForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)currentPrintURL {
    return @"http://gala.59store.com/static/printcourse/ios.html";
}

- (NSString *)currentReportURL{
    return @"http://gala.59shangcheng.com/report-tip/";
}

- (NSString *)knightRegisterURL{
    return [self knightRegisterURLForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)huaBuWanFAQURL
{
    return @"http://mp.weixin.qq.com/s?__biz=MzA5NTQ4ODAxNg==&mid=402141254&idx=1&sn=1b3a53db560596c32eb6be8276524793#rd";
}

- (NSString *)WalletFAQURLString
{
    return @"http://mp.weixin.qq.com/s?__biz=MzA5NTQ4ODAxNg==&mid=413964696&idx=1&sn=9563e9201c0bb7824b6ac609f780b9e6&scene=0&previewkey=QJxqVBey0PN3bRmAd1NGi8NS9bJajjJKzz%2F0By7ITJA%3D#wechat_redirect";
}

- (NSString *)installmentStoreFAQURLString
{
    return @"http://mp.weixin.qq.com/s?__biz=MzA5NTQ4ODAxNg==&mid=413964881&idx=1&sn=02437d53b1445d9001e60f4f94e5b2c7&scene=0&previewkey=QJxqVBey0PN3bRmAd1NGi8NS9bJajjJKzz%2F0By7ITJA%3D#wechat_redirect";
}

- (NSString *)registerStoreManagerBaseURL
{
    return [self storeManagerURLForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)creditCentsURL
{
    return [self creditCentsURLForEnvironment:[self currentEnvironmentType]];
}

//==============================================================

- (HXSElemeContactInfo*)cacheElemeContactInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:kHXSElemeContactCacheInfo];
    if (encodedObject == nil) {
        return nil;
    }
    
    HXSElemeContactInfo *info = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return info;
}
- (void)setCacheElemeContactInfo:(HXSElemeContactInfo*)info
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:info];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:kHXSElemeContactCacheInfo];
    [defaults synchronize];
}

- (void)clearCacheElemeContactInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHXSElemeContactCacheInfo];
}

//==============================================================

- (NSArray *)addressSearchHistoryList
{
    NSArray *list = [[NSUserDefaults standardUserDefaults] objectForKey: kHXSAddressSearchHistoryKey];
    return list;
}

- (void)addAddressSearchHistory:(NSString *)address
{
    NSArray *list = [[NSUserDefaults standardUserDefaults] objectForKey: kHXSAddressSearchHistoryKey];
    NSMutableArray *searchList;
    if (list.count > 0) {
        searchList = [NSMutableArray arrayWithArray:list];
        NSInteger idx = [searchList indexOfObject:address];
        if (idx >= 0 && idx < list.count) {
            [searchList removeObjectAtIndex:idx];
        }
        
        [searchList insertObject:address atIndex:0];
        if (searchList.count > 10) {
            [searchList removeLastObject];
        }
    }
    else {
        searchList = [NSMutableArray arrayWithObject:address];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:searchList forKey:kHXSAddressSearchHistoryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 便利店搜索历史
- (NSArray *)storeSearchHistoryList {
    return  [[NSUserDefaults standardUserDefaults] objectForKey:kHXSStoreSearchHistoryKey];
}

- (void)addStoreSearchHistory:(NSString *)itemName {
    
    NSArray *list = [[NSUserDefaults standardUserDefaults] objectForKey: kHXSStoreSearchHistoryKey];
    NSMutableArray *searchList;
    if (list.count > 0) {
        searchList = [NSMutableArray arrayWithArray:list];
        NSInteger idx = [searchList indexOfObject:itemName];
        if (idx >= 0 && idx < list.count) {
            [searchList removeObjectAtIndex:idx];
        }
        
        [searchList insertObject:itemName atIndex:0];
        if (searchList.count > 10) {
            [searchList removeLastObject];
        }
    } else {
        searchList = [NSMutableArray arrayWithObject:itemName];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:searchList forKey:kHXSStoreSearchHistoryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//==============================================================

- (BOOL)isLocationDisabled
{
    /* Delete this function from APP, So always to set NO.
    NSNumber *hasBeenDenied = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LOCATION_HAS_BEEN_DENIED];
    
    return [hasBeenDenied boolValue];
     */
    
    return NO;
}

- (void)setLocationDisability:(BOOL)disable
{
    NSNumber *hasBeenDenied = [NSNumber numberWithBool:disable];
    
    [[NSUserDefaults standardUserDefaults] setObject:hasBeenDenied forKey:USER_DEFAULT_LOCATION_HAS_BEEN_DENIED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//==============================================================

- (BOOL)isRecommendBoxHidden
{
    NSNumber *isHidden = [[NSUserDefaults standardUserDefaults] objectForKey:kHXSRecommendBoxHiddenKey];
    
    return [isHidden boolValue];
}

- (void)setRecommendBoxHidden:(BOOL)hidden
{
    NSNumber *isHidden = [NSNumber numberWithBool:hidden];
    
    [[NSUserDefaults standardUserDefaults] setObject:isHidden forKey:kHXSRecommendBoxHiddenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)currentOneDreamDetailURL
{
    return [self oneDreamDetialURLForEnvironment:[self currentEnvironmentType]];
}

- (NSString *)oneDreamDetialURLForEnvironment: (HXSEnvironmentType) type {
    switch(type) {
        case HXSEnvironmentProduct:
            return @"http://onedream.59store.com/#/detail/";
        case HXSEnvironmentTemai:
            return @"http://onedream.59temai.com/#/detail/";
        case HXSEnvironmentStage:
            return @"http://onedream.59store.net/#/detail/";
        case HXSEnvironmentQA:
            return @"http://onedream.59shangcheng.com/#/detail/";
        default:
            break;
    }
    return @"http://onedream.59store.com/#/detail/";
}

// 选择地址 默认学校和楼栋
- (NSNumber *)defaultSiteID
{
    HXSEnvironmentType type = [self currentEnvironmentType];
    switch(type) {
        case HXSEnvironmentProduct:
            return @(228);
        case HXSEnvironmentTemai:
            return @(228);
        case HXSEnvironmentStage:
            return @(228);
        case HXSEnvironmentQA:
            return @(228);
        default:
            break;
    }
    return @(228);
}
- (NSNumber *)defaultDormentryID
{
    HXSEnvironmentType type = [self currentEnvironmentType];
    switch(type) {
        case HXSEnvironmentProduct:
            return @(203406);
        case HXSEnvironmentTemai:
            return @(3108);
        case HXSEnvironmentStage:
            return @(203406);
        case HXSEnvironmentQA:
            return @(3108);
        default:
            break;
    }
    return @(203406);
}

@end

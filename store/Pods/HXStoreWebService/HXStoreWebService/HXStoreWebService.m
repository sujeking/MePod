//
//  HXStoreWebService.m
//  Pods
//
//  Created by ArthurWang on 16/6/8.
//
//

#import "HXStoreWebService.h"

#import <CommonCrypto/CommonCrypto.h>
#import "sys/utsname.h"

#import "HXWebService.h"
#import "HXAppDeviceHelper.h"
#import "HXAppConfig.h"
#import "NSString+Addition.h"
#import "HXMacrosUtils.h"
#import "HXSMediator+AccountModule.h"
#import "HXSMediator+LocationModule.h"
#import "NSMutableDictionary+Safety.h"
#import "ApplicationSettings.h"


#define kHXSSecret   @"c0e17d5418074da684843e12a16051d9"

static const NSArray<NSString *> *specialURLsArr;

@implementation HXStoreWebService

#pragma mark - Initial Methods

+ (HXWebService *)webService
{
    static HXWebService *webService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *userAgent = [NSString stringWithFormat:@"%@/%@; iOS %@; %.0fX%.0f/%0.1f", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleNameKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] systemVersion], SCREEN_WIDTH*[[UIScreen mainScreen] scale],SCREEN_HEIGHT*[[UIScreen mainScreen] scale], [[UIScreen mainScreen] scale]];
        if (userAgent) {
            if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                NSMutableString *mutableUserAgent = [userAgent mutableCopy];
                if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                    userAgent = mutableUserAgent;
                }
            }
        }
        
        NSString *userAgentStr = [NSString stringWithFormat:@"%@; %@; %@", [HXAppDeviceHelper modelString], userAgent,[NSString stringWithFormat:@"IsJailbroken/%d",[HXAppDeviceHelper isJailbroken]]];
        NSString *deviceIDStr = [HXAppDeviceHelper uniqueDeviceIdentifier];
        
        webService = [[HXWebService alloc] createWebServiceWithUserAgent:userAgentStr
                                                                deviceID:deviceIDStr];
        
        
        // 特殊处理的URL
        specialURLsArr = @[HXS_CITY_LIST,
                           HXS_CITY_SITE_LIST,
                           HXS_DORMENTRY_LIST,
                           HXS_SHOP_LIST,
                           HXS_SHOP_CATEGORY,
                           HXS_SHOP_ITEMS,
                           HXS_STORE_INLET
                           ];
    });
    
    return webService;
}


#pragma mark - Core

+ (void)handleSuccess:(BOOL)isPost
                 path:(NSString*)path
           parameters:(NSDictionary*)parameters
            operation:(NSURLSessionDataTask *)op
                 json:(id)json
              success:(void (^)(HXSErrorCode status, NSString * msg, NSDictionary * data))success
              failure:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))failure
{
    DLog(@"%@ handleSuccess", path);
    
    [HXStoreWebService onResponseData:json
                       success:success
                       failure:failure];
    
}

+ (void)handleFailure:(BOOL)isPost
                 path:(NSString*)path
           parameters:(NSDictionary*)parameters
            operation:(NSURLSessionDataTask *)op
                error:(NSError*)error
              success:(void (^)(HXSErrorCode status, NSString * msg, NSDictionary * data))success
              failure:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))failure
{
    if([error.domain isEqualToString:@"NSURLErrorDomain"]
       && error.code == kHXSNetworkingCancelError)
    {//增加上传取消操作后的error code 判断
        failure(kHXSNetworkingCancelError, @"网络请求取消", nil);
        return;
    }
    failure(kHXSNetWorkError, @"网络错误", nil);
}


#pragma mark - Public Methods

#pragma mark - POST

+ (NSURLSessionDataTask *)postRequest:(NSString*)path
                           parameters:(id)parameters
                             progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                              success:(void (^)(HXSErrorCode status, NSString * msg, NSDictionary * data))success
                              failure:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))failure

{
    DLog(@"Request Start %@", [NSDate date]);
    DLog(@"Request %@", path);
    DLog(@"Params %@", parameters);
    
    NSString *baseURLStr = [HXStoreWebService selectBaseURLWithPath:path];
    parameters = [HXStoreWebService signDictionary:parameters];
    
    NSURLSessionDataTask *task = [[HXStoreWebService webService]
                                  postWithBaseUrl:baseURLStr
                                  path:path
                                  parameters:parameters
                                  progress:uploadProgress
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      [HXStoreWebService handleSuccess:YES
                                                                  path:path
                                                            parameters:parameters
                                                             operation:task
                                                                  json:responseObject
                                                               success:success
                                                               failure:failure];
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      DLog(@"Request End Faile %@", [NSDate date]);
                                      [HXStoreWebService handleFailure:YES
                                                                  path:path
                                                            parameters:parameters
                                                             operation:task
                                                                 error:error
                                                               success:success
                                                               failure:failure];
                                  }];
    
    
    return task;
}


#pragma mark - GET

+ (NSURLSessionDataTask *)getRequest:(NSString*)path
                          parameters:(NSDictionary*)parameters
                            progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                             success:(void (^)(HXSErrorCode status, NSString * msg, NSDictionary * data))success
                             failure:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))failure
{
    DLog(@"Request Start %@", [NSDate date]);
    DLog(@"Request %@", path);
    DLog(@"Params %@", parameters);
    
    NSString *baseURLStr = [HXStoreWebService selectBaseURLWithPath:path];
    
    if ([HXStoreWebService containedUrl:path]) {
        
        parameters = [HXStoreWebService signDictionary:parameters];
        
        NSMutableDictionary *headerFieldMDic = [[NSMutableDictionary alloc] initWithCapacity:5];
        [headerFieldMDic setObject:[parameters objectForKey:@"device_id"] forKey:@"device_id"];
        [headerFieldMDic setObject:[parameters objectForKey:@"token"] forKey:@"token"];
        [headerFieldMDic setObject:[parameters objectForKey:@"time"] forKey:@"time"];
        [headerFieldMDic setObject:[parameters objectForKey:@"sign"] forKey:@"sign"];
        
        [[HXStoreWebService webService] updateRequestSerializerHeadFieldWithDic:headerFieldMDic
                                                                        baseURL:baseURLStr];

        [parameters setValue:nil forKey:@"device_id"];
        
        [parameters setValue:nil forKey:@"token"];
        
        [parameters setValue:nil forKey:@"time"];
        
        [parameters setValue:nil forKey:@"sign"];
        
    } else {
        parameters = [HXStoreWebService signDictionary:parameters];
    }
    
    NSURLSessionDataTask *task = [[HXStoreWebService webService]
                                  getWithBaseUrl:baseURLStr
                                  path:path
                                  parameters:parameters
                                  progress:downloadProgress
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      [HXStoreWebService handleSuccess:NO
                                                           path:path
                                                     parameters:parameters
                                                      operation:task
                                                           json:responseObject
                                                        success:success
                                                        failure:failure];
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      DLog(@"Request End Faile %@", [NSDate date]);
                                      
                                      [HXStoreWebService handleFailure:NO
                                                           path:path
                                                     parameters:parameters
                                                      operation:task
                                                          error:error
                                                        success:success
                                                        failure:failure];
                                  }];
    
    return task;
}


#pragma mark - UPLOAD

+ (NSURLSessionDataTask *)uploadRequest:(NSString*)path
                             parameters:(NSDictionary*)parameters
                          formDataArray:(NSArray *)formDataArray
                               progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                success:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary *data))success
                                failure:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary *data))failure
{
    DLog(@"Request Start %@", [NSDate date]);
    DLog(@"Request %@", path);
    DLog(@"Params %@", parameters);
    
    NSString *baseURLStr = [HXStoreWebService selectBaseURLWithPath:path];
    
    parameters = nil; // Don't send paramenter, If send parameters, the server returns error
    
    NSURLSessionDataTask *task = [[HXStoreWebService webService]
                                  uploadWithBaseUrl:baseURLStr
                                  path:path
                                  parameters:parameters
                                  formDataArray:formDataArray
                                  progress:uploadProgress
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      DLog(@"Request End Success %@", [NSDate date]);
                                      
                                      [HXStoreWebService handleSuccess:YES
                                                           path:path
                                                     parameters:parameters
                                                      operation:task
                                                           json:responseObject
                                                        success:success
                                                        failure:failure];
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      DLog(@"Request End Faile %@", [NSDate date]);
                                      [HXStoreWebService handleFailure:YES
                                                           path:path
                                                     parameters:parameters
                                                      operation:task
                                                          error:error
                                                        success:success
                                                        failure:failure];
                                  }];
    
    
    
    
    return task;
}



#pragma mark - PUT

+ (NSURLSessionDataTask *)putRequest:(NSString*)path
                          parameters:(NSDictionary*)parameters
                             success:(void (^)(HXSErrorCode status, NSString * msg, NSDictionary * data))success
                             failure:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))failure
{
    DLog(@"Request Start %@", [NSDate date]);
    DLog(@"Request %@", path);
    DLog(@"Params %@", parameters);
    
    NSString *baseURLStr = [HXStoreWebService selectBaseURLWithPath:path];
    
    parameters = [HXStoreWebService signDictionary:parameters];
    
    NSURLSessionDataTask *task = [[HXStoreWebService webService]
                                  putWithBaseUrl:baseURLStr
                                  path:path
                                  parameters:parameters
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      [HXStoreWebService handleSuccess:YES
                                                           path:path
                                                     parameters:parameters
                                                      operation:task
                                                           json:responseObject
                                                        success:success
                                                        failure:failure];
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      DLog(@"Request End Faile %@", [NSDate date]);
                                      [HXStoreWebService handleFailure:YES
                                                           path:path
                                                     parameters:parameters
                                                      operation:task
                                                          error:error
                                                        success:success
                                                        failure:failure];
                                  }];
    
    
    return task;
}


#pragma mark - DELETE

+ (NSURLSessionDataTask *)deleteRequest:(NSString*)path
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(HXSErrorCode status, NSString * msg, NSDictionary * data))success
                                failure:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))failure
{
    DLog(@"Request Start %@", [NSDate date]);
    DLog(@"Request %@", path);
    DLog(@"Params %@", parameters);
    
    NSString *baseURLStr = [HXStoreWebService selectBaseURLWithPath:path];
    
    parameters = [HXStoreWebService signDictionary:parameters];
    
    NSURLSessionDataTask *task = [[HXStoreWebService webService]
                                  deleteWithBaseUrl:baseURLStr
                                  path:path
                                  parameters:parameters
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      [HXStoreWebService handleSuccess:YES
                                                           path:path
                                                     parameters:parameters
                                                      operation:task
                                                           json:responseObject
                                                        success:success
                                                        failure:failure];
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      DLog(@"Request End Faile %@", [NSDate date]);
                                      [HXStoreWebService handleFailure:YES
                                                           path:path
                                                     parameters:parameters
                                                      operation:task
                                                          error:error
                                                        success:success
                                                        failure:failure];
                                  }];
    
    return task;
}


#pragma mark - Private Methods

+ (BOOL)containedUrl:(NSString *)urlString
{
    for (NSString *str in specialURLsArr) {
        if ([str isEqualToString:urlString]) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSDictionary *)signDictionary:(NSDictionary *)dic
{
    if ((nil == dic)
        || [dic isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dicReal = [NSMutableDictionary dictionaryWithDictionary:dic];
        if (dicReal == nil) {
            dicReal = [NSMutableDictionary dictionary];
        }
        
        //addtime
        NSString * timeStr = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
        [dicReal addEntriesFromDictionary:@{@"time":timeStr,
                                            SYNC_DEVICE_TYPE:@0,   //ios 0
                                            SYNC_APP_VERSION:[HXAppConfig sharedInstance].appVersion,
                                            @"protocol_version":@"2.0.0",
                                            SYNC_DEVICE_ID:[HXAppDeviceHelper uniqueDeviceIdentifier],
                                            }];
        
        if ([dic objectForKey:SYNC_USER_TOKEN] == nil) {
            NSString *tokenStr = [[HXSMediator sharedInstance] HXSMediator_token];
            [dicReal setObjectExceptNil:tokenStr forKey:SYNC_USER_TOKEN];
        }
        
        NSNumber *siteIDIntNum = [[HXSMediator sharedInstance] HXSMediator_currentSiteID];
        
        if ((nil != siteIDIntNum)
            && [dic objectForKey:SYNC_SITE_ID] == nil) {
            [dicReal setObject:siteIDIntNum
                        forKey:SYNC_SITE_ID];
        }
        
        NSString * md5String = [HXStoreWebService calcSignStringWithArr:dicReal];
        [dicReal addEntriesFromDictionary:@{@"sign":md5String}];

        return dicReal;
    } else {
        return [NSDictionary dictionary];
    }
}

+ (NSString *)calcSignStringWithArr:(NSDictionary *)dicReal
{
    NSMutableString *start = [[NSMutableString alloc] init];
    NSArray *keys = [dicReal allKeys];
    
    //keys按字母顺序排序
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
            {
                NSString * str1 = (NSString *)obj1;
                NSString * str2 = (NSString *)obj2;
                return [str1 compare:str2];
            }];
    for (NSString *key in keys) {
        [start appendFormat:@"%@=%@&", key, [dicReal objectForKey:key]];
    }
    
    [start appendFormat:@"%@", kHXSSecret];
    
    NSString * md5String = [NSString md5: start];
    
    return md5String;
}

+ (void)onResponseData:(id)responseObject
               success:(void (^)(HXSErrorCode status, NSString * msg, NSDictionary * data))success
               failure:(void (^)(HXSErrorCode status, NSString *msg, NSDictionary * data))failure
{
    id json = responseObject;
    
    if(json && [json isKindOfClass:[NSDictionary class]]) {
        if(DIC_HAS_NUMBER(json, SYNC_RESPONSE_STATUS)) {
            id message = [json objectForKey:SYNC_RESPONSE_MSG];
            NSString * msg = [message isKindOfClass:[NSString class]] ? message : @"";
            int status = [[json objectForKey:SYNC_RESPONSE_STATUS] intValue];
            NSDictionary * data = [json objectForKey:SYNC_RESPONSE_DATA];
            
            if(status == kHXSNoError) {
                if(!data || ![data isKindOfClass:[NSDictionary class]]) {
                    data = [NSDictionary dictionary];
                }
                success(status, msg, data);
                
            }else if (status == kHXSNormalError) {
                failure(status, msg, data);
            }else if(status == kHXSInvalidTokenError) {
                //token error 单独处理
                BEGIN_MAIN_THREAD
                [[HXSMediator sharedInstance] HXSMediator_logout];
                [[HXSMediator sharedInstance] HXSMediator_updateToken];
                END_MAIN_THREAD
                    
                    failure(status, msg, data);
            }else if(msg != nil) {
                failure(status, msg, data);
            }else {
                failure(kHXSUnknownError, @"未知错误-1000", data);
            }
        }else {
            failure(kHXSUnknownError, @"未知错误-1001", nil);
        }
    }else {
        failure(kHXSUnknownError, @"未知错误-1002", nil);
    }
}

+ (NSString *)webServiceCurrentDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *now = [[NSDate alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [dateFormatter stringFromDate:now];
}

+ (NSString *)selectBaseURLWithPath:(NSString *)pathStr
{
    NSString *baseURLStr = nil;
    
    if([pathStr isEqualToString:HXS_BORROW_SUBMIT]) { //信用钱包申请接口走https
        baseURLStr = [[ApplicationSettings instance] currentHttpsServiceURL];
    } else {
        baseURLStr = [[ApplicationSettings instance] currentServiceURL];
    }
    
    return baseURLStr;
}

@end

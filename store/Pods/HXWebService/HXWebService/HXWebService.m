//
//  HXWebService.m
//  Pods
//
//  Created by ArthurWang on 16/6/6.
//
//

#import "HXWebService.h"

#import "AFNetworking.h"


#define DEFAULT_BASE_URL @"base_url"

@interface HXWebService ()

/** key is urlString, value is AFHTTPSessionManager */
@property (nonatomic, strong) NSMutableDictionary *sessionManagerMDic;

@property (nonatomic, strong) NSString *userAgentStr;
@property (nonatomic, strong) NSString *deviceIDStr;

@end

@implementation HXWebService

#pragma mark - Initial Methods

- (instancetype)createWebServiceWithUserAgent:(NSString *)userAgentStr
                                     deviceID:(NSString *)deviceIDStr
{
    HXWebService *webService = [[HXWebService alloc] init];
    
    webService.userAgentStr = userAgentStr;
    webService.deviceIDStr  = deviceIDStr;
    
    return webService;
}

- (AFHTTPSessionManager *)createSessionManagerWithUrl:(NSString *)urlString
{
    if (nil == urlString) {
        urlString = DEFAULT_BASE_URL;
    }
    
    AFHTTPSessionManager *sessionManager = [self.sessionManagerMDic objectForKey:urlString];
    
    if (nil != sessionManager) {
        return sessionManager;
    }
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存5M
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                      diskCapacity:50 * 1024 * 1024
                                                          diskPath:nil];
    
    [config setURLCache:cache];
    
    AFHTTPSessionManager *sharedClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]
                                             sessionConfiguration:config];
    
    // response
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    NSMutableSet *acceptContentTypes = [NSMutableSet setWithSet:response.acceptableContentTypes];
    [acceptContentTypes addObject:@"text/plain"];
    response.acceptableContentTypes = acceptContentTypes;
    sharedClient.responseSerializer = response;
    
    // request
    sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
    [sharedClient.requestSerializer setValue:self.userAgentStr forHTTPHeaderField:@"User-Agent"];
    [sharedClient.requestSerializer setValue:self.deviceIDStr forHTTPHeaderField:@"device_id"];
    
    sharedClient.securityPolicy.allowInvalidCertificates = YES;
    
    // set key & value
    [self.sessionManagerMDic setObject:sharedClient forKey:urlString];
    
    return sharedClient;
    
}



#pragma mark - Public Methods

- (void)updateRequestSerializerHeadFieldWithDic:(NSDictionary *)dic baseURL:(NSString *)baseUrlStr
{
    AFHTTPSessionManager *manager = [self createSessionManagerWithUrl:baseUrlStr];
    
    for (NSString *key in [dic allKeys]) {
        [manager.requestSerializer setValue:[dic objectForKey:key]
                         forHTTPHeaderField:key];
    }
}

#pragma mark - POST

- (NSURLSessionDataTask *)postWithBaseUrl:(NSString *)baseUrlStr
                                     path:(NSString *)path
                               parameters:(id)parameters
                                 progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [self createSessionManagerWithUrl:baseUrlStr];
    
    if (nil == parameters) {
        parameters = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [manager POST:path
                                    parameters:parameters
                                      progress:uploadProgress
                                       success:success
                                       failure:failure];
    
    return task;
}


#pragma mark - GET

- (NSURLSessionDataTask *)getWithBaseUrl:(NSString *)baseUrlStr
                                    path:(NSString *)path
                              parameters:(NSDictionary *)parameters
                                progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [self createSessionManagerWithUrl:baseUrlStr];
    
    if (nil == parameters) {
        parameters = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [manager GET:path
                                   parameters:parameters
                                     progress:downloadProgress
                                      success:success
                                      failure:failure];
    
    return task;
}


#pragma mark - UPLOAD

- (NSURLSessionDataTask *)uploadWithBaseUrl:(NSString *)baseUrlStr
                                       path:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                              formDataArray:(NSArray *)formDataArray
                                   progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [self createSessionManagerWithUrl:baseUrlStr];
    
    if (nil == parameters) {
        parameters = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [manager POST:path
                                    parameters:parameters
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         
                         [formData appendPartWithFileData:[formDataArray objectAtIndex:0]
                                                     name:[formDataArray objectAtIndex:1]
                                                 fileName:[formDataArray objectAtIndex:2]
                                                 mimeType:[formDataArray objectAtIndex:3]];
                     }
                                      progress:uploadProgress
                                       success:success
                                       failure:failure];
    
    return task;
}


#pragma mark - PUT

- (NSURLSessionDataTask * )putWithBaseUrl:(NSString *)baseUrlStr
                                     path:(NSString *)path
                               parameters:(NSDictionary *)parameters
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [self createSessionManagerWithUrl:baseUrlStr];
    
    if (nil == parameters) {
        parameters = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [manager PUT:path parameters:parameters success:success failure:failure];
    
    return task;
    
}


#pragma mark - DELETE

- (NSURLSessionDataTask *)deleteWithBaseUrl:(NSString *)baseUrlStr
                                       path:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [self createSessionManagerWithUrl:baseUrlStr];
    
    if (nil == parameters) {
        parameters = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [manager DELETE:path parameters:parameters success:success failure:failure];
    
    return task;
    
}


#pragma mark - Setter Getter Methods

- (NSMutableDictionary *)sessionManagerMDic
{
    if (nil == _sessionManagerMDic) {
        _sessionManagerMDic = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    
    return _sessionManagerMDic;
}



@end

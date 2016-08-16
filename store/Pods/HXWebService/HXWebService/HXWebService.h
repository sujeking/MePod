//
//  HXWebService.h
//  Pods
//
//  Created by ArthurWang on 16/6/6.
//
//

#import <Foundation/Foundation.h>

@interface HXWebService : NSObject

- (instancetype)createWebServiceWithUserAgent:(NSString *)userAgentStr
                                     deviceID:(NSString *)deviceIDStr;

- (void)updateRequestSerializerHeadFieldWithDic:(NSDictionary *)dic baseURL:(NSString *)baseUrlStr;

- (NSURLSessionDataTask *)postWithBaseUrl:(NSString *)baseUrlStr
                                     path:(NSString *)path
                               parameters:(id)parameters
                                 progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)getWithBaseUrl:(NSString *)baseUrlStr
                                    path:(NSString *)path
                              parameters:(NSDictionary *)parameters
                                progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)uploadWithBaseUrl:(NSString *)baseUrlStr
                                       path:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                              formDataArray:(NSArray *)formDataArray
                                   progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask * )putWithBaseUrl:(NSString *)baseUrlStr
                                     path:(NSString *)path
                               parameters:(NSDictionary *)parameters
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)deleteWithBaseUrl:(NSString *)baseUrlStr
                                       path:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


@end

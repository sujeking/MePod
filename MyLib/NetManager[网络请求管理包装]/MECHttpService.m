//
//  MECHttpService.m
//  MelinkedChat
//
//  Created by Haven on 11/18/15.
//  Copyright (c) 2015 Haven. All rights reserved.
//

#import "MECHttpService.h"
#import <AFNetworking/AFNetworking.h>
#import "XMLWriter.h"


@interface MECHttpService() {
}

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation MECHttpService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Config
- (void)setRequestType:(HttpRequestDataType)requestType {
    _requestType = requestType;
    
    AFHTTPRequestSerializer *requestSerializer = nil;
    switch (_requestType) {
        case HttpRequestBodyTypeJson:
            requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case HttpRequestBodyTypeURLEncode:
            requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        default:
            break;
    }
    
    [_manager setRequestSerializer:requestSerializer];
}

- (void)setResponseType:(HttpResponseDataType)responseType {
    _responseType = responseType;
    
    AFHTTPResponseSerializer *responseSerializer = nil;
    switch (_responseType) {
        case HttpResponseDataTypeText:
            responseSerializer = [AFHTTPResponseSerializer serializer];
            responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
            break;
        case HttpResponseDataTypeHtml:
            responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
            responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
            break;
        case HttpResponseDataTypeJson:
            responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
            responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
            break;
        case HttpResponseDataTypeImage:
            responseSerializer = [AFImageResponseSerializer serializer];
            break;
        case HttpResponseDataTypeData:
            responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case HttpResponseDataTypeStream:
            responseSerializer = [AFHTTPResponseSerializer serializer];
            responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObject:@"application/octet-stream"];
            break;
        default:
            break;
    }
    
    [_manager setResponseSerializer:responseSerializer];
}

#pragma mark - Request with Delegate
- (void)get:(NSString *)url param:(NSDictionary *)param {
    
    [_manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self.delegate respondsToSelector:@selector(success:data:)]) {
            [self.delegate success:self data:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(failed:error:)]) {
            [self.delegate failed:self error:error];
        }
    }];
//    [_manager GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([self.delegate respondsToSelector:@selector(success:data:)]) {
//            [self.delegate success:self data:responseObject];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if ([self.delegate respondsToSelector:@selector(failed:error:)]) {
//            [self.delegate failed:self error:error];
//        }
//    }];
}

- (void)post:(NSString *)url param:(NSDictionary *)param {
    [_manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self.delegate respondsToSelector:@selector(success:data:)]) {
            [self.delegate success:self data:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(failed:error:)]) {
            [self.delegate failed:self error:error];
        }
    }];
    
//    [_manager POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([self.delegate respondsToSelector:@selector(success:data:)]) {
//            [self.delegate success:self data:responseObject];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if ([self.delegate respondsToSelector:@selector(failed:error:)]) {
//            [self.delegate failed:self error:error];
//        }
//    }];
}

- (void)post:(NSString *)url mutilpart:(NSDictionary *)param {
    [_manager POST:url parameters:param constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([self.delegate respondsToSelector:@selector(success:data:)]) {
            [self.delegate success:self data:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(failed:error:)]) {
            [self.delegate failed:self error:error];
        }
    }];
//    [_manager POST:url parameters:param constructingBodyWithBlock:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([self.delegate respondsToSelector:@selector(success:data:)]) {
//            [self.delegate success:self data:responseObject];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if ([self.delegate respondsToSelector:@selector(failed:error:)]) {
//            [self.delegate failed:self error:error];
//        }
//    }];
}

- (void)download:(NSString *)url param:(NSDictionary *)param {
    NSString *paramString = nil;
    if (param) {
        NSMutableString *str = [NSMutableString new];
        NSEnumerator *enumerator = [param keyEnumerator];
        id key;
        while ((key = [enumerator nextObject])) {
            [str appendFormat:@"%@=%@", key, [param objectForKey:key]];
        }
        paramString = str;
    }
    
    
    NSString *new = [NSString stringWithFormat:@"%@?%@",url, paramString];
    //URL特殊字符串转码
    new = [new stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    new = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)new, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", nil, NSUTF8StringEncoding));
    NSURL *inUrl = [NSURL URLWithString:new];
    NSURLRequest *request = [NSURLRequest requestWithURL:inUrl];
    [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat progress = (float)downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount;
        [_delegate updateProgress:progress];
    } destination:nil completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
    }];
    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    //下载进度控制
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        if ([self.delegate respondsToSelector:@selector(updateProgress:)]) {
//            [_delegate updateProgress:(float)totalBytesRead/(float)totalBytesExpectedToRead];
//        }
//        
//    }];
//    //已完成下载
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([self.delegate respondsToSelector:@selector(success:data:)]) {
//            [self.delegate success:self data:responseObject];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if ([self.delegate respondsToSelector:@selector(failed:error:)]) {
//            [self.delegate failed:self error:error];
//        }
//    }];
//    [operation start];
    
}


#pragma mark - Request with Block
- (void)custom:(NSString *)url param:(id)param
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure {
    
    NSError *error = nil;
    
    AFHTTPResponseSerializer *responseSerializer;
    switch (self.responseType) {
        case HttpResponseDataTypeText: {
            responseSerializer = [AFHTTPResponseSerializer serializer];
            responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
            break;
        }
        case HttpResponseDataTypeJson: {
            responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
            responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
            break;
        }
        case HttpResponseDataTypeImage: {
            responseSerializer = [AFImageResponseSerializer serializer];
            break;
        }
        case HttpResponseDataTypeData: {
            responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
        default:
            break;
    }
    
    
    NSMutableURLRequest  *request = [_manager.requestSerializer requestWithMethod:@"POST"
                                                                        URLString:url
                                                                       parameters:param 
                                                                            error:&error];
    
    NSDictionary *funcRequestDic = @{
                                     @"requests": @[@{
                                                        @"global": @{
                                                                @"resultType": @"json"
                                                                }
                                                        },
                                                    param]
                                     };
    [request setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [XMLWriter XMLDataFromDictionary:funcRequestDic encoding:NSUTF8StringEncoding];
    
    _manager.responseSerializer = responseSerializer;
    NSURLSessionDataTask *task = [_manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if (success) success(responseObject);
        }
        else {
            if (failure) failure(error);
        }
    }];
    
    [task resume];
}

- (void)get:(NSString *)url
      param:(id)param
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure {
    
    [_manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)post:(NSString *)url
       param:(id)param
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure {
    
    [_manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)post:(NSString *)url
   mutilpart:(id)param
        body:(NSArray *)files
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure {
    
    [_manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSData *data in files) {
            [formData appendPartWithFileData:data name:@"imagefile" fileName:@"img.jpg" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
//    [_manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (NSData *data in files) {
//            [formData appendPartWithFileData:data name:@"imagefile" fileName:@"img.jpg" mimeType:@"image/jpeg"];
//        }
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
}

- (void)upload:(NSString *)url param:(id)param
          data:(NSData *)data
          name:(NSString *)name
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure {
    [_manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data
                                    name:@"file"
                                fileName:name
                                mimeType:@"application/octet-stream"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
//    [_manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:data
//                                    name:@"file"
//                                fileName:name
//                                mimeType:@"application/octet-stream"];
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
}

- (void)download:(NSString *)url param:(id)param
         process:(void (^)(float percent))process
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure {
    
    NSString *paramString = nil;
    if (param) {
        NSMutableString *str = [NSMutableString new];
        NSEnumerator *enumerator = [param keyEnumerator];
        id key;
        while ((key = [enumerator nextObject])) {
            [str appendFormat:@"%@=%@", key, [param objectForKey:key]];
        }
        paramString = str;
    }
    
    
    NSString *new = [NSString stringWithFormat:@"%@?%@",url, paramString];
    //URL特殊字符串转码
    new = [new stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    new = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)new, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", nil, NSUTF8StringEncoding));
    NSURL *inUrl = [NSURL URLWithString:new];
    NSURLRequest *request = [NSURLRequest requestWithURL:inUrl];
    
//    [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        
//    }];
    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    //下载进度控制
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        if (process) {
//            process((float)totalBytesRead/(float)totalBytesExpectedToRead);
//        }
//    }];
//    //已完成下载
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//    [operation start];
}
@end

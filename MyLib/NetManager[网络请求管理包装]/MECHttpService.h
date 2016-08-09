//
//  MECHttpService.h
//  MelinkedChat
//
//  Created by Haven on 11/18/15.
//  Copyright (c) 2015 Haven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MECBaseModule.h"

typedef NS_ENUM(NSUInteger, HttpResponseDataType) {
    HttpResponseDataTypeText     = 1,    //returned data should be text/plain
    HttpResponseDataTypeHtml     = 2,    //returned data should be text/html
    HttpResponseDataTypeJson     = 3,    //returned data should be json
    HttpResponseDataTypeImage    = 4,    //returned data should be image
    HttpResponseDataTypeData     = 5,    //returned data should NSData object
    HttpResponseDataTypeStream   = 6     //returned data should stream
};

typedef NS_ENUM(NSUInteger, HttpRequestDataType) {
    HttpRequestBodyTypeURLEncode    = 1,
    HttpRequestBodyTypeJson         = 2
};

@class MECHttpService;

@protocol MECHttpServiceDelegate <NSObject>
@optional
- (void)updateProgress:(CGFloat)percent;
- (void)success:(MECHttpService *)net data:(id)data;
- (void)failed:(MECHttpService *)net error:(NSError *)error;

@end

@interface MECHttpService : NSObject
@property (nonatomic, weak) id<MECHttpServiceDelegate> delegate;

@property (nonatomic, assign) HttpRequestDataType  requestType;
@property (nonatomic, assign) HttpResponseDataType responseType;
@property (nonatomic, strong) Class serializerClass;


- (void)get:(NSString *)url param:(NSDictionary *)param;
- (void)post:(NSString *)url param:(NSDictionary *)param;
- (void)post:(NSString *)url mutilpart:(NSDictionary *)param;
- (void)download:(NSString *)url param:(NSDictionary *)param;

//block方式
- (void)custom:(NSString *)url param:(id)param
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;
- (void)get:(NSString *)url
      param:(id)param
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

- (void)post:(NSString *)url
       param:(id)param
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

- (void)post:(NSString *)url
   mutilpart:(id)param
        body:(NSArray *)files
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

- (void)upload:(NSString *)url param:(id)param
          data:(NSData *)data
          name:(NSString *)name
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;

- (void)download:(NSString *)url param:(id)param
         process:(void (^)(float percent))process
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure;
@end

//
//  HXSOSSManager.m
//  store
//
//  Created by J006 on 16/5/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOSSManager.h"

#import "NSData+HXSPrintDataMD5.h"
#import "ApplicationSettings.h"
#import "NSString+Addition.h"
#import "OpenUDID.h"
#import "HXMacrosUtils.h"

@interface HXSOSSManager()

@property (nonatomic, strong) OSSClient *client;

@end

@implementation HXSOSSManager

#pragma mark init

- (void)initTheHXSOSSManager
{
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 60;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc]
                                            initWithPlainTextAccessKey:[[ApplicationSettings instance]ossSDKAccessKeyId]
                                            secretKey:[[ApplicationSettings instance]ossSDKAccessKeySecret]];
    
    NSString *endPoint = [[ApplicationSettings instance] ossSDKEndpoint];
    
    _client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
}

- (OSSPutObjectRequest *)uploadThePrintImage:(UIImage *)image
                                andImageName:(NSString *)imageName
                                    andBlock:(void(^)(NSString *fileURLName ,NSString *errorFileName))block
                                 andProgress:(void(^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progressBlock
{
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    
    // 必填字段
    put.bucketName = [[ApplicationSettings instance] ossSDKBucketName];
    NSData *data   = UIImagePNGRepresentation(image);
    put.contentMd5 = [OSSUtil base64Md5ForData:data];
    put.objectKey  = [self createCameraImageNameByDate];
    put.uploadingData = data;
    put.contentType = [self contentTypeForImageData:data];
    //可选
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend)
    {
        progressBlock(bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask * putTask = [_client putObject:put];
    __weak __typeof(self)weakSelf = self;
    
    
    [putTask continueWithBlock:^id(OSSTask *task)
    {
        NSString *fileName = put.objectKey;
        DLog(@"上传文件名: %@", fileName);
        if (!task.error)
        {
            if(fileName)
            {
                DLog(@"阿里云上传图片成功!");
                block([weakSelf getTheUploadImageURL:fileName],nil);
            }
            
        }
        else
        {
            DLog(@"阿里云上传图片失败, 错误: %@" , task.error);
            block(nil,fileName);
        }
        return nil;
    }];
    
    return put;
}

#pragma mark private methods

- (NSString *)getTheUploadImageURL:(NSString *)imageName
{
    NSMutableString *imageURL = [[NSMutableString alloc]init];
    
    [imageURL appendString:@"http://"];
    [imageURL appendString:[[ApplicationSettings instance] ossSDKBucketName]];
    [imageURL appendString:@".oss-cn-hangzhou.aliyuncs.com/"];
    [imageURL appendString:imageName];
    return imageURL;
}

- (NSString *)contentTypeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return @"image/jpeg";
}

- (NSString *)createCameraImageNameByDate
{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *uuid = [OpenUDID value];
    NSString *uuidStr;
    if(uuid && [uuid length] > 0)
    {
        uuidStr = [NSString stringWithFormat:@"%f%@",currentTime, uuid];
    }
    else
    {
        uuidStr = [NSString stringWithFormat:@"%f",currentTime];
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@.png",[NSString md5:uuidStr]];
    
    return imageName;
}

@end

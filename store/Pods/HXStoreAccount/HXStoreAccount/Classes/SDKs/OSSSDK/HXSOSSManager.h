//
//  HXSOSSManager.h
//  store
//
//  Created by J006 on 16/5/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>

@interface HXSOSSManager : NSObject

- (void)initTheHXSOSSManager;

/**
 *  同步上传图片
 *
 *  @param image
 *  @param image name
 */
- (OSSPutObjectRequest *)uploadThePrintImage:(UIImage *)image
                                andImageName:(NSString *)imageName
                                    andBlock:(void(^)(NSString *fileURLName ,NSString *errorFileName))block
                                 andProgress:(void(^)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend))progressBlock;

@end

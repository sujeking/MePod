//
//  HXSPrintDownloadsObjectEntity.h
//  store
//  从iCloudDrive下载下来的文件做成的entity对象
//  Created by J006 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSMyPrintOrderItem.h"

typedef NS_ENUM(NSUInteger,HXSDocumentUploadType) {
    kHXSDocumentDownloadTypeUploading          = 0,  // 上传中
    kHXSDocumentDownloadTypeUploadSucc         = 1,  // 上传成功
    kHXSDocumentDownloadTypeUploadFail         = 2,  // 上传失败
};

@interface HXSPrintDownloadsObjectEntity : NSObject<NSCoding>

/**文件对象的名称*/
@property (nonatomic, strong) NSString                     *archiveDocNameStr;
/**文件对象本地URL地址*/
@property (nonatomic, strong) NSString                     *archiveDocLocalURLStr;
/**文件类型*/
@property (nonatomic, readwrite) HXSDocumentType           archiveDocTypeNum;
/**文件*/
@property (nonatomic, strong) NSData                       *fileData;
@property (nonatomic, strong) NSString                     *localDocMd5Str;
/**上传文件并且拥有购物车物品属性的entity*/
@property (nonatomic, strong) HXSMyPrintOrderItem          *uploadAndCartDocEntity;
/**文件类型字符串*/
@property (nonatomic, strong) NSString                     *mimeTypeStr;
/**已经加入购物车的entity*/
@property (nonatomic, strong) NSMutableArray               *cartPrintOrderItemArray;
/**上传状态*/
@property (nonatomic, assign) HXSDocumentUploadType        uploadType;
@property (nonatomic, strong) NSURLSessionDataTask         *task;
/**文件对象服务器端地址*/
@property (nonatomic, strong) NSString                     *archiveDocPathStr;
/**MD5*/
@property (nonatomic, strong) NSString                     *archiveDocMd5Str;
/**文件大小*/
@property (nonatomic, strong) NSNumber                     *archiveDocSizeNum;
/**上传时间*/
@property (nonatomic, strong) NSDate                       *upLoadDate;
/**是否是首次成功上传完毕并播放完动画*/
@property (nonatomic, assign) BOOL                         isFirstFinishedUpload;

@end

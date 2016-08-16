//
//  HXSPrintFilesManager.m
//  store
//
//  Created by J006 on 16/5/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintFilesManager.h"
#import "HXSDocumentPersistencyManger.h"
#import "HXSCustomAlertView.h"
#import "NSData+HXSPrintDataMD5.h"
#import "NSString+Addition.h"

static CGFloat const FILE_DOWNLOADS_LIMIT = 8.0; //下载的文件大小限制为8M

@interface HXSPrintFilesManager()

@end

@implementation HXSPrintFilesManager

- (void)saveTheDownloadFileToArchiveWithArray:(NSMutableArray<HXSPrintDownloadsObjectEntity *> *)array
{
    if(!array) {
        return;
    }
    [[HXSDocumentPersistencyManger sharedManager] saveTheDocument:array];
}

- (NSMutableArray<HXSPrintDownloadsObjectEntity *> *)loadTheDownloadFilesToUnArchiveAndReturnArray
{
    NSMutableArray<HXSPrintDownloadsObjectEntity *> *array = [[HXSDocumentPersistencyManger sharedManager] loadTheSavedDocument];
    if(array && [array count]>0)
    {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"uploadType"
                                                     ascending:YES];
        NSArray *sortDescriptors  = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray      = [array sortedArrayUsingDescriptors:sortDescriptors];//以下载是否成功排序排序
        
        NSMutableArray *tempArray = [sortedArray mutableCopy];
        
        return tempArray;
    } else {
        return nil;
    }
    
}

- (void)removeTheDownloadDocument:(HXSPrintDownloadsObjectEntity *)entity
                  inTheTotalArray:(NSMutableArray<HXSPrintDownloadsObjectEntity *> *)array
                     andCartArray:(NSMutableArray<HXSMyPrintOrderItem *> *)cartArray
{
    if(!entity || !array || array.count == 0) {
        return;
    }
    
    if(entity.archiveDocNameStr) {
        [self removeTheLocalDocFileWithURL:entity.archiveDocLocalURLStr];
    }
    [array removeObject:entity];

    [cartArray removeObject:entity.uploadAndCartDocEntity];
    
    [self saveTheDownloadFileToArchiveWithArray:array];
}

- (NSString *)saveTheDataToLocalWithData:(NSData *)data
                         andWithFileName:(NSString *)fileName
                           andWithEntity:(HXSPrintDownloadsObjectEntity *)entity
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError *error;
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:documentHomeFolderPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    if(error) {
        return nil;
    }
    
    //entity.archiveDocNameStr = fileName;//将可能重名之后生成的新的名称赋值
    NSString *writeFilePath = [dataPath stringByAppendingPathComponent:fileName];//fileName就是保存文件的文件名
    BOOL isSuccess = [data writeToFile:writeFilePath atomically:YES];
    if(isSuccess) {
         DLog(@"filePaht=%@",writeFilePath);
    }
    
    return writeFilePath;
}

- (void)removeTheLocalDocFileWithURL:(NSString *)docURL
{
    if(!docURL) {
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:docURL];
    if (isExist) {
        NSError *err;
        [fileManager removeItemAtPath:docURL error:&err];
        if(err) {
            DLog(@"del file error =%@",err);
        }
        
    }
}

- (HXSPrintDownloadsObjectEntity *)checkTheDataFileTypeAndSetTheEntityWithURL:(NSURL *)fileUrl
                                                            andIsFromOtherApp:(BOOL)isFromOtherApp
                                                                      andView:(UIView *)view
                                                                 andWithArray:(NSMutableArray<HXSPrintDownloadsObjectEntity *> *)array
{
    if(!fileUrl) {
        return nil;
    }
    
    NSURLRequest *fileUrlRequest = [[NSURLRequest alloc] initWithURL:fileUrl];
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData* fileData = [NSURLConnection sendSynchronousRequest:fileUrlRequest returningResponse:&response error:&error];
    
    if([self checkTheDownloadFileSizeIsTooLargeWithData:fileData]) {
        [self checkTheDownloadFileSizeAndShowTheAlertView];
        return nil;
    }
    
    if(!response && !isFromOtherApp) {
        NSString *iCloudErrorStr = @"iCloud连接失败,请重试";
        if (view) {
            [MBProgressHUD showInViewWithoutIndicator:view status:iCloudErrorStr afterDelay:1.5];
        }
        return nil;
    }
    
    NSString *mimeType = [response MIMEType];
    NSInteger fileType;
    if ([mimeType isEqualToString:@"image/jpeg"]) {
        fileType =  HXSDocumentTypeImageJPEG;
    } else if ([mimeType isEqualToString:@"application/msword"]) {
        fileType =  HXSDocumentTypeDoc;
    } else if ([mimeType isEqualToString:@"application/vnd.ms-powerpoint"]) {
        fileType =  HXSDocumentTypePPT;
    } else if ([mimeType isEqualToString:@"image/png"]) {
        fileType =  HXSDocumentTypeImagePNG;
    } else if ([mimeType isEqualToString:@"application/vnd.openxmlformats-officedocument.wordprocessingml.document"]){
        fileType =  HXSDocumentTypeDoc;
    } else if ([mimeType isEqualToString:@"application/vnd.openxmlformats-officedocument.presentationml.presentation"]) {
        fileType =  HXSDocumentTypePPT;
    } else if ([mimeType isEqualToString:@"application/pdf"]) {
        fileType =  HXSDocumentTypePdf;
    } else {
        NSString *message = @"此文件格式暂不支持打印";
        if (view) {
            [MBProgressHUD showInViewWithoutIndicator:view status:message afterDelay:1.5];
        }
        return nil;
    }
    NSString *fileName = [[[fileUrl absoluteString] lastPathComponent]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HXSPrintDownloadsObjectEntity *entity = [[HXSPrintDownloadsObjectEntity alloc]init];
    entity.archiveDocTypeNum = fileType;
    entity.mimeTypeStr = mimeType;
    entity.fileData = fileData;
    entity.localDocMd5Str = [fileData md5];
    fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];//去空格,变成下划线
    entity.archiveDocNameStr = fileName;
    if([self checkTheSameFileIsExistWithLocalDocMD5:entity.localDocMd5Str
                                       andWithArray:array]) {
        NSString *sameFileMessage = @"相同文件无法上传~";
        if (view) {
            [MBProgressHUD showInViewWithoutIndicator:view status:sameFileMessage afterDelay:1.5];
        }
        return nil;
    }
    
    return entity;
}

- (void)checkTheCurrentSettingAndGetTheTotalPrice:(HXSMyPrintOrderItem *)myPrintOrderEntity
{
    if(!myPrintOrderEntity) {
        return;
    }
    
    NSInteger pageNums = [myPrintOrderEntity.pageIntNum integerValue];
    NSInteger reduced  = [myPrintOrderEntity.currentSelectSetReduceEntity.reduceedNum integerValue];
    NSInteger printPageNums = floor((pageNums + reduced - 1) / reduced);
    NSInteger page_side = [myPrintOrderEntity.currentSelectSetPrintEntity.pageSideTypeNum integerValue];
    double unit_price = [myPrintOrderEntity.currentSelectSetPrintEntity.unitPriceNum doubleValue];
    double price = floor((printPageNums + page_side - 1)/page_side) * unit_price;
    double totalPrice = price * ([myPrintOrderEntity.quantityIntNum integerValue]);
    NSNumber *priceNum = [[NSNumber alloc]initWithDouble:price];
    NSNumber *totalPriceNum = [[NSNumber alloc]initWithDouble:totalPrice];
    NSNumber *reduceNumsPrint = [[NSNumber alloc]initWithInteger:printPageNums];//缩印后的页数
    myPrintOrderEntity.pageReduceIntNum = reduceNumsPrint;
    myPrintOrderEntity.amountDoubleNum = totalPriceNum;
    myPrintOrderEntity.priceDoubleNum = priceNum;
}

- (void)checkTheCurrentSettingAndGetTheTotalPhotoPrice:(HXSMyPrintOrderItem *)myPrintOrderEntity
{
    if(!myPrintOrderEntity) {
        return;
    }
    
    NSInteger quantityNum = [myPrintOrderEntity.quantityIntNum integerValue];
    double    unit_price  = [myPrintOrderEntity.currentSelectSetPrintEntity.unitPriceNum doubleValue];
    
    double price       = quantityNum * unit_price;
    NSNumber *priceNum = [[NSNumber alloc]initWithDouble:price];
    
    myPrintOrderEntity.priceDoubleNum   = priceNum;
    myPrintOrderEntity.amountDoubleNum  = priceNum;
}

- (NSString *)createCameraImageNameByDate
{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *uuidStr = [OpenUDID value];
    NSString *newStr = [NSString stringWithFormat:@"%f%@",currentTime,uuidStr];
    
    NSString *imageName = [NSString stringWithFormat:@"%@.png",[NSString md5:newStr]];
    
    return imageName;
}


#pragma mark - private method

/**
 *  检测下载的文件是否大于指定大小
 *
 *  @param data
 *
 *  @return
 */
- (BOOL)checkTheDownloadFileSizeIsTooLargeWithData:(NSData *)data
{
    BOOL isTooLarge = NO;
    if(!data) {
        return isTooLarge;
    }
    
    CGFloat size = (float)data.length/1024.0f/1024.0f;
    if(size > FILE_DOWNLOADS_LIMIT) {
        isTooLarge = YES;
    }
    return isTooLarge;
}

/**
 *  文件超过指定大小后弹框提示
 */
- (void)checkTheDownloadFileSizeAndShowTheAlertView
{
    NSString *infoStr = [NSString stringWithFormat:@"单个文件请勿超过%.1fM",FILE_DOWNLOADS_LIMIT];
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc]initWithTitle:@"提醒"
                                                                     message:infoStr
                                                             leftButtonTitle:@"确定"
                                                           rightButtonTitles:nil];
    [alertView show];
}

- (BOOL)checkTheSameFileIsExistWithLocalDocMD5:(NSString *)md5
                                  andWithArray:(NSMutableArray<HXSPrintDownloadsObjectEntity *> *)array
{
    BOOL isExist = NO;
    for (HXSPrintDownloadsObjectEntity *entity in array) {
        if([entity.localDocMd5Str isEqualToString:md5]) {
            isExist = YES;
            break;
        }
    }
    return isExist;
}

@end

//
//  HXSPrintFilesManager.h
//  store
//  文档打印相关文件的存储读取操作
//  Created by J006 on 16/5/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSPrintDownloadsObjectEntity.h"
#import "HXSMyPrintOrderItem.h"

@interface HXSPrintFilesManager : NSObject

/**
 *  保存归档
 */
- (void)saveTheDownloadFileToArchiveWithArray:(NSMutableArray<HXSPrintDownloadsObjectEntity *> *)array;

/**
 *  读取保存的文件
 *
 *  @return
 */
- (NSMutableArray<HXSPrintDownloadsObjectEntity *> *)loadTheDownloadFilesToUnArchiveAndReturnArray;

/**
 *  移除DownloadDocumentEntity
 *
 *  @param entity 指定的entity
 *  @param array  指定的已上传的文件数组集合
 *  @param cartArray  指定的已加入购物车的数组集合
 */
- (void)removeTheDownloadDocument:(HXSPrintDownloadsObjectEntity *)entity
                  inTheTotalArray:(NSMutableArray<HXSPrintDownloadsObjectEntity *> *)array
                     andCartArray:(NSMutableArray<HXSMyPrintOrderItem *> *)cartArray;

/**
 *  根据指定的数据data,存储到本地
 *
 *  @param data     数据
 *  @param fileName 文件原始名
 *  @return 返回写入本地的地址
 */
- (NSString *)saveTheDataToLocalWithData:(NSData *)data
                         andWithFileName:(NSString *)fileName
                           andWithEntity:(HXSPrintDownloadsObjectEntity *)entity;

/**
 *  移除指定URL的本地文档
 *
 *  @param docURL
 */
- (void)removeTheLocalDocFileWithURL:(NSString *)docURL;
/**
 *  据给定的iCloudDrive的文件地址,进行本地存储并返回Entity对象
 *
 *  @param fileUrl        文件地址
 *  @param isFromOtherApp 是否是从其他app打开
 *  @param view           指定的view
 *  @param array          指定的已上传的文件数组集合
 *
 *  @return 
 */
- (HXSPrintDownloadsObjectEntity *)checkTheDataFileTypeAndSetTheEntityWithURL:(NSURL *)fileUrl
                                                            andIsFromOtherApp:(BOOL)isFromOtherApp
                                                                      andView:(UIView *)view
                                                                 andWithArray:(NSMutableArray<HXSPrintDownloadsObjectEntity *> *)array;
/**
 *  计算该份文档打印总价格
 *  打印页数＝ floor((文档页数＋reduced-1)/reduced)
 *  最终购物车价格＝floor((打印页数＋page_side-1)/page_side)*unit_price
 */
- (void)checkTheCurrentSettingAndGetTheTotalPrice:(HXSMyPrintOrderItem *)myPrintOrderEntity;

/**
 *  计算该份照片打印的总价格
 *
 *  @param myPrintOrderEntity
 */
- (void)checkTheCurrentSettingAndGetTheTotalPhotoPrice:(HXSMyPrintOrderItem *)myPrintOrderEntity;

/**
 *  根据当前时间生成一个md5的名称作为图片名
 *
 *  @return
 */
- (NSString *)createCameraImageNameByDate;

@end

//
//  HXSDocumentPersistencyManger.h
//  store
//
//  Created by J006 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define documentHomeFolderPath @"/DocumentDownloadFiles"
#define documentHomeFilePath   @"/DocumentDownloadFiles/downloadDocument.bin"

@interface HXSDocumentPersistencyManger : NSObject

+ (instancetype)sharedManager;

/**
 *  存储归档的数组,其中包括各种下载的文档对象
 *
 *  @param array
 */
- (void)saveTheDocument:(NSMutableArray *)array;
/**
 *  读取归档的数组,其中包括各种下载的文档对象
 *
 *  @return
 */
- (NSMutableArray *)loadTheSavedDocument;

@end

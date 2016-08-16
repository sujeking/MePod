//
//  HXSMyPrintOrderItem.h
//  store
//
//  Created by 格格 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSOrderInfo.h"
#import "HXSPrintSettingEntity.h"
#import "HXBaseJSONModel.h"

@protocol HXSMyPrintOrderItem
@end

@interface HXSMyPrintOrderItem : HXBaseJSONModel <NSCoding>

@property (nonatomic, strong) NSString                       *pdfPathStr;        // 转换后的pdf文档的url
@property (nonatomic, strong) NSString                       *pdfMd5Str;         // 转换后的pdf文档的md5
@property (nonatomic, strong) NSNumber                       *pdfSizeLongNum;    // 转换后的pdf文档的大小
@property (nonatomic, strong) NSString                       *originPathStr;     // 原始上传文档的url
@property (nonatomic, strong) NSString                       *originMd5Str;      // 原始上传文档md5
@property (nonatomic, strong) NSString                       *fileNameStr;       // 上传的文件名称
@property (nonatomic, assign) HXSDocumentType                archiveDocTypeNum;//文件类型
@property (nonatomic, assign) HXSDocumentSetPrintType        printTypeIntNum;   // 打印类型
@property (nonatomic, assign) HXSDocumentSetReduceType       reducedTypeIntNum; // 缩印type
@property (nonatomic, strong) HXSPrintSettingEntity          *currentSelectSetPrintEntity;//当前选择的打印类型
@property (nonatomic, strong) HXSPrintSettingReducedEntity   *currentSelectSetReduceEntity;//当前选择的缩印类型
@property (nonatomic, assign) BOOL                           isAddToCart;//是否已经加入购物车
@property (nonatomic, strong) UIImage                        *picImage;//图片打印
@property (nonatomic, assign) BOOL                           isUploadSuccess;//是否已经上传
@property (nonatomic, assign) CGFloat                        preProgress;//被分配的总进度
@property (nonatomic, assign) CGFloat                        currentProgress;//当前被分配的进度

@property (nonatomic, strong) NSNumber *pageIntNum;        // pdf页数
@property (nonatomic, strong) NSNumber *pageReduceIntNum;  // 缩印后的页数
@property (nonatomic, strong) NSNumber *quantityIntNum;    // 打印份数
@property (nonatomic, strong) NSNumber *priceDoubleNum;    // 单份总价格
@property (nonatomic, strong) NSNumber *originPriceDoubleNum; // 单份原价，字段总是存在。默认等于price
@property (nonatomic, strong) NSNumber *amountDoubleNum; // 该文档合计金额，等于price * quantity
@property (nonatomic, strong) NSString *specificationsStr; // 打印规格描述，页数指单份的页数

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

- (NSDictionary *)itemDictionary;


/**
 *  深层拷贝
 */
- (id)copyWithZone:(NSZone *)zone;

@end



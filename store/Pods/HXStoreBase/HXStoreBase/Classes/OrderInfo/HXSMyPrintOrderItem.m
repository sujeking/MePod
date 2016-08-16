//
//  HXSMyPrintOrderItem.m
//  store
//
//  Created by 格格 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyPrintOrderItem.h"

@implementation HXSMyPrintOrderItem

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"pdfPathStr",         @"pdf_path",
                                 @"pdfMd5Str",          @"pdf_md5",
                                 @"pdfSizeLongNum",     @"pdf_size",
                                 @"originPathStr",      @"doc_path",
                                 @"originMd5Str",       @"doc_md5",
                                 @"fileNameStr",        @"file_name",
                                 @"printTypeIntNum",    @"print_type",
                                 @"reducedTypeIntNum",  @"reduced_type",
                                 @"pageReduceIntNum",   @"page",
                                 @"quantityIntNum",     @"quantity",
                                 @"priceDoubleNum",     @"price",
                                 @"originPriceDoubleNum",   @"origin_price",
                                 @"amountDoubleNum",        @"amount",
                                 @"specificationsStr",      @"specifications",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:itemMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return  [[HXSMyPrintOrderItem alloc] initWithDictionary:object error:nil];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.pageIntNum forKey:@"pageIntNum"];
    [aCoder encodeObject:self.pdfPathStr forKey:@"pdfPathStr"];
    [aCoder encodeObject:self.pdfMd5Str forKey:@"pdfMd5Str"];
    [aCoder encodeObject:self.pdfSizeLongNum forKey:@"pdfSizeLongNum"];
    [aCoder encodeObject:self.originPathStr forKey:@"originPathStr"];
    [aCoder encodeObject:self.originMd5Str forKey:@"originMd5Str"];
    [aCoder encodeObject:self.fileNameStr forKey:@"fileNameStr"];
    [aCoder encodeObject:[[NSNumber alloc]initWithInteger:self.printTypeIntNum] forKey:@"printTypeIntNum"];
    [aCoder encodeObject:[[NSNumber alloc]initWithInteger:self.reducedTypeIntNum] forKey:@"reducedTypeIntNum"];
}


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super init];
    if (self)
    {
        _pageIntNum         = [aDecoder decodeObjectForKey:@"pageIntNum"];
        _pdfPathStr         = [aDecoder decodeObjectForKey:@"pdfPathStr"];
        _pdfMd5Str          = [aDecoder decodeObjectForKey:@"pdfMd5Str"];
        _pdfSizeLongNum     = [aDecoder decodeObjectForKey:@"pdfSizeLongNum"];
        _originPathStr      = [aDecoder decodeObjectForKey:@"originPathStr"];
        _originMd5Str       = [aDecoder decodeObjectForKey:@"originMd5Str"];
        _fileNameStr        = [aDecoder decodeObjectForKey:@"fileNameStr"];
        _printTypeIntNum    = [[aDecoder decodeObjectForKey:@"printTypeIntNum"] integerValue];
        _reducedTypeIntNum  = [[aDecoder decodeObjectForKey:@"reducedTypeIntNum"] integerValue];
        _quantityIntNum     = [aDecoder decodeObjectForKey:@"quantityIntNum"];
    }
    return self;
}

- (NSMutableDictionary *)itemDictionary
{
    NSMutableDictionary *itemDictionary = [NSMutableDictionary dictionary];
    [itemDictionary setValue:self.pdfPathStr forKey:@"pdf_path"];
    [itemDictionary setValue:self.pdfMd5Str forKey:@"pdf_md5"];
    [itemDictionary setValue:self.pdfSizeLongNum forKey:@"pdf_size"];
    [itemDictionary setValue:self.originPathStr forKey:@"doc_path"];
    [itemDictionary setValue:self.originMd5Str forKey:@"doc_md5"];
    [itemDictionary setValue:self.fileNameStr forKey:@"file_name"];
    [itemDictionary setValue:@(self.printTypeIntNum) forKey:@"print_type"];
    [itemDictionary setValue:@(self.reducedTypeIntNum) forKey:@"reduced_type"];
    [itemDictionary setValue:self.pageIntNum forKey:@"page"];
    [itemDictionary setValue:self.quantityIntNum forKey:@"quantity"];
    [itemDictionary setValue:self.pageReduceIntNum forKey:@"print_page"];
    return itemDictionary;
}

- (id)copyWithZone:(NSZone *)zone
{
    HXSMyPrintOrderItem *copy = [[HXSMyPrintOrderItem allocWithZone:zone] init];
    
    [copy setPdfPathStr:self.pdfPathStr];
    [copy setPdfMd5Str:self.pdfMd5Str];
    [copy setPdfSizeLongNum:self.pdfSizeLongNum];
    [copy setOriginPathStr:self.originPathStr];
    [copy setOriginMd5Str:self.originMd5Str];
    [copy setFileNameStr:self.fileNameStr];
    [copy setPrintTypeIntNum:self.printTypeIntNum];
    [copy setReducedTypeIntNum:self.reducedTypeIntNum];
    [copy setPageIntNum:self.pageIntNum];
    [copy setQuantityIntNum:self.quantityIntNum];
    [copy setPriceDoubleNum:self.priceDoubleNum];
    [copy setOriginPriceDoubleNum:self.originPriceDoubleNum];
    [copy setAmountDoubleNum:self.amountDoubleNum];
    [copy setSpecificationsStr:self.specificationsStr];
    [copy setArchiveDocTypeNum:self.archiveDocTypeNum];
    [copy setCurrentSelectSetPrintEntity:self.currentSelectSetPrintEntity];
    [copy setCurrentSelectSetReduceEntity:self.currentSelectSetReduceEntity];
    
    return copy;
}

@end


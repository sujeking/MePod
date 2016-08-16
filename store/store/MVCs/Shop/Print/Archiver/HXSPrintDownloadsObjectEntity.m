//
//  HXSPrintDownloadsObjectEntity.m
//  store
//
//  Created by J006 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintDownloadsObjectEntity.h"

@implementation HXSPrintDownloadsObjectEntity

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.archiveDocNameStr forKey:@"archiveDocNameStr"];
    [aCoder encodeObject:self.archiveDocLocalURLStr forKey:@"archiveDocLocalURLStr"];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.archiveDocTypeNum] forKey:@"archiveDocTypeNum"];
    [aCoder encodeObject:self.archiveDocPathStr forKey:@"archiveDocPathStr"];
    [aCoder encodeObject:self.archiveDocMd5Str forKey:@"archiveDocMd5Str"];
    [aCoder encodeObject:self.archiveDocSizeNum forKey:@"archiveDocSizeNum"];
    [aCoder encodeObject:self.uploadAndCartDocEntity forKey:@"uploadAndCartDocEntity"];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.uploadType] forKey:@"uploadType"];
    [aCoder encodeObject:self.mimeTypeStr forKey:@"mimeTypeStr"];
    [aCoder encodeObject:self.fileData forKey:@"fileData"];
    [aCoder encodeObject:self.localDocMd5Str forKey:@"localDocMd5Str"];
    [aCoder encodeObject:self.upLoadDate forKey:@"upLoadDate"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isFirstFinishedUpload] forKey:@"isFirstFinishedUpload"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super init];
    if (self) {
        _archiveDocNameStr      = [aDecoder decodeObjectForKey:@"archiveDocNameStr"];
        _archiveDocLocalURLStr  = [aDecoder decodeObjectForKey:@"archiveDocLocalURLStr"];
        _archiveDocTypeNum      = [[aDecoder decodeObjectForKey:@"archiveDocTypeNum"] unsignedIntegerValue];
        _archiveDocPathStr      = [aDecoder decodeObjectForKey:@"archiveDocPathStr"];
        _archiveDocMd5Str       = [aDecoder decodeObjectForKey:@"archiveDocMd5Str"];
        _archiveDocSizeNum      = [aDecoder decodeObjectForKey:@"archiveDocSizeNum"];
        _mimeTypeStr            = [aDecoder decodeObjectForKey:@"mimeTypeStr"];
        _fileData               = [aDecoder decodeObjectForKey:@"fileData"];
        _uploadAndCartDocEntity = [aDecoder decodeObjectForKey:@"uploadAndCartDocEntity"];
        _localDocMd5Str         = [aDecoder decodeObjectForKey:@"localDocMd5Str"];
        _uploadType             = [[aDecoder decodeObjectForKey:@"uploadType"] unsignedIntegerValue];
        _upLoadDate             = [aDecoder decodeObjectForKey:@"upLoadDate"];
        _isFirstFinishedUpload = [[aDecoder decodeObjectForKey:@"isFirstFinishedUpload"] boolValue];
    }
    return self;
}

@end

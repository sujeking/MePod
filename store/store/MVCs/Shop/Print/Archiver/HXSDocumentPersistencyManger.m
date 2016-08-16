//
//  HXSDocumentPersistencyManger.m
//  store
//
//  Created by J006 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDocumentPersistencyManger.h"

@interface HXSDocumentPersistencyManger()

@end

@implementation HXSDocumentPersistencyManger

+ (instancetype)sharedManager
{
    static HXSDocumentPersistencyManger *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

- (void)saveTheDocument:(NSMutableArray *)array
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError *error;
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:documentHomeFolderPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath])
    {
        [fileManager setAttributes:@{NSFileProtectionKey: NSFileProtectionCompleteUntilFirstUserAuthentication} ofItemAtPath:folderPath error:nil];
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    if(error)
        return;
    NSString *filename = [documentsDirectory stringByAppendingPathComponent:documentHomeFilePath];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [data writeToFile:filename atomically:YES];
}

- (NSMutableArray *)loadTheSavedDocument
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = [documentsDirectory stringByAppendingPathComponent:documentHomeFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filename])
        return nil;
    NSData *data = [NSData dataWithContentsOfFile:[documentsDirectory stringByAppendingString:documentHomeFilePath]];

    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}

@end

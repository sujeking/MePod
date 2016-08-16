//
//  HXSDirectoryManager.h
//  store
//
//  Created by chsasaw on 14/10/26.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSDirectoryManager : NSObject

+ (NSString *) getLibraryDirectory;

+ (NSString *) getCachesDirectory;
+ (BOOL) createDirectoryAtCachesWithName:(NSString*)dirName;
+ (NSArray*) enumarateDirectoryAtPath:(NSString*)path inCaches:(BOOL)isInCaches;

+ (NSString *) getDocumentsDirectory;
+ (NSString *) getTempDirectory;
+ (BOOL) createDirectoryAtPath:(NSString*)path;
//+ (BOOL) createDirectoryAtDocumentsWithName:(NSString*)dirName;
//+ (NSArray*) enumarateDirectoryAtPath:(NSString*)path inDocuments:(BOOL)isInDocuments;
//+ (NSMutableArray*) createURLStartWith:(NSString*)start AtPath:(NSString*)path inDocuments:(BOOL)isInDocuments;

+ (void)moveFilesFrom:(NSString *)fromFile to:(NSString *)toFile;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (NSString *)getAdImagePath:(NSString *)image_url;

@end

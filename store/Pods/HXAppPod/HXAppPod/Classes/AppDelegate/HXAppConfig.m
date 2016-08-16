//
//  HXAppConfig.m
//  store
//
//  Created by chsasaw on 14-10-13.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXAppConfig.h"
#import "SSKeychain.h"
#import "HXAppDeviceHelper.h"
#import <objc/message.h>

// compile with xcode 6
FILE *fopen$UNIX2003( const char *filename, const char *mode )
{
    return fopen(filename, mode);
}
size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d )
{
    return fwrite(a, b, c, d);
}
char* strerror$UNIX2003( int errnum )
{
    return strerror(errnum);
}


static NSString* const HISTORY_VERSIONS_KEY = @"A34C93A1-B6B6-4B3F-A59F-094075710C3B";

@implementation HXMailComponents

@end

@implementation HXAppConfig

static BOOL _minimalLoading = NO;

+ (void)setMinimalLoading: (BOOL)minimalLoading {
    _minimalLoading = minimalLoading;
}

+ (BOOL)isMinimalLoading {
    return _minimalLoading;
}


+(HXAppConfig*) sharedInstance
{
    static HXAppConfig* shared;
    static dispatch_once_t done;
    dispatch_once(&done, ^{
        shared = [[HXAppConfig alloc] init];
    });
    return shared;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.appName =  [[[NSBundle mainBundle] infoDictionary]
                         objectForKey:@"CFBundleDisplayName"];
        self.appVersion = [[[NSBundle mainBundle] infoDictionary]
                           objectForKey:@"CFBundleShortVersionString"];
        
        // Build & update version history
        NSArray* oldVersions = [[NSUserDefaults standardUserDefaults] arrayForKey:HISTORY_VERSIONS_KEY] ? : @[];
        NSMutableOrderedSet* versions = [[NSMutableOrderedSet alloc] initWithArray:oldVersions];
        [versions insertObject:self.appVersion atIndex:0];
        self.historyVersions = versions;
        [[NSUserDefaults standardUserDefaults] setObject:versions.array forKey:HISTORY_VERSIONS_KEY];
        
        self.appBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    }
    
    return self;
}

@end

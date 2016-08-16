//
//  UdeskUtils.h
//  UdeskSDK
//
//  Created by xuchen on 16/1/18.
//  Copyright © 2016年 xuchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UdeskUtils : NSObject

#define UDBUNDLE_NAME @ "UdeskSDK.bundle/UdeskBundle.bundle"

#define UDBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: UDBUNDLE_NAME]

#define UDBUNDLE [NSBundle bundleWithPath: UDBUNDLE_PATH]

NSString * getUDBundlePath( NSString * filename);

NSString * getUDLocalizedString( NSString * key);

@end

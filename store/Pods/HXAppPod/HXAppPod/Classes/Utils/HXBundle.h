//
//  HXBundle.h
//  store
//
//  Created by chsasaw on 14-10-13.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXBundle : NSObject

NSString* HXLocalizedString(NSString* key, NSString* comment);

+ (NSBundle*)HXAppBundle;
+ (NSString *)bundleName;

@end

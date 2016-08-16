//
//  Base64Encoding.h
//  store
//
//  Created by chsasaw on 14-10-13.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64Encoding : NSObject

+(NSString *)base64StringFromData:(NSData *)data;
+ (NSString*)base64forData:(NSData*)theData;
+ (NSData *)dataWithBase64String:(NSString *)string;

@end

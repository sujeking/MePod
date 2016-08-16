//
//  NSString+Addition.m
//  BabyTime
//
//  Created by dong mike on 12-9-25.
//  Copyright (c) 2012年 dong mike. All rights reserved.
//

#import "NSString+Addition.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Additional)

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

- (BOOL)startWith:(NSString *)str
{
    if (self.length >= str.length)
    {
        if ([[self substringWithRange:NSMakeRange(0, str.length)] isEqualToString:str])
            return YES;
        else
            return NO;
    }
    else
    {
        return NO;
    }
}

- (NSString *) hashStr
{
    return [NSString stringWithFormat:@"%ld", (unsigned long)[[self description] hash]];
}

+(NSString *)md5:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]] lowercaseString];
}

+(NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

+(NSString *)decodeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

// 计算/n 的个数
- (NSInteger)numberOfNewLine
{
    NSInteger countOfBr = 0;
    
    for (int i = 0; i < [self length]; i++) {
        char character = [self characterAtIndex:i];
        if (character == '\n') {
            countOfBr++;
        }
    }
    
    return countOfBr;
}

@end

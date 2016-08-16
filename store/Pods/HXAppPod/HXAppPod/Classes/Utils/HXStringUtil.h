//
//  HXStringUtil.h
//  store
//
//  Created by chsasaw on 14-10-14.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HXStringUtil : NSObject {
    
}

+(NSString *)substringForString:(NSString *)str beginPattern:(NSString *)p0 endPattern:(NSString *)p1;
+(NSString *)shortenString:(NSString *)str withFont:(UIFont *)font toPixelWidth:(float)width;

+ (CGSize)sizeInOnelineOfText:(NSString *)text font:(UIFont *)font;
+ (CGFloat)heightForText:(NSString *)text havingWidth:(CGFloat)widthValue font:(UIFont *)font;
+ (CGFloat)heightForText:(NSString *)text havingWidth:(CGFloat)widthValue font:(UIFont *)font attributes:(NSDictionary *)attributes;

@end

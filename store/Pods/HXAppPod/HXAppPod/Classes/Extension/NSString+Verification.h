//
//  NSString+NSString_Verification.h
//  store
//
//  Created by ranliang on 15/7/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

/** ============================================================
 *
 *  should be moved to the framework sometime later
 *
 ================================================================*/

@interface NSString (Verification)

- (BOOL)isValidCellPhoneNumber;
- (BOOL)isValidPRCResidentIDCardNumber; // 身份证号
- (BOOL)isValidEmailAddress;
- (BOOL)isValidNickname;

// 截取尾部的空格
- (NSString *) trim;

// 去掉所有的空格
- (NSString *) compressBlank;

//test method
+ (void)testNSStringVerification;

// 人民币大写
+ (NSString *)uppercaseRMBString:(double)value;


// add '-' in phone number
- (NSString *)addSegmentPhoneNumber;


@end

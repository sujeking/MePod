//
//  NSDate+Extension.h
//  store
//
//  Created by hudezhi on 15/8/15.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Extension)

/**
 *  2016-1-1
 */
- (NSString *)YMDString;
/**
 *  2016.1.1
 */
- (NSString *)YMDPointString;

+ (NSString *)YMDFromSecondsSince1970:(long long)seconds;

+ (NSString *)stringFromSecondsSince1970:(long long)seconds format:(NSString *)format;
/**
 *  计算时间差
 *
 *  @param timeInterval
 *
 *  @return 
 */
+ (NSString *)updateTimeForRow:(NSInteger)timeInterval;
- (NSDateComponents*)components;
- (NSInteger)day;
- (NSInteger)weekDay;
- (NSInteger)month;
- (NSInteger)year;

// 当前日期加上 monthCount 个月以后的日期
- (NSDate *)dateByAddingMonth:(NSInteger)monthCount;

@end

//===============================================================================================================

@interface NSString (Date)
-(NSDate*)dateWithFormat:(NSString*)format;
@end

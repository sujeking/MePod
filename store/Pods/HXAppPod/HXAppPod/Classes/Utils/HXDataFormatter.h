//
//  HXDataFormatter.h
//  store
//
//  Created by chsasaw on 14-10-14.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    HXFormatDateStyleNormal,
    HXFormatDateStyleAgo,			//default style
    HXFormatDateStyleWeek,
    HXFormatDateStyleDay,
    HXFormatDateStylePointDay,
}HXFormatDateStyle;

typedef enum{
    HXFormatTimeStyle24 = 0,
    HXFormatTimeStyle12
}HXFormatTimeStyle;

@interface HXDataFormatter : NSObject {
    
}

//////////////////////////////////////////////////////////////////////////////////////////////
//	4.2f GB/MB/KB
// eg: 15.32 MB
//////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)formatFileSizeByByte:(float)bytesSize;

//////////////////////////////////////////////////////////////////////////////////////////////
//	HH:MM:SS
// eg: 3:05:12
//////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)formatTime:(NSTimeInterval)inter;


//////////////////////////////////////////////////////////////////////////////////////////////
//	1 min ago / 3 weeks ago
// HXFormatDateStyleAgo is default style
//////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)formatDate:(NSDate *)date;
+ (NSString *)formatDate:(NSDate *)date style:(HXFormatDateStyle)style;

+ (NSString *)formatDateWithFBAgo:(NSDate *)date;
+ (NSDate *)parseFBDateString:(NSString *)str;


//////////////////////////////////////////////////////////////////////////////////////////////
//	23:30 or 11:30 PM
// HXFormatTimeStyle24 is default style
//////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)timeFormat:(NSDate *)date style:(HXFormatTimeStyle)style;

/**
 *  Transform NSString to NSDate
 *
 *  @param dateString The String like "2014-10-12T20:22:12Z"
 *  @param formatStr  The String like "yyyy-MM-dd'T'HH:mm:ss'Z'". If formatStr is nil, will
 *                    use "yyyy-MM-dd'T'HH:mm:ss'Z'"
 *
 *  @return Data type is NSDate
 */
+ (NSDate *)dateFromString:(NSString *)dateString formatString:(NSString *)formatStr;

/**
 *  Transform NSDate to NSString
 *
 *  @param date      Data type is NSDate
 *  @param formatStr The String like "yyyy-MM-dd'T'HH:mm:ss'Z'". If formatStr is nil, will
 *                   use "yyyy-MM-dd'T'HH:mm:ss'Z'"
 *
 *  @return Data type is NSString, like "2014-10-12T20:22:12Z"
 */
+ (NSString *)stringFromDate:(NSDate *)date formatString:(NSString *)formatStr;

/**
 *  Transform local date to UTC date.
 *
 *  @param date Data type is NSDate and the date is device's time.
 *
 *  @return UTC date
 */
+ (NSDate *)UTCDateFromLocalDate:(NSDate *)date;

/**
 *  Transform UTC date to local date.
 *
 *  @param date Data type is NSDate and UTC date.
 *
 *  @return Local date
 */
+ (NSDate *)localDateFromUTCDate:(NSDate *)date;

@end

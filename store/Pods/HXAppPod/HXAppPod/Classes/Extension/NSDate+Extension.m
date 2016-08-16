//
//  NSDate+Extension.m
//  store
//
//  Created by hudezhi on 15/8/15.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "NSDate+Extension.h"

static NSDateFormatter *_dateFormatter;

@implementation NSDate(Extension)

+(NSCalendar*)calendar
{
    static NSCalendar* cal;
    if (nil == cal) {
        //@ change to the first day in a month
        //@Note: we need to set the time zone to 'GMT', otherwise, the date will not right(one day offset)
        cal = [NSCalendar currentCalendar];
        [cal setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    }
    return cal;
}

// The allocating/initializing of NSDateFormatter was considered expensive. So we use this, not allocat/initialize it every time
- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return _dateFormatter;
}

- (NSString *)YMDString
{
    self.dateFormatter.dateFormat = @"YYYY-MM-dd";
    return [self.dateFormatter stringFromDate:self];
}

- (NSString *)YMDPointString
{
    self.dateFormatter.dateFormat = @"YYYY.MM.dd";
    return [self.dateFormatter stringFromDate:self];
}

+ (NSString *)YMDFromSecondsSince1970:(long long)seconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [date YMDString];
}

+ (NSString *)stringFromSecondsSince1970:(long long)seconds format:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    date.dateFormatter.dateFormat = format;
    return  [date.dateFormatter stringFromDate:date];
}

- (NSDateComponents*)components {
    return [[NSDate calendar] components:( NSCalendarUnitMonth |  NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:self];
}

-(NSInteger)day {
    NSDateComponents* components = [[NSDate calendar] components:(NSCalendarUnitDay) fromDate:self];
    return components.day;
}

- (NSInteger)weekDay {
    NSDateComponents *comps = [[NSDate calendar]  components:NSCalendarUnitWeekday fromDate:self];
    return [comps weekday] - 1;
}

- (NSInteger)month {
    NSDateComponents* components = [[NSDate calendar] components:(NSCalendarUnitMonth) fromDate:self];
    return components.month;
}

-(NSInteger)year {
    NSDateComponents* components = [[NSDate calendar] components:(NSCalendarUnitYear) fromDate:self];
    return components.year;
}

- (NSDate *)dateByAddingMonth:(NSInteger)monthCount
{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.month = monthCount;
    
    return [[NSDate calendar] dateByAddingComponents:components toDate:self options:0];
}


+ (NSString *)updateTimeForRow:(NSInteger)timeInterval {
    // 获取当前时时间戳
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建时间戳
    NSTimeInterval createTime = timeInterval;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    // 秒转分钟
    NSInteger minutes = time/60;
    if (minutes < 60) {
        if(minutes == 0){
            
            return @"刚刚";
        } else {
            
            return [NSString stringWithFormat:@"%ld分钟前",(long)minutes];
        }
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",(long)months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",(long)years];
}

@end

//===============================================================================================================

@implementation NSString (Date)

-(NSDate*)dateWithFormat:(NSString*)format {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    return [formatter dateFromString:self];
}
@end

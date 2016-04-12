//
//  Helper+Date.m
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "Helper+Date.h"

@implementation Helper (Date)

+ (NSDateFormatter *)dateFormatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //常用格式 @"yyyy-MM-dd HH:mm:ss"
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [dateFormatter setTimeZone:timeZone];
    return dateFormatter;
}
+ (NSString *)formatDateWithDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    [dateFormatter setDateFormat:format];
    NSString *result = [dateFormatter stringFromDate:date];
    
    return result;
}
+ (NSString *)formatDateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *d = [dateFormatter dateFromString:dateString];
    
    return [Helper formatDateWithDate:d format:format];
}

+ (NSString *)formatTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self formatDateWithDate:date format:format];
}

+ (NSDate *)dateValueWithString:(NSString *)dateStr ByFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter dateFromString:dateStr];
}

+ (NSString *)weekdayStringValue:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int weekday=(int)[comps weekday];
    switch (weekday)
    {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
            
        default:
            break;
    }
    return nil;
}

+(NSString *)getTimeIntervalWithTime:(NSTimeInterval)timeInterval{
    
    NSInteger intTime = timeInterval;
    NSInteger seconds = intTime % 60;
    NSInteger minutes = (intTime / 60) % 60;
    NSInteger hours = (intTime / 3600);
    NSString *timeStr = [NSString stringWithFormat:@"%2zd小时%2zd分%2zd秒", hours, minutes, seconds];
    return timeStr;
}

/**
 *  时间补0
 *
 *  @param str str description
 *
 *  @return return value description
 */
+ (NSString *)fillZeroWithString:(NSString *)str
{
    if (str && str.length == 1)
    {
        return [NSString stringWithFormat:@"0%@",str];
    }
    return str;
}


+(NSString *)getTwoCharTimeIntervalWithTime:(NSInteger)timeInterval formatStr:(NSString *)formatStr{
    
    NSInteger seconds = labs(timeInterval % 60);
    NSString *secondStr =[self fillZeroWithString:[NSString stringWithFormat:@"%zd",seconds]];
    NSInteger minutes = labs((timeInterval / 60) % 60);
    NSString *minuteStr =[self fillZeroWithString:[NSString stringWithFormat:@"%zd",minutes]];
    NSInteger hours = timeInterval / 3600;
    NSString *hourStr =[self fillZeroWithString:[NSString stringWithFormat:@"%zd",hours]];
    NSString *timeStr;
    
    if([formatStr rangeOfString:@"天"].location !=NSNotFound){
        if(hours>=24){
            NSString *dayStr = [NSString stringWithFormat:@"%ld",hours/24];
            hourStr =[self fillZeroWithString:[NSString stringWithFormat:@"%zd",hours%24]];
            timeStr = [NSString stringWithFormat:formatStr, dayStr, hourStr, minuteStr, secondStr];
        }else{
            NSInteger lacation =[formatStr rangeOfString:@"天"].location;
            formatStr = [formatStr substringFromIndex:lacation+1];
            timeStr = [NSString stringWithFormat:formatStr, hourStr, minuteStr, secondStr];
        }
    }else{
        timeStr = [NSString stringWithFormat:formatStr, hourStr, minuteStr, secondStr];
    }
    
    return timeStr;
}

+ (NSString *)DescriptionWithDate:(NSDate *)date;
{
    @try {
        //实例化一个NSDateFormatter对象
        NSDate * needFormatDate = date;
        NSDate * nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        
        if (time<=60) {  //// 1分钟以内的
            dateStr = @"刚刚";
        }else if(time<=60*60){  ////  一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time<=60*60*24){   //// 在两天内的
            
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //// 在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                ////  昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                [dateFormatter setDateFormat:@"MM月dd日"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

@end

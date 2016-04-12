//
//  Helper+Date.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "Helper.h"

@interface Helper (Date)

+ (NSDateFormatter *)dateFormatter;

+ (NSString *)formatDateWithDate:(NSDate *)date format:(NSString *)format;

+ (NSString *)formatDateWithString:(NSString *)dateString format:(NSString *)format;

+ (NSString *)formatTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format;

+ (NSDate *)dateValueWithString:(NSString *)dateStr ByFormatter:(NSString *)formatter ;

+ (NSString *)weekdayStringValue:(NSDate*)date;

+(NSString *)getTimeIntervalWithTime:(NSTimeInterval)timeInterval;

+(NSString *)getTwoCharTimeIntervalWithTime:(NSInteger)timeInterval formatStr:(NSString *)formatStr;

+ (NSString *)DescriptionWithDate:(NSDate *)date;//格式化日期描述

@end

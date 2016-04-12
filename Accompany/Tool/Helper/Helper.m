//
//  Helper.m
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "Helper.h"
#include <sys/utsname.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <objc/runtime.h>
#import  <CommonCrypto/CommonCryptor.h>
#import <EventKit/EventKit.h>
#import <AdSupport/ASIdentifierManager.h>


@implementation Helper

/**
 *	@brief  获取用户的ADFA
 *
 */
+ (NSString *) getAdvertisingIdentifier

{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}
/**
 *	@brief 获取当前设备类型如ipod，iphone，ipad
 *
 */
+ (NSString *)deviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}


/**
 *	@brief 获取当前设备ios版本号
 *
 */
+(float) getCurrentDeviceVersion{
    
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

/**
 *	@brief 操作系统版本号
 *
 */
+ (NSString *)iOSVersion {
    return [[UIDevice currentDevice] systemVersion];
}


#pragma mark -判断是否空字符

+ (BOOL) isBlankString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//去掉UITextField前后空格
+(NSString *)RemoveStringWhiteSpace:(UITextField *)textField
{
    NSString *trimmedString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

#pragma mark -
+ (CGFloat)widthForLabelWithString:(NSString *)labelString withFontSize:(CGFloat)fontsize withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    if(labelString.length == 0){
        return 0.0;
    }
    
    if ([UIDevice currentDevice].systemVersion.doubleValue <= 7.0) {
        CGSize maximumLabelSize = CGSizeMake(width,height);
        CGSize expectedLabelSize = [labelString sizeWithFont:[UIFont systemFontOfSize:fontsize]
                                           constrainedToSize:maximumLabelSize
                                               lineBreakMode:0];
        
        return (expectedLabelSize.width);
    } else {
        CGSize size = CGSizeMake(width, height);
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontsize],NSFontAttributeName,nil];
        CGSize actualsize = [labelString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
        
        //得到的宽度为0，返回最大宽度
        if(actualsize.width == 0){
            return width;
        }
        
        return actualsize.width;
    }
}

+ (CGFloat)heightForLabelWithString:(NSString *)labelString withFontSize:(CGFloat)fontsize withWidth:(CGFloat)width withHeight:(CGFloat)height {
    
    if ([UIDevice currentDevice].systemVersion.doubleValue <= 7.0) {
        CGSize maximumLabelSize = CGSizeMake(width, height);
        CGSize expectedLabelSize = [labelString sizeWithFont:[UIFont systemFontOfSize:fontsize]
                                           constrainedToSize:maximumLabelSize
                                               lineBreakMode:0];
        
        return (int)(expectedLabelSize.height);
    } else {
        CGSize size = CGSizeMake(width, height);
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontsize],NSFontAttributeName,nil];
        CGSize actualsize = [labelString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
        return actualsize.height;
    }
}

+ (CGSize)sizeForLabelWithString:(NSString *)string withFont:(UIFont *)font constrainedToSize:(CGSize)size{
    if ([UIDevice currentDevice].systemVersion.doubleValue <= 7.0) {
        CGSize expectedLabelSize = [string sizeWithFont:font
                                      constrainedToSize:size
                                          lineBreakMode:0];
        
        return expectedLabelSize;
    } else {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualsize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
        actualsize.width = (NSInteger)(actualsize.width + 1.0);
        actualsize.height = (NSInteger)(actualsize.height + 1.0);
        return actualsize;
    }
}


@end

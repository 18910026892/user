//
//  Helper.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

/**
 *	@brief  获取用户的ADFA
 */
+ (NSString *) getAdvertisingIdentifier;
/**
 *	@brief 获取当前设备类型如ipod，iphone，ipad
 */
+ (NSString *)deviceType;
/**
 *	@brief 获取当前设备ios版本号
 */
+(float) getCurrentDeviceVersion;
/**
 *	@brief 操作系统版本号
 */
+ (NSString *)iOSVersion;



//判断是否是空字符
+ (BOOL) isBlankString:(NSString *)string;

//去掉UITextField前后空格
+(NSString *)RemoveStringWhiteSpace:(UITextField *)textField;


#pragma mark 计算字符串尺寸方法
/**
 *@brief 根据字符串获取label的高度
 *@param labelString label的text
 *@param fontSize label的字体大小，以systemFont为标准
 *@param width 最大宽度
 *@param height 最大高度
 */
+ (CGFloat)heightForLabelWithString:(NSString *)labelString withFontSize:(CGFloat)fontSize withWidth:(CGFloat)width withHeight:(CGFloat)height;

/**
 *@brief 根据字符串获取label的宽度
 *@param labelString label的text
 *@param fontSize label的字体大小，以systemFont为标准
 *@param width 最大宽度
 *@param height 最大高度
 */
+ (CGFloat)widthForLabelWithString:(NSString *)labelString withFontSize:(CGFloat)fontsize withWidth:(CGFloat)width withHeight:(CGFloat)height;

/**
 *@brief 根据字符串获取label的尺寸
 *@param labelString label的text
 *@param font label的字体
 *@param size 限制的最大尺寸
 */
+ (CGSize)sizeForLabelWithString:(NSString *)string withFont:(UIFont *)font constrainedToSize:(CGSize)size;


@end

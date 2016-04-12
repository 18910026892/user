//
//  Macros.h
//  Accompany
//
//  Created by GX on 16/1/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#import "LayoutMacro.h"
#import "ColorMacro.h"
#import "LocalFileMacro.h"
#import "UMClickConstant.h"
#import "URLPathMacro.h"


#pragma mark -
#pragma mark 自定义视图
#import "CustomTextField.h"
#import "EMAlertView.h"
#pragma mark -
#pragma mark 工具类

#import "HttpRequest.h"
#import "QRCodeGenerator.h"

#pragma mark -
#pragma mark Model类
#import "UserInfo.h"
#import "Config.h"

#pragma mark -
#pragma mark Lib类
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UserDefaultsUtils.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#pragma mark -
#pragma mark 类别
#import "UIView+Additional.h"
#import "NSString+Validation.h"


#pragma mark -
#pragma mark 打印日志
//DEBUG  模式下打印日志,当前行
#define GTDEBUG 1
#if GTDEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif
#pragma mark -
#pragma mark 各种判断宏

#endif /* Macros_h */

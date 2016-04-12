//
//  LayoutMacro.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#ifndef LayoutMacro_h
#define LayoutMacro_h

#define kMainScreenWidth    ([UIScreen mainScreen].applicationFrame).size.width //应用程序的宽度
#define kMainScreenHeight   ([UIScreen mainScreen].applicationFrame).size.height //应用程序的高度
#define kMainBoundsHeight   ([UIScreen mainScreen].bounds).size.height //屏幕的高度
#define kMainBoundsWidth    ([UIScreen mainScreen].bounds).size.width //屏幕的宽度
#define WIDTH_VIEW(view) CGRectGetWidth(view.frame)
#define HEIGHT_VIEW(view) CGRectGetHeight(view.frame)
#define VIEW_MAXX(view) CGRectGetMaxX(view.frame)
#define VIEW_MAXY(view) CGRectGetMaxY(view.frame)
//适配ip6 ip6+ 利器宏命令
#define Proportion ([UIScreen mainScreen].bounds.size.width/320)

#define kTabBarHeight                        49.0f
#define kNaviBarHeight                       44.0f
#define kHeightFor4InchScreen                568.0f
#define kHeightFor3p5InchScreen              480.0f
#define kStatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define kRect(x, y, w, h)    CGRectMake(x, y, w, h)
#define kSize(w, h)                          CGSizeMake(w, h)
#define kPoint(x, y)                         CGPointMake(x, y)

#define kSeparatorCellHeight 10.0f // 分割cell的高度

#define kOrderListReloadNotificationKey @"kOrderListReloadNotificationKey"


#define DismissModalViewControllerAnimated(controller,animated) [Helper dismissModalViewController:controller Animated:animated];
#define PresentModalViewControllerAnimated(controller1,controller2,animated)     [Helper presentModalViewRootController:controller1 toViewController:controller2 Animated:animated];



//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
#define ISNIL(variable) (variable==nil)
//是不是NULL类型
#define IS_NULL_CLASS(variable)    ((!ISNIL(variable))&&([variable  isKindOfClass:[NSNull class]])
//字典数据是否有效
#define IS_DICTIONARY_CLASS(variable) ((!ISNIL(variable))&&([variable  isKindOfClass:[NSDictionary class]])&&([((NSDictionary *)variable) count]>0))
//数组数据是否有效
#define IS_ARRAY_CLASS(variable) ((!ISNIL(variable))&&([variable  isKindOfClass:[NSArray class]])&&([((NSArray *)variable) count]>0))
//数字类型是否有效
#define IS_NUMBER_CLASS(variable) ((!ISNIL(variable))&&([variable  isKindOfClass:[NSNumber class]]))
//字符串是否有效
#define IS_EXIST_STR(str) ((nil != (str)) &&([(str) isKindOfClass:[NSString class]]) && (((NSString *)(str)).length > 0))

#pragma mark -
#pragma mark 设备系统版本、尺寸、字体、颜色 相关配置
//判断程序的版本
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0)
#define IOS_8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)

#define IMAGE_AT_APPDIR(name)       [UIImage imageNamed:name]

#endif /* LayoutMacro_h */

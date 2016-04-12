//
//  HDHud.h
//  CreditGroup
//
//  Created by ang on 14/8/27.
//  Copyright (c) 2014年 JPlay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
@interface HDHud : NSObject

//显示HUD提示
+(MBProgressHUD *)showHUDInView:(UIView *)view title:(NSString *)title;

//关闭HUD提示
+(void)hideHUDInView:(UIView *)view;

//显示网络错误提示
+(MBProgressHUD *)showNetWorkErrorInView:(UIView *)view;

//显示信息
+(MBProgressHUD *)showMessageInView:(UIView *)view title:(NSString *)title;

@end

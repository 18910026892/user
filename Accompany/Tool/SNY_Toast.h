//
//  SNY_Toast.h
//  YiChat
//
//  Created by 宋乃银 on 14-9-13.
//  Copyright (c) 2014年 zhiyou. All rights reserved.
//
/*
    用法:[SNY_Toast showMsg:@"你好!" WithDuration:2 WithStyle:showStyleFlip];
 showStyleFlip  从底下弹出来，showStyleWear中间
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum
{
    showStyleFlip,
    showStyleWear
    
}ShowStyle;

@interface SNY_Toast : NSObject


+(void)showMsg:(NSString *)str WithDuration:(CGFloat)duration WithStyle:(ShowStyle)style;
@end


@interface NSString (Size)

-(CGSize)getSizeWithMaxSize:(CGSize)maxSize WithFontSize:(int)fontSize;

@end
//
//  ColorMacro.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h

//字体

#define KTitleFont @"Heiti SC"
#define KContentFont @"Heiti SC"

//颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#define GXRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]


/** 项目默认背景颜色 */
#define kDefaultBackgroundColor     RGBACOLOR(40.f, 40.f, 40.f, 1.f)

/** 标签栏颜色 */
#define kTabBarBackColor     RGBACOLOR(25.f, 22.f, 14.f, 1.f)
/** 标签栏文字选中颜色 */
#define kTabBarItemSelectColor     RGBACOLOR(216.f, 55.f, 73.f, 1.f)
/**  标签栏文字未选中颜色 */
#define kTabBarItemNomalColor     RGBACOLOR(157.f, 155.f, 150.f, 1.f)

/** 导航栏背景颜色 */
#define kNavBackGround RGBCOLOR(31.f, 36.f, 40.f)
/** 导航栏按钮颜色 */
#define kNavTintColor RGBCOLOR(255.f, 255.f, 255.f)
/** 导航栏Title */
#define kNavTitleColor RGBCOLOR(255.f, 255.f, 255.f)

/** 黑色输入框背景*/
#define kTextFieldColor RGBCOLOR(32.f, 33.f, 34.f)

/** 黑色输入框默认文字色*/
#define kTextFieldPlaceHolderColor RGBCOLOR(71.f, 72.f, 73.f)

/** 白色输入框边框 */
#define kTextFieldGrayLayerColor RGBCOLOR(46.f, 46.f, 46.f)

/** 滑动条红色 */
#define kSliderRedColor RGBCOLOR(216.f, 55.f, 73.f)

/** 主要文字颜色 */
#define kMainFontColor RGBCOLOR(238.f, 238.f, 238.f)

/** 辅助文字颜色 */
#define kAiderFontColor RGBCOLOR(161.f, 161.f, 161.f)


/** 高亮文字颜色 */
#define kTipsFontColor RGBCOLOR(187.f, 187.f, 187.f)


/** 分割线 */
#define kSeparatorLineColor [UIColor grayColor]//RGBCOLOR(234.0f, 234.0f, 234.0f)



#endif /* ColorMacro_h */

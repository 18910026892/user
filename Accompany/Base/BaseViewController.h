//
//  BaseViewController.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Additional.h"
#import "UIButton+Addtional.h"
#import "UIImage+Additional.h"
#import "HDHud.h"

@class BaseTabBarController;
@interface BaseViewController : UIViewController

@property(nonatomic,strong)UIImageView* Customview;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* LeftBtn;
@property(nonatomic,strong)UIButton* RightBtn ;
@property(nonatomic,strong)UIImageView* backImageView;

@property(nonatomic,strong)BaseTabBarController* tabBar;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isPopToRoot;

//设置title
-(void)setNavTitle:(NSString *)title;
//返回按钮 默认显示
-(void)showBackButton:(BOOL)show;
/**
 *@brief 使用alloc创建的控制器
 */
+ (instancetype)viewController;
/**
 * @brief 设置导航栏是否隐藏 默认显示
 */
- (void)setNavigationBarHide:(BOOL)isHide;

/**
 * @brief 设置Tabbar 是否隐藏 默认显示

 */
-(void)setTabBarHide:(BOOL)isHide;


/**
 * @brief 设置背景图片
 */
-(void)setBackImageViewWithName:(NSString *)imgName;

/**
 *  @brief 初始化View
 */
-(void)setupViews;
/**
 *  @brief 初始化Data
 */
-(void)setupDatas;
/**
 *  打开IQKeyboardManager来管理键盘，默认为NO
 */
@property (nonatomic, assign) BOOL enableIQKeyboardManager;
/**
 *  是否打开弹出键盘的工具栏，默认为NO
 */
@property (nonatomic, assign) BOOL enableKeyboardToolBar;


@end

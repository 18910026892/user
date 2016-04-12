//
//  BaseViewController.m
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTabBarController.h"
#import "HttpRequest.h"
#import "IQKeyboardManager.h"

@interface BaseTabBarController()

@end

@implementation BaseViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.enableIQKeyboardManager = NO;
    }
    return self;
}

+ (instancetype)viewController{
    
    return [[self alloc] init];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar = [BaseTabBarController shareTabBarController];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = kDefaultBackgroundColor;
    
    _Customview = [[UIImageView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, kMainBoundsWidth,self.navigationController.navigationBar.frame.size.height)];
    _Customview.userInteractionEnabled = YES;
    _Customview.image = [UIImage imageNamed:@"navigationBar"];
    
    _LeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _LeftBtn.titleLabel.font = [UIFont fontWithName:KTitleFont size:16.0];
    _LeftBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-20, 0, 25);
    [_LeftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 20)];
    _LeftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    _RightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _RightBtn.titleLabel.font = [UIFont fontWithName:KTitleFont size:16];
    _RightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_RightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 28, 0, 0)];
    [_RightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainBoundsWidth/4, 10*Proportion,kMainBoundsWidth/2, 50*Proportion)];
    _titleLabel.textColor = kNavTitleColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:KTitleFont size:18];
    _titleLabel.adjustsFontSizeToFitWidth =YES;
    _titleLabel.minimumScaleFactor = 0.5;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _Customview.frame = CGRectMake(0, 0, kMainBoundsWidth,64);
        [_LeftBtn setFrame:CGRectMake(10,20, 64*Proportion, 44)];
        [_RightBtn setFrame:CGRectMake(kMainBoundsWidth - 70, 20*Proportion, 64, 44)];
        _titleLabel.frame = CGRectMake(100*Proportion, 20,kMainBoundsWidth-200*Proportion, 44);
    }
    else {
        _Customview.frame = CGRectMake(0, 0, kMainBoundsWidth,44);
        [_LeftBtn setFrame:CGRectMake(10, 10, 64*Proportion, 44)];
        [_RightBtn setFrame:CGRectMake(kMainBoundsWidth - 70, 10*Proportion, 64, 44)];
        _titleLabel.frame = CGRectMake(100*Proportion, 0,kMainBoundsWidth-200*Proportion, 44);
    }
    
    [_Customview addSubview:_RightBtn];
    [_Customview addSubview:_LeftBtn];
    [_Customview addSubview:_titleLabel];
    [self.view addSubview:_Customview];
}

//设置title
-(void)setNavTitle:(NSString *)title;
{
    self.titleLabel.text = title;
}

-(void)showBackButton:(BOOL)show{
    self.LeftBtn.hidden = !show;
    
    if(show){
        [self.LeftBtn setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
        [self.LeftBtn setImage:[UIImage imageNamed:@"BackButtonHighlighted"] forState:UIControlStateHighlighted];
        [self.LeftBtn addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.LeftBtn setImage:nil forState:UIControlStateNormal];
        [self.LeftBtn removeTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

-(void)backEvent{
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        if(_isPopToRoot==YES)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void)setEnableIQKeyboardManager:(BOOL)enableIQKeyboardManager {
    _enableIQKeyboardManager = enableIQKeyboardManager;
    /**
     *  在IQKeyboardManager屏蔽对应的键盘
     */
    if(enableIQKeyboardManager) {
        [[IQKeyboardManager sharedManager] removeDisableInViewControllerClass:[self class]];
    }
    else {
        [[IQKeyboardManager sharedManager] disableInViewControllerClass:[self class]];
    }
}

- (void)setEnableKeyboardToolBar:(BOOL)enableKeyboardToolBar {
    _enableKeyboardToolBar = enableKeyboardToolBar;
    if(enableKeyboardToolBar) {
        [[IQKeyboardManager sharedManager] removeDisableToolbarInViewControllerClass:[self class]];
    }
    else {
        [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[self class]];
    }
}

-(void)setBackImageViewWithName:(NSString *)imgName
{
    _backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _backImageView.image = [UIImage imageNamed:imgName];
    [self.view insertSubview:_backImageView atIndex:0];
}

- (void)setupViews
{
    
    
    
}
- (void)setupDatas
{
    
}

- (void)setNavigationBarHide:(BOOL)isHide;
{
    if(isHide){
        [_Customview removeFromSuperview];
    }else{
        [self.view addSubview:_Customview];
    }
}

- (void)setTabBarHide:(BOOL)isHide
{
    if(isHide){
        [self.tabBar hiddenTabBar:YES];
    }else{
        [self.tabBar hiddenTabBar:NO];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reLogin{
    NSLog(@"重新登录");
}


-(void)dealloc{
    //[[Httprequest shareRequest] cancelRequest];
}


@end

//
//  JLVersionViewController.m
//  Accompany
//
//  Created by GongXin on 16/3/19.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLVersionViewController.h"

@interface JLVersionViewController ()

@end

@implementation JLVersionViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"版本信息"];
    [self setupViews];
    [self showBackButton:YES];
    
    
}

-(void)setupViews
{
    
    [self.view addSubview:self.imageView];
    
}

-(UIImageView*)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(0, 64, kMainBoundsWidth, kMainBoundsHeight-64);
        _imageView.image = [UIImage imageNamed:@"version"];
    }
    return _imageView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

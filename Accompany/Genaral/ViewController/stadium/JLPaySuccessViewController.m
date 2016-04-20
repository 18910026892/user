//
//  JLPaySuccessViewController.m
//  Accompany
//
//  Created by GongXin on 16/3/23.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLPaySuccessViewController.h"

@implementation JLPaySuccessViewController

-(UIImageView*)PaySuccessfulImage
{
    if (!_PaySuccessfulImage) {
        _PaySuccessfulImage = [[UIImageView alloc]init];
        _PaySuccessfulImage.frame = CGRectMake(kMainBoundsWidth/2-30, 104, 60, 60);
        _PaySuccessfulImage.image = [UIImage imageNamed:@"successful"];
    }
    return _PaySuccessfulImage;
}
-(UILabel*)Label1
{
    if (!_Label1) {
        _Label1 = [[UILabel alloc]init];
        _Label1.frame = CGRectMake(0, 194, kMainBoundsWidth, 20);
        _Label1.text = @"支付成功";
        _Label1.textColor = [UIColor whiteColor];
        _Label1.textAlignment = NSTextAlignmentCenter;
        _Label1.font = [UIFont systemFontOfSize:16];
        
    }
    return _Label1;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"提示"];
    [self setupViews];
  
    
}
-(void)setupViews
{
    [self.view addSubview:self.PaySuccessfulImage];
    [self.view addSubview:self.Label1];
   
    [self.Customview addSubview:self.BackButton];
}


-(UIButton*)BackButton
{
    if (!_BackButton) {
        _BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _BackButton.frame = CGRectMake(10,20, 64*Proportion, 44);
        _BackButton.imageEdgeInsets = UIEdgeInsetsMake(0,-20, 0, 25);
        [_BackButton setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
        [_BackButton setImage:[UIImage imageNamed:@"BackButtonHighlighted"] forState:UIControlStateHighlighted];
        [_BackButton addTarget:self action:@selector(BackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _BackButton;
}

-(void)BackButtonClick:(UIButton*)sender
{

    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

//
//  ApplySuccessfulViewController.m
//  Accompany
//
//  Created by GongXin on 16/3/23.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "ApplySuccessfulViewController.h"

@implementation ApplySuccessfulViewController

-(UIImageView*)ApplySuccessfulImage
{
    if (!_ApplySuccessfulImage) {
        _ApplySuccessfulImage = [[UIImageView alloc]init];
        _ApplySuccessfulImage.frame = CGRectMake(kMainBoundsWidth/2-30, 104, 60, 60);
        _ApplySuccessfulImage.image = [UIImage imageNamed:@"successful"];
    }
    return _ApplySuccessfulImage;
}
-(UILabel*)Label1
{
    if (!_Label1) {
        _Label1 = [[UILabel alloc]init];
        _Label1.frame = CGRectMake(0, 194, kMainBoundsWidth, 20);
        _Label1.text = @"提交成功";
        _Label1.textColor = [UIColor whiteColor];
        _Label1.textAlignment = NSTextAlignmentCenter;
        _Label1.font = [UIFont systemFontOfSize:16];
        
    }
    return _Label1;
}


-(UILabel*)Label2
{
    if (!_Label2) {
        _Label2 = [[UILabel alloc]init];
        _Label2.frame = CGRectMake(0, 214, kMainBoundsWidth, 20);
        _Label2.text = @"正在审核";
        _Label2.textColor = [UIColor whiteColor];
        _Label2.textAlignment = NSTextAlignmentCenter;
        _Label2.font = [UIFont systemFontOfSize:14];
        
    }
    return _Label2;
}
-(UILabel*)Label3
{
    if (!_Label3) {
        _Label3 = [[UILabel alloc]init];
        _Label3.frame = CGRectMake(0, 234, kMainBoundsWidth, 20);
        _Label3.text = @"我们会在24小时内联系您，请您保持电话畅通！";
        _Label3.textColor = [UIColor whiteColor];
        _Label3.textAlignment = NSTextAlignmentCenter;
        _Label3.font = [UIFont systemFontOfSize:12];
        
    }
    return _Label3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"提示"];
    [self setupViews];
    [self showBackButton:YES];
    
}
-(void)setupViews
{
    [self.view addSubview:self.ApplySuccessfulImage];
    [self.view addSubview:self.Label1];
    [self.view addSubview:self.Label2];
    [self.view addSubview:self.Label3];
}
@end

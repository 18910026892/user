//
//  JLIntrolViewController.m
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright (c) 2016年 GX. All rights reserved.
//

#import "JLIntrolViewController.h"
#import "BaseTabBarController.h"
#import "AppDelegate.h"
@interface JLIntrolViewController ()<UIScrollViewDelegate>

@property (retain, nonatomic)  UIScrollView *pageScroll;
@property(nonatomic,strong) NSArray *imgsArr;

@end

@implementation JLIntrolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

-(NSArray*)createImageArray
{
    NSInteger count = 4;
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <=count; i ++)
    {
        NSString *imageName;
        if (kMainBoundsWidth==320 && kMainBoundsHeight==480)
        {
            imageName = [NSString stringWithFormat:@"index_%d.png", i];
        }
        else if(kMainBoundsWidth==320 && kMainBoundsHeight==568)
        {
            imageName = [NSString stringWithFormat:@"indexp4_%d.png",i];
        }else if(kMainBoundsWidth==375 && kMainBoundsHeight==667){
            imageName = [NSString stringWithFormat:@"indexp5_%d.png",i];
        }else if(kMainBoundsWidth==414 && kMainBoundsHeight==736){
            imageName = [NSString stringWithFormat:@"indexp6_%d.png",i];
        }
        UIImage *image = IMAGE_AT_APPDIR(imageName);
        if (image) {
            [imageArray addObject:image];
        }
    }
    return imageArray;
}


-(void)createImageViews
{
    NSInteger count = _imgsArr.count;
    if (count > 0)
    {
        _pageScroll.contentSize = CGSizeMake(kMainBoundsWidth*count, _pageScroll.frame.size.height);
        for (int i = 0; i < _imgsArr.count; i ++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainBoundsWidth*i, 0, kMainBoundsWidth, kMainBoundsHeight)];
            imageView.image = [_imgsArr objectAtIndex:i];
            [_pageScroll addSubview:imageView];
            if(i==count-1){
                UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                sureBtn.backgroundColor = [UIColor blueColor];
                sureBtn.frame = CGRectMake(0, 0, 115, 32);
                [sureBtn setImage:IMAGE_AT_APPDIR(@"icon_kaiqi_normal.png") forState:UIControlStateNormal];
                [sureBtn setImage:IMAGE_AT_APPDIR(@"icon_kaiqi_press.png") forState:UIControlStateHighlighted];
                sureBtn.centerX = imageView.left+kMainBoundsWidth/2;
                
                if (kMainBoundsWidth==320 && kMainBoundsHeight==480)
                {
                    sureBtn.bottom = kMainBoundsHeight-35;
                }
                else if(kMainBoundsWidth==320 && kMainBoundsHeight==568)
                {
                    sureBtn.bottom = kMainBoundsHeight-42;
                }else if(kMainBoundsWidth==375 && kMainBoundsHeight==667){
                    sureBtn.bottom = kMainBoundsHeight-62;
                }else if(kMainBoundsWidth==414 && kMainBoundsHeight==736){
                    sureBtn.bottom = kMainBoundsHeight-62;
                }
                
                [sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_pageScroll addSubview:sureBtn];
            }
        }
    }
}

-(void)sureBtnClicked:(id)sender
{
    BaseTabBarController *tabBar = [BaseTabBarController shareTabBarController];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

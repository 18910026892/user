//
//  HDHud.m
//  CreditGroup
//
//  Created by ang on 14/8/27.
//  Copyright (c) 2014年 JPlay. All rights reserved.
//

#import "HDHud.h"

@implementation HDHud

+(MBProgressHUD *)showHUDInView:(UIView *)view title:(NSString *)title{
    // 禁止TableView滚动
    if ([view respondsToSelector:@selector(setScrollEnabled:)]) {
        [(UIScrollView*)view setScrollEnabled:NO];
    }
    MBProgressHUD *HUDInView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUDInView.center=view.center;

    HUDInView.removeFromSuperViewOnHide = YES;
    HUDInView.labelText = title;
    HUDInView.square = YES;
    HUDInView.mode = MBProgressHUDModeCustomView;
    HUDInView.layer.cornerRadius=4.0f;
    HUDInView.layer.masksToBounds=YES;
    HUDInView.alpha=0.60;
    HUDInView.yOffset=5;
    HUDInView.labelFont=[UIFont boldSystemFontOfSize:14.0f];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, -5, 30, 30);
    NSMutableArray *imageList = [[NSMutableArray alloc] initWithCapacity:24];
    for (NSInteger i = 1; i <= 12; i++) {
        [imageList addObject:[UIImage imageNamed:[NSString stringWithFormat:@"hud_%ld",(long)i]]];
    }
    [imageView setAnimationImages:imageList];
    [imageView setAnimationDuration:1];
    [imageView startAnimating];
    
    HUDInView.customView = imageView;
    return HUDInView;
}

+(void)hideHUDInView:(UIView *)view{
    // 允许TableView滚动
    if ([view respondsToSelector:@selector(setScrollEnabled:)]) {
        [(UIScrollView*)view setScrollEnabled:YES];
    }
    
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
}

+(MBProgressHUD *)showNetWorkErrorInView:(UIView *)view{
    // 允许TableView滚动
    if ([view respondsToSelector:@selector(setScrollEnabled:)]) {
        [(UIScrollView*)view setScrollEnabled:YES];
    }
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    MBProgressHUD *HUDInView = [MBProgressHUD showHUDAddedTo:view animated:NO];
    HUDInView.removeFromSuperViewOnHide = YES;
    HUDInView.mode = MBProgressHUDModeText;
    HUDInView.labelText = @"亲，您的网络环境好像有点问题~";
    [HUDInView hide:YES afterDelay:0.5];
    return HUDInView;
}

+(MBProgressHUD *)showMessageInView:(UIView *)view title:(NSString *)title{
    // 允许TableView滚动
    if ([view respondsToSelector:@selector(setScrollEnabled:)]) {
        [(UIScrollView*)view setScrollEnabled:YES];
    }
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    MBProgressHUD *HUDInView = [MBProgressHUD showHUDAddedTo:view animated:NO];
    HUDInView.removeFromSuperViewOnHide = YES;
    HUDInView.mode = MBProgressHUDModeText;
    HUDInView.detailsLabelText = title;
    [HUDInView hide:YES afterDelay:1.5];
    return HUDInView;
}


@end

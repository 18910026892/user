//
//  JLBusinessCardViewController.m
//  Accompany
//
//  Created by GongXin on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLBusinessCardViewController.h"
#import <UMSocial.h>
#import <UMSocialQQHandler.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialSinaSSOHandler.h>
@interface JLBusinessCardViewController ()

@end

@implementation JLBusinessCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _DownloadUrl = @"http://www.baidu.com";

    [self setNavTitle:@"我的名片"];
    [self showBackButton:YES];
    [self setupViews];
}

-(void)setupViews
{
    [self.Customview addSubview:self.ShareButton];
    [self.view addSubview:self.BigBgView];
    
}
-(UIButton*)ShareButton
{
    if (!_ShareButton) {
        _ShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ShareButton.frame = CGRectMake(kMainBoundsWidth - 70, 20*Proportion, 64, 44);
        _ShareButton.backgroundColor = [UIColor clearColor];
        [_ShareButton setImage:[UIImage imageNamed:@"sharebutton"] forState:UIControlStateNormal];
        [_ShareButton addTarget:self action:@selector(ShareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _ShareButton;
}

-(void)ShareButtonClick:(UIButton*)sender
{
    NSLog(@"share");

    //微信
    
    [UMSocialData setAppKey:@"56f9ebd9e0f55a288f0002b2"];
    
     [UMSocialWechatHandler setWXAppId:@"wx81081a8c63bf91af" appSecret:@"bb612dc3b9bde84633fbd54b692a70d6" url:_DownloadUrl];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"教练随行";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"教练随行";
    
    
    //打开新浪微博的SSO开关
  //  [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
      [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2227762321" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
     

    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1104475469" appKey:@"v73xN4C1jk7NrN2N" url:_DownloadUrl];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialData defaultData].extConfig.qqData.title = @"教练随行";
    [UMSocialData defaultData].extConfig.qzoneData.title = @"教练随行";


    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56f9ebd9e0f55a288f0002b2"
                                      shareText:@"教练随行"
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,nil]
                                       delegate:self];
    
}

-(UIImageView*)BigBgView
{
    if (!_BigBgView) {
        _BigBgView = [[UIImageView alloc]init];
        _BigBgView.frame = CGRectMake(20, 124, kMainBoundsWidth-40, 346*Proportion);
        [_BigBgView setImage:[UIImage imageNamed:@"businessCard"]];
      
        [_BigBgView addSubview:self.PhotoImageView];
        [_BigBgView addSubview:self.SexImageView];
        [_BigBgView addSubview:self.NickNameLabel];
        [_BigBgView addSubview:self.IdentityLabel];
        [_BigBgView addSubview:self.BarCodeImageView];
        [_BigBgView addSubview:self.AlertLabel];
       
        
        userInfo = [UserInfo sharedUserInfo];
        
        NSString * photoImage = userInfo.userPhoto;
        
        NSString * tianChongImage = @"userPhoto";
        
        [self.PhotoImageView sd_setImageWithURL:[NSURL URLWithString:photoImage] placeholderImage:[UIImage imageNamed:tianChongImage]];
        
        self.NickNameLabel.text = userInfo.nikeName;
        
        NSString * userSex = [NSString stringWithFormat:@"%@",userInfo.userSex];
        if ([userSex isEqualToString:@"1"]) {
            
            [_SexImageView setImage:[UIImage imageNamed:@"man"]];
        }else if([userSex isEqualToString:@"2"])
        {
            [_SexImageView setImage:[UIImage imageNamed:@"woman"]];
        }else
        {
            _SexImageView.hidden = YES;
        }
        
        if ([userInfo.userType isEqualToString:@"user"]) {
            self.IdentityLabel.text = @"健身会员";
        }else if ([userInfo.userType isEqualToString:@"coach"])
        {
             self.IdentityLabel.text = @"健身教练";
        }
        
        
       
        
        UIImage * BarcodeImage = [QRCodeGenerator qrImageForString:userInfo.userId imageSize:160];
       self.BarCodeImageView.image = BarcodeImage;
    }
    
    return _BigBgView;
}

-(UIImageView*)PhotoImageView
{
    if (!_PhotoImageView) {
        _PhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,12.5, 40, 40)];
        _PhotoImageView.layer.cornerRadius = 20;
        _PhotoImageView.layer.masksToBounds = YES;
        _PhotoImageView.backgroundColor = [UIColor clearColor];
    }
    return _PhotoImageView;
    
}

-(UIImageView*)SexImageView
{
    if (!_SexImageView) {
        _SexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 12.5, 12, 12)];
        _SexImageView.layer.cornerRadius = 5;
        _SexImageView.layer.masksToBounds = YES;
        _SexImageView.backgroundColor = [UIColor clearColor];
        
    }
    return _SexImageView;
}

-(UILabel*)NickNameLabel
{
    if (!_NickNameLabel) {
        _NickNameLabel = [[UILabel alloc]init];
        _NickNameLabel.frame = CGRectMake(60,10, kMainBoundsWidth/2, 20);
        _NickNameLabel.backgroundColor = [UIColor clearColor];
        _NickNameLabel.textColor = [UIColor whiteColor];
        _NickNameLabel.font = [UIFont systemFontOfSize:14.0];
        _NickNameLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _NickNameLabel;
}

-(UILabel *)IdentityLabel
{
    if (!_IdentityLabel) {
        _IdentityLabel = [[UILabel alloc]init];
        _IdentityLabel.frame = CGRectMake(60, 30, kMainBoundsWidth/2, 20);
        _IdentityLabel.backgroundColor = [UIColor clearColor];
        _IdentityLabel.textColor = [UIColor grayColor];
        _IdentityLabel.font = [UIFont systemFontOfSize:13.0];
        _IdentityLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _IdentityLabel;

}




-(UIImageView*)BarCodeImageView
{
    if (!_BarCodeImageView) {
        _BarCodeImageView = [[UIImageView alloc]init];
        _BarCodeImageView.frame = CGRectMake(kMainScreenWidth/2-100,80, 160, 160);
      
        _BarCodeImageView.backgroundColor = [UIColor whiteColor];
    }
    
    return _BarCodeImageView;
}

-(UILabel*)AlertLabel
{
    if (!_AlertLabel) {
        _AlertLabel = [[UILabel alloc]init];
        _AlertLabel.frame = CGRectMake(20, VIEW_MAXY(self.BarCodeImageView)+23, kMainBoundsWidth-80, 20);
        _AlertLabel.backgroundColor = [UIColor clearColor];
        _AlertLabel.text = @"扫一扫上面二维码图片,查看我的主页";
        _AlertLabel.textAlignment = NSTextAlignmentCenter;
        _AlertLabel.font = [UIFont systemFontOfSize:14.0];
        _AlertLabel.textColor = [UIColor grayColor];
    }
    return _AlertLabel;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

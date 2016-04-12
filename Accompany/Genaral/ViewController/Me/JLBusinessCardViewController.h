//
//  JLBusinessCardViewController.h
//  Accompany
//
//  Created by GongXin on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "QRCodeGenerator.h"
#import <UMSocial.h>
@interface JLBusinessCardViewController : BaseViewController<UMSocialDataDelegate,UMSocialUIDelegate>
{
    UserInfo * userInfo;
}
@property (nonatomic,strong)UIButton * ShareButton;
@property (nonatomic,strong)UIImageView * BigBgView;
@property (nonatomic,strong)UIImageView * BarCodeImageView;
@property (nonatomic,strong)UIImageView * PhotoImageView;
@property (nonatomic,strong)UIImageView * SexImageView;
@property (nonatomic,strong)UILabel * NickNameLabel;
@property (nonatomic,strong)UILabel * IdentityLabel;
@property (nonatomic,strong)UILabel * AlertLabel;


@property (nonatomic,copy)NSString * DownloadUrl;

@end

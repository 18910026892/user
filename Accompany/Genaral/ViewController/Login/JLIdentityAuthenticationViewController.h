//
//  JLIdentityAuthenticationViewController.h
//  Accompany
//
//  Created by GongXin on 16/3/1.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
@interface JLIdentityAuthenticationViewController : BaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    UserInfo * userInfo;
}
@property (nonatomic,strong)UIImageView * IDImageView;

@property  (nonatomic,strong)UILabel * TitleLabel;

@property (nonatomic,strong)UILabel * contentLabel;

@property (nonatomic,strong)UIButton * photoButton;

@property (nonatomic,strong)UILabel  * buttonTitle;


@property (nonatomic,strong)UIView * BgView;

@property (nonatomic,strong)UIActionSheet * PhotoActionSheet;


//data
@property (strong,nonatomic)UIImage * upload_image;
@property (nonatomic,strong)NSData * imgData;

@property (nonatomic,copy)NSString * userPhoto;

@end

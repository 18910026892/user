//
//  LoginViewController.h
//  Accompany
//
//  Created by GX on 16/1/20.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "EMError.h"
@interface LoginViewController : BaseViewController<UITextFieldDelegate,IChatManagerDelegate>
{
    UserInfo * userInfo;
}

@property (nonatomic,strong)NSString * pushFrom;
@property(nonatomic,strong)NSString * ISRootPresent;

@property(nonatomic,strong)UIButton * BackButton;

@property (nonatomic,strong)UIImageView * BGimageView;

@property (nonatomic,strong)UIButton * RegisterButton;

@property (nonatomic,strong)UIButton * LoginButton;

@property (nonatomic,strong)UIButton * ForgetPasswordButton;

@property (nonatomic,strong)UIImageView * UsernameImageView;

@property (nonatomic,strong)UIImageView * PasswordImageView;

@property (nonatomic,strong)CustomTextField * UsernameTF;

@property (nonatomic,strong)CustomTextField * PasswordTF;

@property (nonatomic,strong)UILabel * lineLabel1 ,* lineLabel2;

@property(nonatomic,strong)UIButton * QQButton;
@property(nonatomic,strong)UIButton * WechatButton;
@property(nonatomic,strong)UIButton * WeiboButton;


//data
@property (nonatomic,copy)NSString * PhoneNumber;
@property (nonatomic,copy)NSString * Password;

@property (nonatomic,copy)NSMutableDictionary * UserDict;

@property (nonatomic,copy)NSString * qqID;
@property (nonatomic,copy)NSString * wechatID;
@property (nonatomic,copy)NSString * weiboID;

@property (nonatomic,copy)NSString * photoUrl;
@property (nonatomic,copy)NSString * nickName;





@end

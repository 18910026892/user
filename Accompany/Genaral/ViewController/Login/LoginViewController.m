//
//  LoginViewController.m
//  Accompany
//
//  Created by GX on 16/1/20.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ApplyViewController.h"
#import "ForgetPasswordViewController.h"
#import <UMSocial.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialSinaSSOHandler.h>
#import <UMSocialQQHandler.h>

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarHide:YES];
    [self setTabBarHide:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"登陆"];
    self.enableIQKeyboardManager = YES;

    
    
    [self setupViews];
 
}

-(void)setupViews
{

    [self.view addSubview:self.BGimageView];
  //  [self.view addSubview:self.BackButton];
    [self.view addSubview:self.RegisterButton];
    [self.view addSubview:self.UsernameImageView];
    [self.view addSubview:self.PasswordImageView];
    [self.view addSubview:self.UsernameTF];
    [self.view addSubview:self.PasswordTF];
    [self.view addSubview:self.lineLabel1];
    [self.view addSubview:self.lineLabel2];
    [self.view addSubview:self.LoginButton];
    [self.view addSubview:self.QQButton];
    [self.view addSubview:self.WechatButton];
    [self.view addSubview:self.WeiboButton];
    [self.view addSubview:self.ForgetPasswordButton];
    
   
}
-(UIButton*)BackButton
{
    if (!_BackButton) {
        _BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_BackButton setFrame:CGRectMake(10,20, 64*Proportion, 44)];
        _BackButton.titleLabel.font = [UIFont fontWithName:KTitleFont size:16.0];
        _BackButton.imageEdgeInsets = UIEdgeInsetsMake(0,-20, 0, 25);
        _BackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [_BackButton setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
        [_BackButton setImage:[UIImage imageNamed:@"BackButtonHighlighted"] forState:UIControlStateHighlighted];
        [_BackButton addTarget:self action:@selector(backEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _BackButton;
}
-(void)backEvent:(UIButton*)sender;
{
    
    if([_ISRootPresent isEqualToString:@"is"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dissmissBackTabbar" object:nil];
    }
 
 
    [self dismissModalViewControllerAnimated:NO];
   
}

//三方登录按钮
-(UIButton*)QQButton
{
    if (!_QQButton) {
        _QQButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_QQButton setImage:[UIImage imageNamed:@"qqlogin"] forState:UIControlStateNormal];
        _QQButton.frame = CGRectMake(80, kMainBoundsHeight-70, 30, 30);
        [_QQButton addTarget:self action:@selector(QQButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _QQButton;
}
-(void)QQButtonClick:(UIButton*)sender
{
    NSLog(@"qq");
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
     
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQzone];
            
             NSLog(@"登录后获取的用户信息是%@",snsAccount);
            
            
             [HDHud showHUDInView:self.view title:@"登录中..."];
            
            NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:snsAccount.usid,@"qq",snsAccount.userName,@"nikeName",snsAccount.iconURL,@"photoUrl", nil];
            
            NSLog(@"%@___%@",snsAccount,postDict);
            
            HttpRequest * request = [[HttpRequest alloc]init];
            
            [request RequestDataWithUrl:URL_Register pragma:postDict];
            
            request.successBlock = ^(id obj){
                
         
                _UserDict = obj[0];
                userInfo = [UserInfo sharedUserInfo];
                userInfo.isLog = YES;
                [userInfo LoginWithDictionary:_UserDict];
                
                
                //登陆
                [self loginWithUsername:userInfo.userId password:userInfo.password];
                
                //设置推送设置
                [[EaseMob sharedInstance].chatManager setApnsNickname:_PhoneNumber];
                
                
            //    [self dismissModalViewControllerAnimated:NO];
                
                
            };
            
            request.failureDataBlock = ^(id error)
            {
                [HDHud hideHUDInView:self.view];
                NSString * message = (NSString *)error;
                [HDHud showMessageInView:self.view title:message];
            };
            
            request.failureBlock = ^(id obj){
                
                [HDHud showNetWorkErrorInView:self.view];
            };
            


        }});
    
    
 
    
    
}
-(UIButton*)WechatButton
{
    if (!_WechatButton) {
        _WechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
         [_WechatButton setImage:[UIImage imageNamed:@"wechatlogin"] forState:UIControlStateNormal];
        _WechatButton.frame = CGRectMake(kMainBoundsWidth/2-15, kMainBoundsHeight-70, 30, 30);
        [_WechatButton addTarget:self action:@selector(WechatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _WechatButton;
}
-(void)WechatButtonClick:(UIButton*)sender
{
    NSLog(@"wechat");
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
               NSLog(@"微信登录后的用户信息是%@",snsAccount);
        

            [HDHud showHUDInView:self.view title:@"登录中..."];
            NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:snsAccount.usid,@"weixin",snsAccount.userName,@"nikeName",snsAccount.iconURL,@"photoUrl", nil];
            
            HttpRequest * request = [[HttpRequest alloc]init];
            
            [request RequestDataWithUrl:URL_Register pragma:postDict];
     
            request.successBlock = ^(id obj){
                
                
       
                _UserDict = obj[0];
                userInfo = [UserInfo sharedUserInfo];
                userInfo.isLog = YES;
                [userInfo LoginWithDictionary:_UserDict];
                
              
                //登陆
                [self loginWithUsername:userInfo.userId password:userInfo.password];
                
                //设置推送设置
                [[EaseMob sharedInstance].chatManager setApnsNickname:_PhoneNumber];
                
               
                
               // [self dismissModalViewControllerAnimated:NO];
                
                
            };
            
            request.failureDataBlock = ^(id error)
            {
                [HDHud hideHUDInView:self.view];
                NSString * message = (NSString *)error;
                [HDHud showMessageInView:self.view title:message];
            };
            
            request.failureBlock = ^(id obj){
                
                [HDHud showNetWorkErrorInView:self.view];
            };
            


            
        }
        
    });
    
    
    
}

-(UIButton*)WeiboButton
{
    if (!_WeiboButton) {
        _WeiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_WeiboButton setImage:[UIImage imageNamed:@"sinalogin"] forState:UIControlStateNormal];
        _WeiboButton.frame = CGRectMake(kMainBoundsWidth-110, kMainBoundsHeight-70, 30, 30);
        [_WeiboButton addTarget:self action:@selector(WeiboButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _WeiboButton;
}
-(void)WeiboButtonClick:(UIButton*)sender
{
    NSLog(@"Weibo");
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
         
            
            NSLog(@"微博登录后的用户信息%@",snsAccount);
             [HDHud showHUDInView:self.view title:@"登录中..."];
            NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:snsAccount.usid,@"weibo",snsAccount.userName,@"nikeName",snsAccount.iconURL,@"photoUrl", nil];
            
            HttpRequest * request = [[HttpRequest alloc]init];
            
            [request RequestDataWithUrl:URL_Register pragma:postDict];
            
        
            request.successBlock = ^(id obj){
            
            
                _UserDict = obj[0];
                userInfo = [UserInfo sharedUserInfo];
                userInfo.isLog = YES;
                [userInfo LoginWithDictionary:_UserDict];
                
                
                //登陆
                [self loginWithUsername:userInfo.userId password:userInfo.password];
                
                //设置推送设置
                [[EaseMob sharedInstance].chatManager setApnsNickname:_PhoneNumber];
                
                
              //  [self dismissModalViewControllerAnimated:NO];
                
                
            };
            
            request.failureDataBlock = ^(id error)
            {
                [HDHud hideHUDInView:self.view];
                NSString * message = (NSString *)error;
                [HDHud showMessageInView:self.view title:message];
            };
            
            request.failureBlock = ^(id obj){
                
                [HDHud showNetWorkErrorInView:self.view];
            };
            
            
        }});
    
}


-(UIImageView*)BGimageView
{
    if (!_BGimageView) {
        _BGimageView = [[UIImageView alloc]init];
        _BGimageView.frame = self.view.bounds;
        _BGimageView.image = [UIImage imageNamed:@"loginBg1"];
        _BGimageView.userInteractionEnabled = YES;
       
    }
    return _BGimageView;
}

-(UIButton*)RegisterButton
{
    if (!_RegisterButton) {
        _RegisterButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _RegisterButton.frame = CGRectMake(kMainScreenWidth-60, 20, 40, 35);
        _RegisterButton.backgroundColor = [UIColor clearColor];
        [_RegisterButton setTitle:@"注册" forState:UIControlStateNormal];
        [_RegisterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _RegisterButton.titleLabel.font = [UIFont systemFontOfSize:16.0];;
    
        [_RegisterButton addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _RegisterButton;
}

-(UIImageView*)UsernameImageView
{
    if (!_UsernameImageView) {
        _UsernameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(32,kMainScreenHeight/2-25,8.5,15)];
        _UsernameImageView.image = [UIImage imageNamed:@"username"];
    }
    return _UsernameImageView;
}

-(UIImageView*)PasswordImageView
{
    if (!_PasswordImageView) {
        _PasswordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(32,kMainScreenHeight/2+15,13,15)];
        _PasswordImageView.image = [UIImage imageNamed:@"password"];
        
    }
    return _PasswordImageView;
}

-(CustomTextField*)UsernameTF
{
    if (!_UsernameTF) {
        _UsernameTF = [[CustomTextField alloc]initWithFrame:CGRectMake(80, kMainScreenHeight/2-28, kMainScreenWidth-100,20)];
        _UsernameTF.placeholder = @"手机号";
        _UsernameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _UsernameTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _UsernameTF.keyboardType = UIKeyboardTypeNumberPad;
        _UsernameTF.returnKeyType = UIReturnKeyDefault;
        _UsernameTF.delegate = self;
        _UsernameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _UsernameTF.textColor = [UIColor orangeColor];
        _UsernameTF.tintColor = [UIColor orangeColor];
    
        
    }
    return _UsernameTF;
    
}
-(CustomTextField*)PasswordTF
{
    if (!_PasswordTF) {
        _PasswordTF = [[CustomTextField alloc]initWithFrame:CGRectMake(80,kMainScreenHeight/2+12, kMainScreenWidth-100,20)];
        _PasswordTF.placeholder = @"密码";
        _PasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _PasswordTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _PasswordTF.keyboardType = UIKeyboardTypeDefault;
        _PasswordTF.returnKeyType = UIReturnKeyDefault;
        _PasswordTF.delegate = self;
        _PasswordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _PasswordTF.textColor = [UIColor orangeColor];
        _PasswordTF.tintColor = [UIColor orangeColor];
        _PasswordTF.secureTextEntry = YES;
        
    }
    return _PasswordTF;
    
}

-(UILabel*)lineLabel1
{
    if (!_lineLabel1) {
        
        _lineLabel1 = [[UILabel alloc]init];
        _lineLabel1.frame = CGRectMake(20, kMainScreenHeight/2, kMainScreenWidth-40, .5);
        _lineLabel1.backgroundColor = kSeparatorLineColor;
    }
    
    return _lineLabel1;
}

-(UILabel*)lineLabel2
{
    if (!_lineLabel2) {
        
        _lineLabel2 = [[UILabel alloc]init];
        _lineLabel2.frame = CGRectMake(20, kMainScreenHeight/2+40, kMainScreenWidth-40, .5);
        _lineLabel2.backgroundColor = kSeparatorLineColor;
    }
    
    return _lineLabel2;
}

-(UIButton*)LoginButton
{
    if (!_LoginButton) {
        
        _LoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _LoginButton.frame = CGRectMake(20, VIEW_MAXY(_lineLabel2)+30, kMainScreenWidth-40, 35);
        _LoginButton.backgroundColor = [UIColor redColor];
        [_LoginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_LoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _LoginButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _LoginButton.layer.cornerRadius = 17.5;
        [_LoginButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _LoginButton;
}


-(UIButton*)ForgetPasswordButton
{
    if (!_ForgetPasswordButton) {
        _ForgetPasswordButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _ForgetPasswordButton.frame = CGRectMake(kMainScreenWidth/2,VIEW_MAXY(self.LoginButton)+5,kMainScreenWidth/2, 35);
        _ForgetPasswordButton.backgroundColor = [UIColor clearColor];
        [_ForgetPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_ForgetPasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ForgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:14.0];;
        
        [_ForgetPasswordButton addTarget:self action:@selector(ForgetPasswordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _ForgetPasswordButton;
}
-(void)registerBtnClick:(UIButton*)sender
{
    NSLog(@"register");
     [self stopEiting];
    
    RegisterViewController * registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
-(void)loginBtnClick:(UIButton*)sender
{
    NSLog(@"login");
    [self stopEiting];
    
    _PhoneNumber = _UsernameTF.text;
    _Password  = _PasswordTF.text ;
    
    if(![_PhoneNumber isValidPhone])
    {
        [HDHud showMessageInView:self.view title:@"请您输入正确的手机号"];
        
    }else  if (![_Password isValidPassword])
    {
        [HDHud showMessageInView:self.view title:@"无效的密码"];
        
    }else
    {
         [HDHud showHUDInView:self.view title:@"登录中..."];
        
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:_Password,@"password",_PhoneNumber,@"phone", nil];
        HttpRequest * request = [[HttpRequest alloc]init];
        
        [request RequestDataWithUrl:URL_login pragma:postDict];
        
      
         
        request.successBlock = ^(id obj){
            
        
         
           
            _UserDict = obj[0];
            userInfo = [UserInfo sharedUserInfo];
            userInfo.isLog = YES;
            [userInfo LoginWithDictionary:_UserDict];

            //登陆
           [self loginWithUsername:userInfo.userId password:userInfo.password];
    
            //设置推送设置
            [[EaseMob sharedInstance].chatManager setApnsNickname:_PhoneNumber];
                

         //   [self dismissModalViewControllerAnimated:NO];

            
            };
         
       
        
        request.failureDataBlock = ^(id error)
        {
            [HDHud hideHUDInView:self.view];
            NSString * message = (NSString *)error;
            [HDHud showMessageInView:self.view title:message];
        };
        
        request.failureBlock = ^(id obj){
            
            [HDHud showNetWorkErrorInView:self.view];
        };
        
        

    }
    
    

}

-(void)ForgetPasswordBtnClick:(UIButton*)sender
{
    NSLog(@"forgetpassword");
    [self stopEiting];
    ForgetPasswordViewController * fpVC = [[ForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:fpVC animated:YES];

}

#pragma textfeild 代理方法
//去掉输入的前后空格
-(NSString *)removespace:(UITextField *)textfield {
    return [textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self stopEiting];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self stopEiting];
    return YES;
    
}

-(void)stopEiting
{
    [self.UsernameTF resignFirstResponder];
    [self.PasswordTF resignFirstResponder];
    [self.UsernameTF endEditing:YES];
    [self.PasswordTF endEditing:YES];
    
}
//点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
  
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
       
         if (loginInfo && !error) {
             //设置是否自动登录
             
              [HDHud showMessageInView:self.view title:@"登录成功"];
             
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
             // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
             [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             //获取数据库中数据
             [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             
             //获取群组列表
//             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             
             //发送登录成功的通知
//             NSString * numberString = [NSString stringWithFormat:@"%@",_pushFrom];
//             
//             
//             [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOK" object:numberString];
               [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             
               [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoChange" object:nil];
             
             
             //保存最近一次登录用户名
             [self saveLastLoginUsername];
             
         }
         else
         {
             NSLog(@"登录失败");
         }
     } onQueue:nil];
}




#pragma  mark - private
- (void)saveLastLoginUsername
{
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
    }
}

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}

@end

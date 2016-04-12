//
//  RegisterViewController.m
//  Accompany
//
//  Created by GX on 16/1/20.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "RegisterViewController.h"
#import "ProtocolViewController.h"
@implementation RegisterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"注册"];
    self.enableIQKeyboardManager = YES;
    [self setupViews];
    [self showBackButton:YES];
    
}
-(void)setupViews
{
    [self.view addSubview:self.TableView];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.agreeLabel];
    [self.view addSubview:self.AgreeButton];
    
}

-(UILabel*)agreeLabel
{
    if (!_agreeLabel) {
        _agreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, VIEW_MAXY(_registerButton)+20,kMainBoundsWidth/2,20)];
        _agreeLabel.text = @"注册即表示同意";
        _agreeLabel.font = [UIFont systemFontOfSize:12];
        _agreeLabel.textAlignment = NSTextAlignmentRight;
        _agreeLabel.textColor = [UIColor whiteColor];
        _agreeLabel.backgroundColor = [UIColor clearColor];
    }
    return _agreeLabel;
}
-(UIUnderlinedButton*)AgreeButton
{
    if (!_AgreeButton) {
        _AgreeButton = [UIUnderlinedButton underlinedButton];
        _AgreeButton.frame = CGRectMake(kMainBoundsWidth/2, VIEW_MAXY(_registerButton)+15, kMainBoundsWidth/2, 30);
         _AgreeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
        [_AgreeButton setTitle:@"教练随行注册协议" forState:UIControlStateNormal];
        [_AgreeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _AgreeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _AgreeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_AgreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _AgreeButton;
}
-(void)agreeButtonClick:(UIButton*)sender
{
    NSLog(@"agree");
    [self stopEiting];
    
    ProtocolViewController * protocolVC = [[ProtocolViewController alloc]init];
    [self.navigationController pushViewController:protocolVC animated:YES];
}

-(UIButton*)registerButton
{
    if (!_registerButton) {
        
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.frame = CGRectMake(20, 320, kMainBoundsWidth-40, 35);
        _registerButton.backgroundColor = [UIColor redColor];
        [_registerButton setTitle:@"完成" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _registerButton.layer.cornerRadius = 17.5;
        [_registerButton addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}
-(void)registerBtnClick:(UIButton*)sender
{
     NSLog(@"register");
    [self stopEiting];
    
     NSString * type = @"user";
    
    CustomTextField * SendcodeTF = (CustomTextField*)[self.view viewWithTag:1001];
    _sendCode = SendcodeTF.text;
    
     CustomTextField * passwordTF  = (CustomTextField*)[self.view viewWithTag:1002];
     _passWord  = passwordTF.text;
    
     CustomTextField * againPasswordTF = (CustomTextField*)[self.view viewWithTag:1003];
    
    _AgainPassWord = againPasswordTF.text;
    
    
    if ([_sendCode length]!=6) {
        
        [HDHud showMessageInView:self.view title:@"请输入正确的验证码"];
        
    }else  if (![_passWord isValidPassword])
    {
        [HDHud showMessageInView:self.view title:@"无效的密码"];
            
    }else if (![_passWord isEqualToString:_AgainPassWord])
    {
        [HDHud showMessageInView:self.view title:@"两次密码不一致"];
    }else
    {
        [HDHud showHUDInView:self.view title:@"正在注册..."];
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",_PhoneNumber,@"phone",_passWord,@"password",_sendCode,@"code", nil];

        HttpRequest * request = [[HttpRequest alloc]init];
        
        [request RequestDataWithUrl:URL_Register pragma:postDict];
        
        NSLog(@"%@____%@",postDict,URL_Register);
        
        request.successBlock = ^(id obj){
            
            
            
            [HDHud hideHUDInView:self.view];
            [HDHud showMessageInView:self.view title:@"注册成功"];
            _UserDict = obj[0];
            userInfo = [UserInfo sharedUserInfo];
            userInfo.isLog = YES;
            [userInfo LoginWithDictionary:_UserDict];
            
            
            //登陆
            [self loginWithUsername:userInfo.userId password:userInfo.password];
            
            //设置推送设置
            [[EaseMob sharedInstance].chatManager setApnsNickname:_PhoneNumber];
            
            
            [self dismissModalViewControllerAnimated:NO];
            
            
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
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
             // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
             [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             //获取数据库中数据
             [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
 
             //发送自动登陆状态通知
           //    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOK" object:nil];
             
              [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
              [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoChange" object:nil];
         }
         else
         {
             NSLog(@"登录失败");
         }
     } onQueue:nil];
}

-(UIButton*)sendButton
{
    if (!_sendButton) {
 
         _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.layer.cornerRadius = 5;
        _sendButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _sendButton.layer.borderWidth = .5;
        
        [_sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         _sendButton.frame = CGRectMake(kMainBoundsWidth-100, 6, 90, 30);
         _sendButton.backgroundColor = [UIColor clearColor];
         _sendButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
         [_sendButton addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendButton;
}

-(void)sendBtnClick:(UIButton*)sender
{
    
    
    CustomTextField * phoneTF  = (CustomTextField*)[self.view viewWithTag:1000];
    _PhoneNumber = [NSString stringWithFormat:@"%@",phoneTF.text];
    
    NSLog(@"%@",_PhoneNumber);
    
    if(![_PhoneNumber isValidPhone])
    {
        [HDHud showMessageInView:self.view title:@"请您输入正确的手机号"];
    }else
    {
        [self startTime];
       // [HDHud showHUDInView:self.view title:@"发送中..."];
        
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:@"reg",@"type",_PhoneNumber,@"phone", nil];
        HttpRequest * request = [[HttpRequest alloc]init];
        
        [request RequestDataWithUrl:URL_sendVerifyCode pragma:postDict];
        
        NSLog(@"%@____%@",postDict,URL_sendVerifyCode);
    
        request.successBlock = ^(id obj){
            
            NSLog(@"%@",obj);
            [HDHud hideHUDInView:self.view];
            [HDHud showMessageInView:self.view title:@"发送成功"];
            
            
        };
        
        request.failureDataBlock = ^(id error)
        {
            [HDHud hideHUDInView:self.view];
            NSString * message = (NSString *)error;
            [HDHud showMessageInView:self.view title:message];
        };
        
        
        
        request.failureBlock = ^(id obj){
            
            [HDHud hideHUDInView:self.view];
            [HDHud showNetWorkErrorInView:self.view];
        };
        

        
        
    }
    
    

    
    
    
    
}
#pragma 开启时间线程
-(void)startTime{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_sendButton setTitle:@"重获验证码" forState:UIControlStateNormal];
             
               _sendButton.userInteractionEnabled = YES;
                
            });
        }else{
            //int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_sendButton setTitle:[NSString stringWithFormat:@"(%@)重新获取",strTime] forState:UIControlStateNormal];
       
                _sendButton.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}
- (UITableView *)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainBoundsWidth, 260) style:UITableViewStyleGrouped];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = NO;
        _TableView.backgroundColor = [UIColor clearColor];
        _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _TableView;
}
#pragma TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    static NSString * cellID = @"cellID";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _cellTF = [[CustomTextField alloc]initWithFrame:CGRectMake(60, 12,kMainBoundsWidth-80, 20)];
        _cellTF.textColor = [UIColor whiteColor];
        _cellTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _cellTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _cellTF.returnKeyType = UIReturnKeyDefault;
        _cellTF.delegate = self;
        _cellTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _cellTF.tag = 1000+indexPath.section;
 
        [cell.contentView addSubview:_cellTF];
        
        
        _UPcellLine = [[UILabel alloc]init];
        _UPcellLine.frame = CGRectMake(0,0,kMainBoundsWidth, .5);
        _UPcellLine.backgroundColor = kSeparatorLineColor;
        [cell.contentView addSubview:_UPcellLine];
        
        
        _DowncellLine = [[UILabel alloc]init];
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = kSeparatorLineColor;
        [cell.contentView addSubview:_DowncellLine];
        
    }
    
 
    switch (indexPath.section) {
        case 0:
        {
            _cellTF.placeholder = @"请输入手机号";
            _cellTF.keyboardType = UIKeyboardTypeNumberPad;
            
            [cell.contentView addSubview:self.sendButton];
        }
            break;
        case 1:
        {
            _cellTF.placeholder = @"请输入验证码";
            _cellTF.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case 2:
        {
            _cellTF.placeholder = @"6-16位数字或字母";
            _cellTF.keyboardType = UIKeyboardTypeDefault;
            _cellTF.secureTextEntry = YES;
        }
            break;
        case 3:
        {
            _cellTF.placeholder = @"请再次输入密码";
             _cellTF.keyboardType = UIKeyboardTypeDefault;
            _cellTF.secureTextEntry = YES;
        }
            break;
            
        default:
            break;
    }
    
    
    return cell;
    
    
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
    [self.cellTF resignFirstResponder];
    [self.cellTF endEditing:YES];
 
}

@end

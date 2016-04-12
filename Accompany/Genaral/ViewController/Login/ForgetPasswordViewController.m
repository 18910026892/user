//
//  ForgetPasswordViewController.m
//  Accompany
//
//  Created by GX on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@implementation ForgetPasswordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"忘记密码"];
    self.enableIQKeyboardManager = YES;
    [self setupViews];
     [self showBackButton:YES];
    
}
-(void)setupViews
{
    [self.view addSubview:self.TableView];
    [self.view addSubview:self.registerButton];
  
    
}

-(UIButton*)registerButton
{
    if (!_forgetButton) {
        
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetButton.frame = CGRectMake(20, 320, kMainBoundsWidth-40, 35);
        _forgetButton.backgroundColor = [UIColor redColor];
        [_forgetButton setTitle:@"完成" forState:UIControlStateNormal];
        [_forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _forgetButton.layer.cornerRadius = 17.5;
        [_forgetButton addTarget:self action:@selector(forgetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}
-(void)forgetButtonClick:(UIButton*)sender
{
    NSLog(@"forget");
    [self.cellTF endEditing:YES];
    
  
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
         [HDHud showHUDInView:self.view title:@"修改中..."];
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:_PhoneNumber,@"phone",_passWord,@"password",_sendCode,@"code", nil];
        
        HttpRequest * request = [[HttpRequest alloc]init];
        
        [request RequestDataWithUrl:URL_forgetPassword pragma:postDict];
        
        NSLog(@"%@____%@",postDict,URL_forgetPassword);
        
        request.successBlock = ^(id obj){
            
            
            [HDHud hideHUDInView:self.view];
            
            
            NSLog(@"**%@",obj);
        
                [HDHud hideHUDInView:self.view];
                [HDHud showMessageInView:self.view title:@"修改成功"];
            
                _UserDict = obj[0];
                userInfo = [UserInfo sharedUserInfo];
                [userInfo LoginWithDictionary:_UserDict];
                
                [self performSelector:@selector(backLogin) withObject:nil afterDelay:1.5];
    
            
            
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
-(void)backLogin
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIButton*)sendButton
{
    if (!_sendButton) {
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendButton.layer.cornerRadius = 5;
        _sendButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _sendButton.layer.borderWidth = .5;
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.frame = CGRectMake(kMainBoundsWidth-100, 6, 90, 30);
        _sendButton.backgroundColor = [UIColor clearColor];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendButton;
}

-(void)sendButtonClick:(UIButton*)sender
{
   
    
    CustomTextField * phoneTF  = (CustomTextField*)[self.view viewWithTag:1000];
    _PhoneNumber = [NSString stringWithFormat:@"%@",phoneTF.text];
    
    NSLog(@"%@",_PhoneNumber);
    
    if(![_PhoneNumber isValidPhone])
    {
        [HDHud showMessageInView:self.view title:@"请您输入正确的手机号"];
    }else
    {
        
        // [HDHud showHUDInView:self.view title:@"发送中..."];
         [self startTime];
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:@"fpd",@"type",_PhoneNumber,@"phone", nil];
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
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,kMainBoundsWidth, 260) style:UITableViewStyleGrouped];
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

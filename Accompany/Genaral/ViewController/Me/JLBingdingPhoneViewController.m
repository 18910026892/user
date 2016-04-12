//
//  JLBingdingPhoneViewController.m
//  Accompany
//
//  Created by GongXin on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLBingdingPhoneViewController.h"

@interface JLBingdingPhoneViewController ()

@end

@implementation JLBingdingPhoneViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTabBarHide:YES];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"绑定手机"];
    [self setupDatas];
    [self setupViews];
    [self showBackButton:YES];
    self.enableIQKeyboardManager = YES;
    
}
-(void)setupDatas
{
    _cellTitleArray = @[@"手机号",@"验证码"];
}
-(void)setupViews
{
    
    [self showBackButton:YES];
    [self.view addSubview:self.TableView];
    
}

-(UIButton*)SubmitButton
{
    if (!_SubmitButton) {
        
        _SubmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _SubmitButton.frame = CGRectMake(20,12.5, kMainScreenWidth-40, 35);
        _SubmitButton.backgroundColor = [UIColor redColor];
        [_SubmitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_SubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _SubmitButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _SubmitButton.layer.cornerRadius = 17.5;
        [_SubmitButton addTarget:self action:@selector(SubmitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _SubmitButton;
}
-(void)SubmitButtonClick:(UIButton*)sender
{
    
    CustomTextField * ctf1 = (CustomTextField*)[self.view viewWithTag:1000];
    CustomTextField * ctf2 = (CustomTextField*)[self.view viewWithTag:1001];

    
    [ctf1 resignFirstResponder];
    [ctf2 resignFirstResponder];
  
    
    _PhoneNumber = [NSString stringWithFormat:@"%@",ctf1.text];
    _CodeNumber = [NSString stringWithFormat:@"%@",ctf2.text];
    
    
    NSLog(@"%@___%@",_PhoneNumber,_CodeNumber);
    
    
    if ([_CodeNumber length]!=6) {
        
        [HDHud showMessageInView:self.view title:@"请输入正确的验证码"];
        
    }else
    {
        [HDHud showHUDInView:self.view title:@"正在提交..."];
        
        
        userInfo = [UserInfo sharedUserInfo];
        NSString * token  = userInfo.token;
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",_PhoneNumber,@"phone",_CodeNumber,@"code", nil];
        
        HttpRequest * request = [[HttpRequest alloc]init];
        
        [request RequestDataWithUrl:URL_bindingPhone pragma:postDict];
                request.successBlock = ^(id obj){
            
            
            [HDHud hideHUDInView:self.view];
            
    
                [HDHud showMessageInView:self.view title:@"绑定成功"];

                _UserDict = obj[0];
                [userInfo LoginWithDictionary:_UserDict];
                
       
            
            
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

-(UIView*)FooterView
{
    if (!_FooterView) {
        _FooterView = [[UIView alloc]init];
        _FooterView.frame = CGRectMake(0, 0, kMainBoundsWidth, 80);
        _FooterView.backgroundColor = [UIColor clearColor];
        
        [_FooterView addSubview:self.SubmitButton];
    }
    
    return _FooterView;
    
}

-(UITableView*)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainBoundsWidth,kMainBoundsHeight-64) style:UITableViewStyleGrouped];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
        
        _TableView.tableFooterView = self.FooterView;
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
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    if (section==1) {
        return 50;
    }
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [_cellTitleArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    
    UITableViewCell * cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 120, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor whiteColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
        _cellTitle.text = [_cellTitleArray objectAtIndex:indexPath.section];
        [cell.contentView addSubview:_cellTitle];
        
        
        
        _UPcellLine = [[UILabel alloc]init];
        _UPcellLine.frame = CGRectMake(0,0,kMainBoundsWidth, .5);
        _UPcellLine.backgroundColor = kSeparatorLineColor;
        [cell.contentView addSubview:_UPcellLine];
        
        
        _DowncellLine = [[UILabel alloc]init];
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = kSeparatorLineColor;
        [cell.contentView addSubview:_DowncellLine];
        
        
        _cellTextField = [[CustomTextField alloc]initWithFrame:CGRectMake(100, 12, kMainBoundsWidth-120, 20)];
        _cellTextField.textColor = [UIColor whiteColor];
        _cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _cellTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _cellTextField.keyboardType = UIKeyboardTypeDefault;
        _cellTextField.returnKeyType = UIReturnKeyDefault;
        _cellTextField.delegate = self;
        _cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _cellTextField.tag = 1000+indexPath.section;
        _cellTextField.placeholder = @"请输入";
    
        [cell.contentView addSubview:_cellTextField];
        
        
    }
    
    if (indexPath.section==1) {
        [cell.contentView addSubview:self.sendButton];
    }
    
    return cell;
    
    
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
        
        // [HDHud showHUDInView:self.view title:@"发送中..."];
         [self startTime];
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:@"bind",@"type",_PhoneNumber,@"phone", nil];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

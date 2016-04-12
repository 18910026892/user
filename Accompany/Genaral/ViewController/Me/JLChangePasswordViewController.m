//
//  JLChangePasswordViewController.m
//  Accompany
//
//  Created by GongXin on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLChangePasswordViewController.h"
#import "JLApplyViewController.h"
@interface JLChangePasswordViewController ()

@end

@implementation JLChangePasswordViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTabBarHide:YES];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"修改密码"];
    [self setupDatas];
    [self setupViews];
    [self showBackButton:YES];
    self.enableIQKeyboardManager = YES;
    
}
-(void)setupDatas
{
    _cellTitleArray = @[@"旧密码",@"新密码",@"确认密码"];
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
    CustomTextField * ctf3 = (CustomTextField*)[self.view viewWithTag:1002];
    
    
    [ctf1 resignFirstResponder];
    [ctf2 resignFirstResponder];
    [ctf3 resignFirstResponder];

    
    _OldPassWord = [NSString stringWithFormat:@"%@",ctf1.text];
    _NewPassWord = [NSString stringWithFormat:@"%@",ctf2.text];
    _AgainPassWord = [NSString stringWithFormat:@"%@",ctf3.text];
    

    
    //token(登录用户的token信息),oldPassword(原密码),newPassword（新密码）
    
    
    if(![_OldPassWord isValidPassword]||![_NewPassWord isValidPassword]||![_AgainPassWord isValidPassword])
    {
        [HDHud showMessageInView:self.view title:@"无效的密码"];
        
    }else  if (![_NewPassWord isEqualToString:_AgainPassWord])
    {
        [HDHud showMessageInView:self.view title:@"两次输入的密码不一致"];
        
    }else
    {
         [HDHud showHUDInView:self.view title:@"正在提交..."];
       
        userInfo = [UserInfo sharedUserInfo];
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.token,@"token",_OldPassWord,@"oldPassword",_NewPassWord,@"newPassword", nil];
        
        HttpRequest * request = [[HttpRequest alloc]init];
        
        [request RequestDataWithUrl:URL_updatePassword pragma:postDict];
        
 
        request.successBlock = ^(id obj){
            
            
            [HDHud hideHUDInView:self.view];
            
                NSLog(@"_______%@",obj);
            [HDHud hideHUDInView:self.view];
         
               [HDHud showMessageInView:self.view title:@"修改成功"];
                _UserDict = obj[0];
                [userInfo LoginWithDictionary:_UserDict];
                
                
                //环信推出登录
                [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                    
                    if (error && error.errorCode != EMErrorServerNotLogin) {
                        
                        
                        [HDHud showMessageInView:self.view title:error.description];
                        
                    }
                    else{
                        [[JLApplyViewController viewController] clear];
                        
                        [self loginWithUsername:userInfo.userId password:userInfo.password];
                        
                        [self performSelector:@selector(backRoot) withObject:nil afterDelay:1.5];
                    }
                } onQueue:nil];
                
       
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

         }
         else
         {
             NSLog(@"登录失败");
         }
     } onQueue:nil];
}




-(void)backRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    if (section==7) {
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
        _cellTextField.placeholder = @"6-16位字符";
        _cellTextField.secureTextEntry = YES;
    
        [cell.contentView addSubview:_cellTextField];
        
        
    }
    
    
    
    
    return cell;
    
    
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

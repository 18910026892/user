//
//  JLSetUpViewController.m
//  Accompany
//
//  Created by GongXin on 16/1/26.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLSetUpViewController.h"
#import "JLChangePasswordViewController.h"
#import "JLBingdingPhoneViewController.h"
#import "JLApplyViewController.h"
@interface JLSetUpViewController ()

@end

@implementation JLSetUpViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self requestData];
}


-(void)requestData
{
 
    userInfo = [UserInfo sharedUserInfo];
    NSString * token = userInfo.token;
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",_reply,@"reply", _praise,@"praise",_privateChat,@"privateChat",_NewFans,@"newFans",_systemMessage,@"systemMessage", nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    
    [request RequestDataWithUrl:URL_userSysSetup pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        NSLog(@" 用户设置的返回的数据 %@---%@",postDict,obj);
        NSDictionary * setUpDict = obj[0];
        NSString * newFans = [setUpDict valueForKey:@"newFans"];
        NSString * praise = [setUpDict valueForKey:@"praise"];
        NSString * privateChat = [setUpDict valueForKey:@"privateChat"];
        NSString * reply = [setUpDict valueForKey:@"reply"];
        NSString * systemMessage = [setUpDict valueForKey:@"systemMessage"];
        
        
       
        [UserDefaultsUtils saveValue:newFans forKey:@"newFans"];
        [UserDefaultsUtils saveValue:praise forKey:@"praise"];
        [UserDefaultsUtils saveValue:privateChat forKey:@"privateChat"];
        [UserDefaultsUtils saveValue:reply forKey:@"reply"];
        [UserDefaultsUtils saveValue:systemMessage forKey:@"systemMessage"];
        
        
    };
    request.failureDataBlock = ^(id error)
    {
        
         NSLog(@"%@---%@",postDict,error);
        [HDHud hideHUDInView:self.view];
        NSString * message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    };
    request.failureBlock = ^(id obj){
        
         NSLog(@"%@---%@",postDict,obj);
        [HDHud hideHUDInView:self.view];
        [HDHud showNetWorkErrorInView:self.view];
    };
    
    
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"设置"];
    [self setupDatas];
    [self setupViews];
    [self showBackButton:YES];
  

}


-(void)setupDatas
{
    _cellTitleArray = @[@"修改密码",@"绑定手机",@"回复我的",@"赞",@"私聊",@"新粉丝",@"系统通知"];
    
    if ([[UserDefaultsUtils valueWithKey:@"praise"]stringValue]) {
         _praise = [[UserDefaultsUtils valueWithKey:@"praise"]stringValue];
    }else
    {
        _praise = @"1";
    }
   
    if ([[UserDefaultsUtils valueWithKey:@"privateChat"]stringValue]) {
        _privateChat = [[UserDefaultsUtils valueWithKey:@"privateChat"]stringValue];
    }else
    {
        _privateChat = @"1";
    }
    
    if ([[UserDefaultsUtils valueWithKey:@"reply"] stringValue]) {
        _reply = [[UserDefaultsUtils valueWithKey:@"reply"] stringValue];
    }else
    {
        _reply = @"1";
    }
    
    if ([[UserDefaultsUtils valueWithKey:@"systemMessage"]stringValue]) {
         _systemMessage = [[UserDefaultsUtils valueWithKey:@"systemMessage"]stringValue];
    }else
    {
        _systemMessage = @"1";
    }
   
    
    
    if ( [[UserDefaultsUtils valueWithKey:@"newFans"] stringValue]) {
        _NewFans =    [[UserDefaultsUtils valueWithKey:@"newFans"] stringValue];
    }else
    {
        _NewFans = @"1";
    }
    
}
-(void)setupViews
{
    [self.view addSubview:self.TableView];
}

-(UIButton*)SaveButton
{
    if (!_LogoutButton) {
        
        _LogoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _LogoutButton.frame = CGRectMake(20,12.5, kMainScreenWidth-40, 35);
        _LogoutButton.backgroundColor = [UIColor redColor];
        [_LogoutButton setTitle:@"退出登陆" forState:UIControlStateNormal];
        [_LogoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _LogoutButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _LogoutButton.layer.cornerRadius = 17.5;
        [_LogoutButton addTarget:self action:@selector(LogoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _LogoutButton;
}
-(void)LogoutButtonClick:(UIButton*)sender
{
  
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"是否退出当前账号" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0);
{
    if(buttonIndex==1)
    {
        //清楚所有的用户信息
        userInfo = [UserInfo sharedUserInfo];
        [userInfo Logout];
        
         //环信推出登录
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
          
            if (error && error.errorCode != EMErrorServerNotLogin) {
             
                
                [HDHud showMessageInView:self.view title:error.description];
                
            }
            else{
                [[JLApplyViewController viewController] clear];
             
//                [self.navigationController popToRootViewControllerAnimated:YES];
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"lgoutOK" object:nil];
//                
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoChange" object:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                
            }
        } onQueue:nil];
        
    }
}
-(UIView*)FooterView
{
    if (!_FooterView) {
        _FooterView = [[UIView alloc]init];
        _FooterView.frame = CGRectMake(0, 0, kMainBoundsWidth, 80);
        _FooterView.backgroundColor = [UIColor clearColor];
        
        [_FooterView addSubview:self.SaveButton];
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
    if (section==0||section==2) {
        return 30;
    }
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    if(section==1)
    {
        return 1;
    }else if (section==6) {
        return 50;
    }else
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
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    _sectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 120, 20)];
    _sectionTitle.backgroundColor = [UIColor clearColor];
    _sectionTitle.textColor = [UIColor grayColor];
    _sectionTitle.textAlignment = NSTextAlignmentLeft;
    _sectionTitle.font = [UIFont systemFontOfSize:12.0f];
    if (section==0) {
        _sectionTitle.text = @"     个人信息";
    }else if(section==2)
    {
        _sectionTitle.text = @"     偏好";
    }
   
    
    return _sectionTitle;
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
        
    }
    
    
    if (indexPath.section==0||indexPath.section==1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else
    {
         cell.accessoryType = UITableViewCellAccessoryNone;
        
        _Switch = [[UISwitch alloc] initWithFrame:CGRectMake(kMainBoundsWidth-60, 7, 60, 30)];
        [_Switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        _Switch.tag = 1000+indexPath.section;
        _Switch.onTintColor = [UIColor redColor];
      
       
       
        
        switch (indexPath.section) {
            case 2:
            {
                if ([_reply isEqualToString:@"1"]) {
                     [_Switch setOn:YES];
                }else if([_reply isEqualToString:@"0"])
                {
                    [_Switch setOn:NO];
                }
                    
            }
                break;
                case 3:
            {
                if ([_praise isEqualToString:@"1"]) {
                    [_Switch setOn:YES];
                }else if([_praise isEqualToString:@"0"])
                {
                    [_Switch setOn:NO];
                }
            }
                break;
                case 4:
            {
                if ([_privateChat isEqualToString:@"1"]) {
                    [_Switch setOn:YES];
                }else if([_privateChat isEqualToString:@"0"])
                {
                    [_Switch setOn:NO];
                }
            }
                break;
                case 5:
            {
                if ([_NewFans isEqualToString:@"1"]) {
                    [_Switch setOn:YES];
                }else if([_NewFans isEqualToString:@"0"])
                {
                    [_Switch setOn:NO];
                }
            }
                break;
                case 6:
            {
                if ([_systemMessage isEqualToString:@"1"]) {
                    [_Switch setOn:YES];
                }else if([_systemMessage isEqualToString:@"0"])
                {
                    [_Switch setOn:NO];
                }
            }
                break;
            default:
                break;
        }
        
         [cell.contentView addSubview:_Switch];
    }
    
    return cell;
    
    
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    switch (switchButton.tag) {
        case 1002:
        {
            if (isButtonOn) {
                NSLog(@"1002打开");
                _reply = @"1";
            }else {
                NSLog(@"1002关闭");
                 _reply = @"0";
            }

        }
            break;
        case 1003:
        {
            if (isButtonOn) {
                NSLog(@"1003打开");
                _praise = @"1";
            }else {
                NSLog(@"1003关闭");
                 _praise = @"0";
            }
            
        }
            break;

        case 1004:
        {
            if (isButtonOn) {
                NSLog(@"1004打开");
                 _privateChat = @"1";
            }else {
                NSLog(@"1004关闭");
                _privateChat = @"0";
            }
            
        }
            break;

        case 1005:
        {
            if (isButtonOn) {
                NSLog(@"1005打开");
                _NewFans = @"1";
            }else {
                NSLog(@"1005关闭");
                _NewFans = @"0";
            }
            
        }
            break;

        case 1006:
        {
            if (isButtonOn) {
                _systemMessage = @"1";
            }else {
                NSLog(@"1006关闭");
                 _systemMessage = @"0";
            }
            
        }
            break;

            
        default:
            break;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (!userInfo) {
    userInfo = [UserInfo sharedUserInfo];
    }
    
    
    if (indexPath.section==0) {
        
        if ([userInfo.userPhone isValidPhone])
        {
            JLChangePasswordViewController * ChangePassWordVC  = [JLChangePasswordViewController viewController];
            [self.navigationController pushViewController:ChangePassWordVC animated:YES];
        }else
        {
            
            [HDHud showMessageInView:self.view title:@"请先去绑定手机号～"];
        }

           
      
        
        
    
        
    }else if (indexPath.section==1)
    {
        
         if ([userInfo.userPhone isValidPhone])
         {
             [HDHud showMessageInView:self.view title:@"您已经绑定手机号～"];
         }else
         {
             JLBingdingPhoneViewController * ChangePhoneVC = [JLBingdingPhoneViewController viewController];
             [self.navigationController pushViewController:ChangePhoneVC animated:YES];
         }
       
    }
    
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

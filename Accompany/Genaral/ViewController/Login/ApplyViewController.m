//
//  ApplyViewController.m
//  Accompany
//
//  Created by GX on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "ApplyViewController.h"
#import "JLUserInfoViewController.h"
#import "JLIdentityAuthenticationViewController.h"
#import "JLProfessionalCertificationViewController.h"
#import "JLGatherAccountViewController.h"
#import "ApplySuccessfulViewController.h"
@implementation ApplyViewController

-(UIButton*)BackButton
{
    if (!_BackButton) {
        _BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _BackButton.frame = CGRectMake(10,20, 64*Proportion, 44);
        _BackButton.imageEdgeInsets = UIEdgeInsetsMake(0,-20, 0, 25);
        [_BackButton setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
        [_BackButton setImage:[UIImage imageNamed:@"BackButtonHighlighted"] forState:UIControlStateHighlighted];
        [_BackButton addTarget:self action:@selector(BackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _BackButton;
}

-(void)BackButtonClick:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancleApply" object:nil];

     [self dismissModalViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self setNavTitle:@"申请教练"];
    self.enableIQKeyboardManager = YES;
    [self setupViews];
    //[self showBackButton:YES];
    
}
-(void)setupViews
{
    [self.Customview addSubview:self.BackButton];
    [self.view addSubview:self.TableView];
    [self.view addSubview:self.applyButton];
}

-(UIButton*)applyButton
{
    if (!_applyButton) {
        
        _applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyButton.frame = CGRectMake(20, 340, kMainBoundsWidth-40, 35);
        _applyButton.backgroundColor = [UIColor redColor];
        [_applyButton setTitle:@"提交申请" forState:UIControlStateNormal];
        [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _applyButton.layer.cornerRadius = 17.5;
        [_applyButton addTarget:self action:@selector(applyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyButton;
}

-(void)applyButtonClick:(UIButton*)sender
{
    NSLog(@"apply");
    
    [HDHud showHUDInView:self.view title:@"正在申请..."];
    
    userInfo = [UserInfo sharedUserInfo];
    
    NSString * token = userInfo.token;
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    
    
    [request RequestDataWithUrl:URL_applyCoachAualification pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        
        [HDHud hideHUDInView:self.view];
        
        
        _UserDict = obj[0];
        [userInfo LoginWithDictionary:_UserDict];
    
        [self.navigationController pushViewController:[ApplySuccessfulViewController viewController] animated:YES];
        
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
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 10;
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
            cell.textLabel.text = @"基本资料";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"身份认证";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"专业认证";
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"支付绑定";
        }
            break;
            
        default:
            break;
    }
    
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            NSLog(@"0");
             [self.navigationController pushViewController:[JLUserInfoViewController viewController] animated:YES];
        }
            break;
        case 1:
        {
       NSLog(@"1");
            
            [self.navigationController pushViewController:[JLIdentityAuthenticationViewController viewController] animated:YES];
        }
            break;
        case 2:
        {
        NSLog(@"2");
            [self.navigationController pushViewController:[JLProfessionalCertificationViewController viewController] animated:YES];
        }
            break;
        case 3:
        {
          NSLog(@"3");
             [self.navigationController pushViewController:[JLGatherAccountViewController viewController] animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}


@end

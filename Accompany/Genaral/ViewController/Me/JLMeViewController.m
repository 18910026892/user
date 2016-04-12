//
//  JLMeViewController.m
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLMeViewController.h"
#import "JLContactsViewController.h"
#import "JLUserInfoViewController.h"
#import "JLSetUpViewController.h"
#import "LoginViewController.h"
#import "JLCollectionViewController.h"
#import "JLHelpViewController.h"
#import "JLSubjectOrderViewController.h"
#import "JLMyAccountViewController.h"
#import "JLMyDynamicViewController.h"
#import "JLMyAttentionViewController.h"
#import "JLFansViewController.h"
#import "JLApplyViewController.h"
#import "JLVersionViewController.h"
#import "JLParticipationDynamicViewController.h"
@interface JLMeViewController ()

@end

@implementation JLMeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setTabBarHide:NO];
    
   

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"我"];
    [self setNavigationBarHide:YES];
    [self setupViews];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChange) name:@"UserInfoChange" object:nil];
    
     [self getNewUserInfo];
}


-(void)getNewUserInfo
{
    
    userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userId,@"userId",userInfo.token,@"token",nil];
  
    NSLog(@"%@",postDict);
    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_getUser pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        
        
        NSMutableDictionary * userDict = obj[0];
        
        [userDict setObject:userInfo.token forKey:@"token"];
        
        [userInfo LoginWithDictionary:userDict];
        
        
        [_LoginHeaderView removeFromSuperview];
        [_TableView setParallaxHeaderView:self.LoginHeaderView
                                     mode:VGParallaxHeaderModeFill
                                   height:64+180*Proportion];
        [_TableView reloadData];
        
        
    };
    request.failureBlock = ^(id obj){
        
        [HDHud showNetWorkErrorInView:self.view];
    };
    
    
}


-(void)userInfoChange
{
    
    [_LoginHeaderView removeFromSuperview];
    [_TableView setParallaxHeaderView:self.LoginHeaderView
                                 mode:VGParallaxHeaderModeFill
                               height:64+180*Proportion];
    [_TableView reloadData];

}

- (void)setupViews
{
    [self.view addSubview:self.TableView];
    
}

-(LoginHeaderView*)LoginHeaderView
{
  
    _LoginHeaderView = [[LoginHeaderView alloc]init];
    _LoginHeaderView.frame = CGRectMake(0, 0,kMainBoundsWidth, 64+180*Proportion);
    _LoginHeaderView.image = [UIImage imageNamed:@"mineHeader"];
    _LoginHeaderView.delegate = self;
    _LoginHeaderView.userInteractionEnabled = YES;
  
    return _LoginHeaderView;
}
#pragma LoginHeaderDelegate

-(void)EditButtonClick:(UIButton*)Button;
{
    NSLog(@"edit");
    JLUserInfoViewController * UserInfoVC = [JLUserInfoViewController viewController];
    [self.navigationController pushViewController:UserInfoVC animated:YES];
}
-(void)AttentionButtonClick:(UIButton*)Button;
{
    NSLog(@"attention");
    [self.navigationController pushViewController:[JLMyAttentionViewController viewController] animated:YES];
}
-(void)FansButtonClick:(UIButton*)Button;
{
    NSLog(@"fans");
    [self.navigationController pushViewController:[JLFansViewController viewController] animated:YES];
}
-(void)OrderButtonClick:(UIButton*)Button;
{
    NSLog(@"order");
    [self.navigationController pushViewController:[JLSubjectOrderViewController viewController] animated:YES];
    
}
-(void)AccountButtonClick:(UIButton*)Button;
{
    NSLog(@"account");

    
    [self.navigationController pushViewController:[JLMyAccountViewController viewController] animated:YES];
}
-(UITableView*)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth,kMainBoundsHeight) style:UITableViewStylePlain];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
        _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
        [_TableView setParallaxHeaderView:self.LoginHeaderView
                                     mode:VGParallaxHeaderModeFill
                                   height:64+180*Proportion];

    }
    
    return _TableView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_TableView shouldPositionParallaxHeader];
    
}

#pragma TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    
    UITableViewCell * cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _cellImageView = [[UIImageView alloc]init];
        _cellImageView.frame = CGRectMake(15,13,17, 17);
       
        [cell.contentView addSubview:_cellImageView];
        
        
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(49, 12, 120, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor whiteColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:_cellTitle];
        
        
        _DowncellLine = [[UILabel alloc]init];
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = RGBACOLOR(150,150,150, 1);
        [cell.contentView addSubview:_DowncellLine];
        
  
        
    }
    
    switch (indexPath.row) {
   
            case 0:
        {

        
        
            
            _UPcellLine = [[UILabel alloc]init];
            _UPcellLine.frame = CGRectMake(0,0,kMainBoundsWidth, .5);
            _UPcellLine.backgroundColor = RGBACOLOR(150,150,150, 1);
            [cell.contentView addSubview:_UPcellLine];
            
            
            _cellTitle.text = @"我的动态";
            
            _cellImageView.frame = CGRectMake(15,13,12, 17);
            _cellImageView.image = [UIImage imageNamed:@"mineicon1"];
            
        }
        
            break;
        case 1:
        {
            _cellTitle.text = @"我参与的动态";
            
             _cellImageView.frame = CGRectMake(13,12,20, 20);
            _cellImageView.image = [UIImage imageNamed:@"mineicon2"];
        }
            break;
            case 2:
        {
            _cellTitle.text = @"我的收藏";
            _cellImageView.image = [UIImage imageNamed:@"mineicon3"];
        }
            break;
            case 3:
            
        {
            _cellTitle.text = @"帮助与反馈";
            _cellImageView.image = [UIImage imageNamed:@"mineicon4"];
            
            
        }
            break;
            case 4:
        {
            _cellTitle.text = @"版本信息";
            
            _cellImageView.frame = CGRectMake(15,13,16, 17);
            _cellImageView.image = [UIImage imageNamed:@"mineicon5"];
        }
            break;
            
            
        default:
            break;
    }
    
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row==0) {
        
        JLMyDynamicViewController * dynamicVC = [JLMyDynamicViewController viewController];
        [self.navigationController pushViewController:dynamicVC animated:YES];
        
    }else if(indexPath.row==1)
        
    {
        JLParticipationDynamicViewController * pdVC = [JLParticipationDynamicViewController viewController];
        [self.navigationController pushViewController:pdVC animated:YES];
        
    }else if(indexPath.row==2)
        
    {
        JLCollectionViewController * collectionVC = [JLCollectionViewController viewController];
        [self.navigationController pushViewController:collectionVC animated:YES];
        
    }else if (indexPath.row==3) {
        
        JLHelpViewController * HelpVC = [JLHelpViewController viewController];
        [self.navigationController pushViewController:HelpVC animated:YES];
        
    }else if (indexPath.row==4)
    {
        JLVersionViewController * versionVc = [JLVersionViewController viewController];
        [self.navigationController pushViewController:versionVc animated:YES];
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

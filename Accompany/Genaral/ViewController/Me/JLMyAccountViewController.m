//
//  JLMyAccountViewController.m
//  Accompany
//
//  Created by 王园园 on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLMyAccountViewController.h"
#import "JLWalletViewController.h"
#import "JLChangePhoneViewController.h"
#import "JLLessonsViewController.h"
#import "JLBusinessCardViewController.h"
#import "JLSetUpViewController.h"

@interface JLMyAccountViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *DataList;
@end

@implementation JLMyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"我的账户"];
    [self setTabBarHide:YES];
    [self showBackButton:YES];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupDatas];
}

-(void)setupViews
{
    [self.view addSubview:self.table];
}

-(void)setupDatas
{
    _DataList = @[@"我的钱包",@"更换手机",@"我的课程",@"我的名片",@"设置"];
}

-(UITableView *)table
{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsWidth, kMainBoundsHeight-64) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorColor = kSeparatorLineColor;
        _table.backgroundColor = [UIColor clearColor];
    }
    return _table;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return _DataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.textLabel.text = _DataList[indexPath.section];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!userInfo) {
        userInfo = [UserInfo sharedUserInfo];
    }
    switch (indexPath.section) {
        case 0:
        {
            [self.navigationController pushViewController:[JLWalletViewController viewController] animated:YES];
        }
            break;
            case 1:
        {
            
            if ([userInfo.userPhone isValidPhone]) {
                  [self.navigationController pushViewController:[JLChangePhoneViewController viewController] animated:YES];
            }else
            {
                [HDHud showMessageInView:self.view title:@"请先去绑定手机号"];
            }
       
        }
            break;
        case 2:
        {
            
            
             [self.navigationController pushViewController:[JLLessonsViewController viewController] animated:YES];
        }
            break;
        case 3:
        {
             [self.navigationController pushViewController:[JLBusinessCardViewController viewController] animated:YES];
        }
            break;
        case 4:
        {
             [self.navigationController pushViewController:[JLSetUpViewController viewController] animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

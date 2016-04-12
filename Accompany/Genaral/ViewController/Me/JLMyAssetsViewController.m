//
//  JLMyAssetsViewController.m
//  Accompany
//
//  Created by 王园园 on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLMyAssetsViewController.h"
#import "JLTakeMoneyViewController.h"

#define titleList @[@"账户余额",@"可提现金额"]

@interface JLMyAssetsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *DataList;

@end


@implementation JLMyAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"我的资产"];
    [self setTabBarHide:YES];
    [self showBackButton:YES];
    [self setupViews];
    [self setupDatas];
}

-(void)setupViews
{
    [self.view addSubview:self.table];
    [self seTableFooterView];
}

-(void)setupDatas
{
   
    
    userInfo = [UserInfo sharedUserInfo];
    NSString * token = userInfo.token;
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    
    [request RequestDataWithUrl:URL_getUserAssets pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        NSLog(@"%@---%@",postDict,obj);
        NSDictionary * AssetsDict = obj[0];
        _AccountBalance = [AssetsDict objectForKey:@"amount"];
        [UserDefaultsUtils saveValue:_AccountBalance forKey:@"AccountBalance"];
        
        NSString * money = [NSString stringWithFormat:@"%@元",_AccountBalance];
        
         _DataList = @[money,money];
        
        [_table reloadData];
        
        
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
    return titleList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = titleList[indexPath.section];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = _DataList[indexPath.section];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
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

-(void)seTableFooterView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 100)];
    UIButton *btn = [UIButton buttonWithFrame:CGRectMake(30, 50, kMainBoundsWidth-60, 40) title:@"提现" titleColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:14.0] backgroundColor:kSliderRedColor];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 20;
    [btn addTarget:self action:@selector(takeMoneyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    _table.tableFooterView = view;
}

-(void)takeMoneyBtnClick
{
    
    userInfo = [UserInfo sharedUserInfo];
   
    NSString * IsComplate = [UserDefaultsUtils valueWithKey:@"Accountinformation"];
    
    int money = [_AccountBalance intValue];
    
    if (money>0) {
        if ([IsComplate isEqualToString:@"Accountinformation"]) {
           
            [self.navigationController pushViewController:[JLTakeMoneyViewController viewController] animated:YES];
        }else
        {
            [HDHud showMessageInView:self.view title:@"请先去完善账户信息"];
        }
        
    }else
    {
          [HDHud showMessageInView:self.view title:@"您没有可提现的余额"];
    }
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

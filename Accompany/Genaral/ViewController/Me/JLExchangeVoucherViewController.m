//
//  JLExchangeVoucherViewController.m
//  Accompany
//
//  Created by 巩鑫 on 16/2/20.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLExchangeVoucherViewController.h"

@implementation JLExchangeVoucherViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    if (self.update == YES) {
        [_TableView.header beginRefreshing];
        self.update = NO;
    }
    [self setTabBarHide:YES];
}

//添加更新控件
-(void)addRefresh
{
    
    [_TableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [_TableView.header setTitle:@"下拉可以刷新了" forState:MJRefreshHeaderStateIdle];
    [_TableView.header setTitle:@"松开马上刷新" forState:MJRefreshHeaderStatePulling];
    [_TableView.header setTitle:@"正在刷新 ..." forState:MJRefreshHeaderStateRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    [self setNavTitle:@"优惠券"];
    [self showBackButton:YES];
    self.update = YES;
    
}

//请求数据
-(void)headerRereshing
{
    _page = @"1";
    [self requestDataWithPage:1];
}

//加载更多数据
-(void)loadMoreData
{
    int page = [_page intValue];
    page ++;
    _page = [NSString stringWithFormat:@"%d",page];
    [self requestDataWithPage:2];
}
//请求数据的方法
-(void)requestDataWithPage:(int)Type
{
    
    userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page",userInfo.token,@"token",userInfo.userId, @"userId",nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_getUserPromos pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        NSLog(@"***%@",obj);
        
        _ExchangeArray = obj;
        _ExchangeModelArray = [JLExchangeModel mj_objectArrayWithKeyValuesArray:_ExchangeArray];
        
        if (Type == 1) {
            _ExchangeListArray = [NSMutableArray arrayWithArray:_ExchangeModelArray];
            [_TableView.header endRefreshing];
            [_TableView reloadData];
            
        }else if(Type == 2){
            
            NSMutableArray * Array = [[NSMutableArray alloc] init];
            [Array addObjectsFromArray:_ExchangeListArray];
            [Array addObjectsFromArray:_ExchangeModelArray];
            _ExchangeListArray = Array;
            [_TableView.footer endRefreshing];
            [_TableView reloadData];
        }
        
        if ([_ExchangeListArray count]==0) {
            [HDHud showMessageInView:self.view title:@"暂无数据"];
        }else if([_ExchangeListArray count]>9)
        {
            [_TableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            [_TableView reloadData];
            
        }
        
        
        
        
        
    };
    request.failureBlock = ^(id obj){
        
        [HDHud showNetWorkErrorInView:self.view];
    };
    
    
}



-(void)setupViews
{
    
    [self.view addSubview:self.TableView];
    
}



-(UITableView*)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 63.9, kMainBoundsWidth, kMainBoundsHeight-63.9) style:UITableViewStyleGrouped];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
        _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addRefresh];
    }
    
    return _TableView;
}
#pragma TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [_ExchangeListArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section==0) {
        return 20;
    }else
        return .1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

{
    return .1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    JLExchangeModel * model = _ExchangeListArray[indexPath.section];
    static NSString * cellID = @"cellID";
    JLExchangeVoucherCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[JLExchangeVoucherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }else{
        
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.ExchangeModel = model;
    
 
    

    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
     JLExchangeModel * model = _ExchangeListArray[indexPath.section];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addExchange" object:model];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

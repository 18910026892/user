//
//  JLMyAttentionViewController.m
//  Accompany
//
//  Created by GongXin on 16/2/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLMyAttentionViewController.h"
#import "JLPersonalCenterViewController.h"
@implementation JLMyAttentionViewController
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
    [self setNavTitle:@"我的关注"];
    [self showBackButton:YES];
    self.update = YES;
     self.automaticallyAdjustsScrollViewInsets = NO;
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
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page",userInfo.token,@"token",userInfo.userId, @"userId",@"20",@"num",nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_followUserList pragma:postDict];
    
    
    request.successBlock = ^(id obj){

        _AttentionsArray = obj;
        _AttentionsModelArray = [JLPostUserInfoModel mj_objectArrayWithKeyValuesArray:_AttentionsArray];
        
        if (Type == 1) {
            _AttentionsListArray = [NSMutableArray arrayWithArray:_AttentionsModelArray];
            [_TableView.header endRefreshing];
            [_TableView reloadData];
            
        }else if(Type == 2){
            
            NSMutableArray * Array = [[NSMutableArray alloc] init];
            [Array addObjectsFromArray:_AttentionsArray];
            [Array addObjectsFromArray:_AttentionsModelArray];
            _AttentionsListArray = Array;
            [_TableView.footer endRefreshing];
            [_TableView reloadData];
        }
        
        if ([_AttentionsListArray count]==0) {
            [HDHud showMessageInView:self.view title:@"暂无数据"];
        }else if([_AttentionsListArray count]>19)
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
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  63.9, kMainBoundsWidth,kMainBoundsHeight-63.9) style:UITableViewStylePlain];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
        _TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addRefresh];
    }
    
    return _TableView;
}
#pragma TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_AttentionsListArray count]>0?[_AttentionsListArray count]:0;;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section==0) {
        return 0;
    }else
    return .1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

{
    return .1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    JLPostUserInfoModel * model = _AttentionsListArray[indexPath.row];
    static NSString * cellID = @"cellID";
    JLAttentionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[JLAttentionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }else{
        
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.UserModel = model;
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    JLPostUserInfoModel * model = _AttentionsListArray[indexPath.row];
    
    JLPersonalCenterViewController * pcVC = [JLPersonalCenterViewController viewController];
    pcVC.userModel = model;
    [self.navigationController pushViewController:pcVC animated:YES];
}

@end

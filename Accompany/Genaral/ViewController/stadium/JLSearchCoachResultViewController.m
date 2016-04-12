//
//  JLSearchCoachResultViewController.m
//  Accompany
//
//  Created by GongXin on 16/2/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLSearchCoachResultViewController.h"
#import "JLCoachDetailViewController.h"
@implementation JLSearchCoachResultViewController
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
    // Do any additional setup after loading the view
    [self setupViews];
    [self showBackButton:YES];
    self.update = YES;
    [self setNavTitle:@"搜索结果"];
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
    
    NSString * coachName = self.keyword;
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page",coachName,@"nikeName", nil];

    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_listCoachByClub pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        
        NSLog(@"^^%@",obj);
        
        _coachArray = obj;
        _coachModelArray = [CocahModel mj_objectArrayWithKeyValuesArray:_coachArray];
        
        if (Type == 1) {
            _coachListArray = [NSMutableArray arrayWithArray:_coachModelArray];
            [_TableView.header endRefreshing];
            [_TableView reloadData];
            
        }else if(Type == 2){
            
            NSMutableArray * Array = [[NSMutableArray alloc] init];
            [Array addObjectsFromArray:_coachListArray];
            [Array addObjectsFromArray:_coachModelArray];
            _coachListArray = Array;
            [_TableView.footer endRefreshing];
            [_TableView reloadData];
        }
        
        if ([_coachListArray count]==0) {
            [HDHud showMessageInView:self.view title:@"暂无数据"];
        }else if([_coachListArray count]>9)
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
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainBoundsWidth,kMainBoundsHeight-64) style:UITableViewStylePlain];
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
    return [_coachListArray count]>0?[_coachListArray count]:0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    CocahModel * coachModel = _coachListArray[indexPath.row];
    static NSString * cellID = @"cellID";
    CoachListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[CoachListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }else{
        
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.cocahModel = coachModel;
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CocahModel * coachModel = _coachListArray[indexPath.row];
    JLCoachDetailViewController * coachDetailVC = [JLCoachDetailViewController viewController];
    coachDetailVC.coachModel = coachModel;
    [self.navigationController pushViewController:coachDetailVC animated:YES];
}

@end

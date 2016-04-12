//
//  JLSubjectDetailViewController.m
//  Accompany
//
//  Created by 王园园 on 16/3/19.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLSubjectDetailViewController.h"
#import "JLSubjectListCell.h"
#import "MJRefresh.h"
#import "JLOrderModel.h"
#define PageSzie 20
@interface JLSubjectDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *DataList;
@end

@implementation JLSubjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupDatas];
}
-(void)setupViews
{
    [self.view addSubview:self.table];
    // 集成刷新控件
    [self addRefresh];
}
//添加更新控件
-(void)addRefresh
{
    [_table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [_table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_table.header setTitle:@"下拉可以刷新了" forState:MJRefreshHeaderStateIdle];
    [_table.header setTitle:@"松开马上刷新" forState:MJRefreshHeaderStatePulling];
    [_table.header setTitle:@"正在刷新 ..." forState:MJRefreshHeaderStateRefreshing];
}
//请求数据
-(void)headerRereshing
{
    [self loadListDataWithPage:1];
}
//加载更多数据
-(void)loadMoreData
{
    NSInteger page = (_DataList.count%PageSzie)?_DataList.count/PageSzie+1:_DataList.count/PageSzie+2;
    [self loadListDataWithPage:page];
}

-(void)setupDatas
{
    _DataList = [[NSMutableArray alloc]init];
    [HDHud showHUDInView:self.view title:@"加载中"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(subjectRefresh:) name:KN_SUBJECTREFRESH object:nil];
    [self headerRereshing];
}

-(void)subjectRefresh:(NSNotification *)notify
{
    [_table.header beginRefreshing];
}

-(void)loadListDataWithPage:(NSInteger)page
{
    NSMutableDictionary * pragma = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(page),@"page",@(PageSzie),@"num",[UserInfo sharedUserInfo].token,@"token",nil];
    if(!_isHandelType){
        [pragma setObject:@"1" forKey:@"state"];
    }else{
        [pragma setObject:@"2" forKey:@"state"];
    }
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_getCourseOrder pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSArray *resultList = (NSArray *)response;
        if(page==1){
            [_DataList removeAllObjects];
        }
        if(resultList.count>0){
            NSArray *modelList = [JLOrderModel mj_objectArrayWithKeyValuesArray:resultList];
            [_DataList addObjectsFromArray:modelList];
        }
        [self stopLoadData];
        [_table reloadData];
        if(resultList.count<PageSzie){
            [_table.footer noticeNoMoreData];
        }
        if(_DataList.count==0){
            [_table.footer noticeNoData];
        }
    } DataFaiure:^(id error) {
        [self stopLoadData];
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [self stopLoadData];
        [HDHud showNetWorkErrorInView:self.view];
    }];
}
-(void)stopLoadData
{
    [HDHud hideHUDInView:self.view];
    [_table.header endRefreshing];
    [_table.footer endRefreshing];
}


-(UITableView *)table
{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kMainBoundsWidth, self.view.height-64) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.backgroundColor = [UIColor clearColor];
    }
    return _table;
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _DataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    JLSubjectListCell *cell = [tableView dequeueReusableCellWithIdentifier:[JLSubjectListCell cellIdentifier]];
    if(!cell){
        cell = [JLSubjectListCell loadFromXib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    JLOrderModel *model = (JLOrderModel *)[_DataList objectAtIndex:indexPath.row];
    [cell fillCellWithObject:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JLSubjectListCell rowHeightForObject:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JLOrderModel *model = (JLOrderModel *)[_DataList objectAtIndex:indexPath.row];
    if(_delegate){
        [_delegate subjectDetailVC:self CellData:model];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  JLMyCommunitysViewController.m
//  Accompany
//
//  Created by 王园园 on 16/2/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLMyCommunitysViewController.h"
#import "JLMycomListCell.h"
#import "JLCommunityInfoViewController.h"
#import "JLPostListViewController.h"
#import "JLMyCommunityModel.h"
#import "MJRefresh.h"

#define PageSzie 20
@interface JLMyCommunitysViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *DataList;

@end

@implementation JLMyCommunitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(_type == RecommendCommunity){
        [self setNavTitle:@"推荐社区"];
    }else [self setNavTitle:@"我的社区"];
    [self showBackButton:YES];
    [self setTabBarHide:YES];
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
    [self headerRereshing];
}

-(void)loadListDataWithPage:(NSInteger)page
{
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",@(page),@"page",@(PageSzie),@"num",nil];
    NSString *url = URL_MyCommunity;
    if(_type == RecommendCommunity){
        url = URL_RecommentCommunity;
    }
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:url pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSArray *resultList = (NSArray *)response;
        if(page==1){
            [_DataList removeAllObjects];
        }
        if(resultList.count>0){
            NSArray *modelList = [JLMyCommunityModel mj_objectArrayWithKeyValuesArray:resultList];
            [_DataList addObjectsFromArray:modelList];
        }
        [self stopLoadData];
        [_table reloadData];
        if(resultList.count<PageSzie){
            [_table.footer noticeNoMoreData];
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
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0,64, kMainBoundsWidth, kMainScreenHeight-64) style:UITableViewStyleGrouped];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _DataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    JLMycomListCell *cell = [tableView dequeueReusableCellWithIdentifier:[JLMycomListCell cellIdentifier]];
    if(!cell){
        cell = [JLMycomListCell loadFromXib];
        cell.attentionBtn.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell fillCellWithObject:_DataList[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JLMycomListCell rowHeightForObject:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JLMyCommunityModel *model = _DataList[indexPath.row];
    JLPostListViewController *listVC = [[JLPostListViewController alloc]init];
    listVC.communityId = model.communityId;
    listVC.communityName = model.name;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

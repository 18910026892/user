//
//  JLComDetailViewController.m
//  Accompany
//
//  Created by 王园园 on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLComDetailViewController.h"
#import "JLPostDetailViewController.h"
#import "JLPostListCell.h"
#import "JLAcommunityTopCell.h"
#import "JLPostListModel.h"
#import "MJRefresh.h"
#import "JLComRequestManager.h"
#import "JLMyCommunityModel.h"
#define PageSzie 20
static const char kRepresentedObject;
@interface JLComDetailViewController ()<UITableViewDataSource,UITableViewDelegate,AcommunityTopCellDelegate,PostListCellDelegate>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *DataList;
@property(nonatomic,strong)NSMutableArray *recommentList;

@property(nonatomic,strong)UIView *topView;
@end

@implementation JLComDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpViews];
    [self setupDatas];
}


-(void)setUpViews
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
    _recommentList =[[NSMutableArray alloc]init];
    [HDHud showHUDInView:self.view title:@"加载中"];
    [self headerRereshing];
    [self loadRecommentListData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PostRefresh:) name:KN_POSTREFRESH object:nil];
}
-(void)PostRefresh:(NSNotification *)notify
{
    [_table.header beginRefreshing];
}

-(void)loadListDataWithPage:(NSInteger)page
{
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",@(page),@"page",@(PageSzie),@"num",nil];
    NSLog(@"_______%@,%@",URL_CommunityAllPostList,pragma);
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_CommunityAllPostList pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSArray *resultList = (NSArray *)response;
        if(page==1){
            [_DataList removeAllObjects];
        }
        if(resultList.count>0){
            NSArray *modelList = [JLPostListModel mj_objectArrayWithKeyValuesArray:resultList];
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

//推荐数据
-(void)loadRecommentListData
{
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",@(1),@"page",@(5),@"num",nil];
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_RecommentCommunity pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSArray *resultList = (NSArray *)response;
        if(resultList.count>0){
            NSArray *modelList = [JLMyCommunityModel mj_objectArrayWithKeyValuesArray:resultList];
            [_recommentList addObjectsFromArray:modelList];
        }
        [_table reloadData];
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}


-(UITableView *)table
{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, self.view.height-49-64) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = [UIColor clearColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.tableHeaderView = self.topView;
    }
    return _table;
}

-(UIView *)topView
{
    if(!_topView){
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 90)];
        _topView.backgroundColor = RGBACOLOR(32., 36., 40., 1);
        NSArray *btnTitleArr = @[@"我的社区",@"创建社区"];
        NSArray *imgArr = @[@"myCommunity",@"creatCommunity"];
        float b_whith = 140;
        for(int i=0;i<2;i++){
            UIButton *btn = [UIButton buttonWithFrame:CGRectMake(kMainBoundsWidth/2-b_whith, 5, b_whith, 80) title:btnTitleArr[i] titleColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:12.0] backgroundColor:[UIColor clearColor]];
            if(i==1){
                btn.frame = CGRectMake(kMainBoundsWidth/2, 5, b_whith, 80);
            }
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(17, 54, 36, 54)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(38, 0, 0, 30)];
            [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_topView addSubview:btn];
        }
    }
    return _topView;
}

#pragma mark-
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return  section?_DataList.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    JLPostListCell *cell = [tableView dequeueReusableCellWithIdentifier:[JLPostListCell cellIdentifier]];
    if(indexPath.section==0){
        JLAcommunityTopCell *topcell = [tableView dequeueReusableCellWithIdentifier:[JLAcommunityTopCell cellIdentifier]];
        if(!topcell){
            topcell = [JLAcommunityTopCell loadFromXib];
            topcell.delegate = self;
            topcell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [topcell fillCellWithObject:_recommentList];
        return topcell;
    }
    if(!cell){
        cell = [JLPostListCell loadFromXib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [cell fillCellWithObject:_DataList[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return [JLAcommunityTopCell rowHeightForObject:nil];
    }else
        return [JLPostListCell rowHeightForObject:[_DataList objectAtIndex:indexPath.row]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section<2){
        return 25;
    }else return 8;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 25)];
    NSArray *arr = @[@"推荐社区",@"社区广场"];
    if(section<2){
        UILabel *label = [UILabel labelWithFrame:CGRectMake(10, 3, 100, 20) text:arr[section] textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13.0] backgroundColor:[UIColor clearColor]];
        [view addSubview:label];
        if(section==0){//右剪头
            UIImageView *arow = [[UIImageView alloc]initWithFrame:CGRectMake(view.width-15, 7, 7, 12)];
            arow.image = [UIImage imageNamed:@"rightRow"];
            [view addSubview:arow];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(view.width-160, 0, 160, 30);
            [btn addTarget:self action:@selector(morebtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
    }
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_delegate){
        [_delegate comDetailViewController:self didSelectData:_DataList[indexPath.row]];
    }
}

-(void)acommunityTopCell:(JLAcommunityTopCell *)cell TopImageViewClickWithData:(JLMyCommunityModel *)data
{
    if(_delegate){
        [_delegate comDetailViewController:self recommendtionSelectData:data];
    }
}
-(void)morebtnClick:(UIButton *)btn
{
    if(_delegate){
        [_delegate comDetailViewControllerMoreRecommentClick];
    }
}
-(void)topBtnClick:(UIButton *)btn
{
    NSLog(@"%ld",(long)btn.tag);
    if(_delegate){
        [_delegate comDetailViewController:self clickTopBtnTag:btn.tag];
    }
}

#pragma mark -
#pragma mark - PostDelegate
-(void)postCellzanBtn:(UIButton *)zanBtn clickedWithData:(JLPostListModel *)celldata;
{
    [JLComRequestManager AdmirePostWithPostInfoModel:celldata Success:^(id response) {
        NSLog(@"点赞成功");
        [self headerRereshing];
    } Fail:^(id error) {
        [HDHud showMessageInView:self.view title:error];
    } netFail:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}
-(void)postCellshareBtn:(UIButton *)shareBtn clickedWithData:(id)celldata;
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示" message:@"是否转载该帖子"
                          delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"确定",nil];
    objc_setAssociatedObject(alert,
                             &kRepresentedObject,
                             celldata,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    alert.tag = 1000;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0) return;
    id celldata = objc_getAssociatedObject(alertView,&kRepresentedObject);
    if(alertView.tag==1000){
        [JLComRequestManager repasteWithPostInfoModel:celldata Success:^(id response) {
            NSLog(@"转帖成功");
            [HDHud showMessageInView:self.view title:@"转载成功"];
            [_table.header beginRefreshing];
        } Fail:^(id error) {
            [HDHud showMessageInView:self.view title:error];
        } netFail:^(id error) {
            [HDHud showNetWorkErrorInView:self.view];
        }];
    }else if (alertView.tag == 1001){
        [JLComRequestManager deleteWithPostInfoModel:celldata Success:^(id response) {
            NSLog(@"删帖成功");
            [HDHud showMessageInView:self.view title:@"删除成功"];
            [_table.header beginRefreshing];
        } Fail:^(id error) {
            [HDHud showMessageInView:self.view title:error];
        } netFail:^(id error) {
            [HDHud showNetWorkErrorInView:self.view];
        }];
    }
    
}

-(void)postCelldeleteBtn:(UIButton *)commentBtn clickedWithData:(id)celldata
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示" message:@"确认删除该帖子"
                          delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"确定",nil];
    alert.tag = 1001;
    objc_setAssociatedObject(alert,
                             &kRepresentedObject,
                             celldata,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
}

-(void)postCellcommentBtn:(UIButton *)commentBtn clickedWithData:(JLPostListModel *)celldata;
{
    if(_delegate){
        [_delegate comDetailVCcommentBtn:commentBtn clickedWithData:celldata];
    }
}
-(void)postCell:(JLPostListCell *)cell userImageTapWithData:(id)celldata;
{
    if(_delegate){
        [_delegate comPostCell:cell userImageTapWithData:celldata];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

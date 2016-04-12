//
//  JLStarLevelViewController.m
//  Accompany
//
//  Created by 王园园 on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLStarLevelViewController.h"
#import "JLPublicViewController.h"
#import "JLPostListCell.h"
#import "JLPostListModel.h"
#import "MJRefresh.h"
#import "JLComRequestManager.h"
#import "JLPersonalCenterViewController.h"
#define PageSzie 20
static const char kRepresentedObject;
@interface JLStarLevelViewController ()<UITableViewDataSource,UITableViewDelegate,PostListCellDelegate>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *DataList;


@end

@implementation JLStarLevelViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PostRefresh:) name:KN_POSTREFRESH object:nil];
    [self headerRereshing];
}


-(NSString *)getUrlWithType:(NSInteger)comType
{
    switch (comType) {
        case StarCommunity:
            return URL_CommunityStarPostList;
            break;
        case AttentionCommunity:
            return URL_CommunityAttentionPostList;
            break;
        case PostCommunity:
            return URL_CommunityDetail;
            break;
        case MyPostCommunity:
            return URL_CommunityMyPostList;
            break;
            case InvolvementPosts:
            return URL_involvementPosts;
            break;
        default:
            return @"";
            break;
    }
}
-(void)PostRefresh:(NSNotification *)notify
{
    [_table.header beginRefreshing];
}
-(void)loadListDataWithPage:(NSInteger)page
{
    if(_type==AttentionCommunity && [UserInfo sharedUserInfo].isLog==NO){
        [self stopLoadData];
        return;
    }
    NSMutableDictionary *pragma = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",@(page),@"page",@(PageSzie),@"num",nil];
    NSString *url = [self getUrlWithType:_type];
    if(_type==PostCommunity){
        [pragma setObject:_communityId forKey:@"communityId"];
    }
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:url pragma:pragma];
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
    JLPostListCell *cell = [tableView dequeueReusableCellWithIdentifier:[JLPostListCell cellIdentifier]];
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
    return [JLPostListCell rowHeightForObject:[_DataList objectAtIndex:indexPath.row]];
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
    if(_delegate){
        [_delegate starLevelViewController:self didSelectData:_DataList[indexPath.row]];
    }
}

#pragma mark -
#pragma mark - PostDelegate
-(void)postCellzanBtn:(UIButton *)zanBtn clickedWithData:(JLPostListModel *)celldata;
{
    [JLComRequestManager AdmirePostWithPostInfoModel:celldata Success:^(id response) {
        NSLog(@"点赞成功");
        //[zanBtn setImage:[UIImage imageNamed:@"zan_red"] forState:UIControlStateNormal];
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
    alert.tag = 1000;
    objc_setAssociatedObject(alert,
                             &kRepresentedObject,
                             celldata,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
        [_delegate starLeverVCcommentBtn:commentBtn clickedWithData:celldata];
    }
}


-(void)postCell:(JLPostListCell *)cell userImageTapWithData:(id)celldata;
{
    if(_delegate){
        [_delegate starPostCell:cell userImageTapWithData:celldata];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  JLSystemMessageViewController.m
//  Accompany
//
//  Created by GongXin on 16/2/19.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLSystemMessageViewController.h"

@implementation JLSystemMessageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    if (self.update == YES) {
//        [_TableView.header beginRefreshing];
//        self.update = NO;
//    }
//
//    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBarHide:YES];
    [self setupViews];
     self.update = YES;
   [self setupDatas];
}
-(void)setupDatas
{
    [_TableView.header beginRefreshing];
}
//请求数据的方法
-(void)requestDataWithPage:(int)Type
{
    userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page",userInfo.token,@"token",userInfo.userId, @"userId",nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_getSysMessage pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        NSLog(@"***%@",obj);
        
        _MessageArray = obj;
        _MessageModelArray = [MessageModel mj_objectArrayWithKeyValuesArray:_MessageArray];
        
        if (Type == 1) {
            _MessageListArray = [NSMutableArray arrayWithArray:_MessageModelArray];
            [_TableView.header endRefreshing];
            [_TableView reloadData];
            
        }else if(Type == 2){
            
            NSMutableArray * Array = [[NSMutableArray alloc] init];
            [Array addObjectsFromArray:_MessageListArray];
            [Array addObjectsFromArray:_MessageModelArray];
            _MessageListArray = Array;
            [_TableView.footer endRefreshing];
            [_TableView reloadData];
        }
        
        if ([_MessageListArray count]==0) {
            [HDHud showMessageInView:self.view title:@"暂无数据"];
        }else if([_MessageListArray count]>9)
        {
            [_TableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            [_TableView reloadData];
            
        }
         
        
    };
    request.failureBlock = ^(id obj){
        
        [HDHud showNetWorkErrorInView:self.view];
    };

    
}
//添加更新控件
-(void)addRefresh
{
    
    [_TableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [_TableView.header setTitle:@"下拉可以刷新了" forState:MJRefreshHeaderStateIdle];
    [_TableView.header setTitle:@"松开马上刷新" forState:MJRefreshHeaderStatePulling];
    [_TableView.header setTitle:@"正在刷新 ..." forState:MJRefreshHeaderStateRefreshing];
     [_TableView.header setTextColor:[UIColor whiteColor]];
}
//设置请求参数
-(void)addParameter
{
    _page = @"1";
}
//更新数据
-(void)headerRereshing
{
    [self addParameter];
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

-(void)setupViews
{
    [self.view addSubview:self.TableView];
}

- (UITableView *)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kMainBoundsWidth,kMainBoundsHeight-113)style:UITableViewStyleGrouped];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
        _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addRefresh];
    }
    
    return _TableView;
}
#pragma mark TableView Datasorce;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section==0) {
        return 20;
    }else
        return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 181+126*Proportion;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
     return [_MessageListArray count]!=0?[_MessageListArray count]:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //初始化每行的数据模型
    MessageModel * messageModel = _MessageListArray[indexPath.section];
    
    static NSString * cellID = @"messageCell";
    MessageTableViewCell * cell = [_TableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }else{
        
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.messageModel = messageModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    MessageModel * messageModel = _MessageListArray[indexPath.section];

    if (messageModel) {
    
        if(_delegate){
            
            [_delegate viewcontroller:self didSelectSystemModel:messageModel];
        }
        
    }
}

//UITable编辑
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//执行编辑风格
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel * messageModel = _MessageListArray[indexPath.section];
    NSString * messageID = messageModel.id;
    [self deleteData:messageID];

    [self.MessageListArray removeObjectAtIndex:indexPath.section];
    [self.TableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];

}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)deleteData:(NSString*)messageID
{
    
    NSString * messageId = messageID;

    userInfo = [UserInfo sharedUserInfo];
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:messageId,@"id",userInfo.token,@"token",userInfo.userId, @"userId",nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_delSysMessage pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        NSLog(@"***%@",obj);
      
        
        
    };
    request.failureDataBlock = ^(id error)
    {
        [HDHud hideHUDInView:self.view];
        NSString * message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    };
    
    
    
    request.failureBlock = ^(id obj){
        
        [HDHud showNetWorkErrorInView:self.view];
    };
    

    
}

@end

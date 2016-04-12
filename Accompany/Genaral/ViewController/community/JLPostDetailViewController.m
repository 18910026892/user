//
//  JLPostDetailViewController.m
//  Accompany
//
//  Created by 王园园 on 16/2/19.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLPostDetailViewController.h"
#import "JLPostListCell.h"
#import "JLCommentListCell.h"
#import "JLPostUserInfoModel.h"
#import "MJRefresh.h"
#import "JLPostListModel.h"
#import "JLPostCommentListModel.h"
#import "JLComRequestManager.h"
#import "JLPersonalCenterViewController.h"
#define PageSzie 20
static const char kRepresentedObject;

@interface JLPostDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,PostListCellDelegate>


@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong) UIView * commentView;
@property(nonatomic,strong)NSMutableArray *AdmireList;
@property(nonatomic,strong)NSMutableArray *DataList;

@property (nonatomic,strong)UITextField *textfield;
@property (nonatomic,strong) JLPostCommentListModel *selectCommentModel;

@end

@implementation JLPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"帖子详情"];
    [self setTabBarHide:YES];
    [self showBackButton:YES];
    [self setupDatas];
    [self setupViews];
    if(_isCommentSate == YES){
        [_textfield becomeFirstResponder];
    }
}

-(void)setupViews
{
    self.enableIQKeyboardManager = YES;
    self.enableKeyboardToolBar = NO;
    if(![[UserInfo sharedUserInfo].userId isEqualToString:_postInfoModel.grssUser.userId]){
        [self.RightBtn setImage:[UIImage imageNamed:@"zhaunTie"] forState:UIControlStateNormal];
        [self.RightBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }

    [self.view addSubview:self.table];
    
    _commentView = [self setCommentView];
    _commentView.frame = CGRectMake(-1, kMainBoundsHeight-49, 322, 50);
    [self.view addSubview:self.commentView];
    
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
    [self LoadPostDetail];
    [self LoadAdmireList];
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

#pragma mark -Load
//帖子详情
-(void)LoadPostDetail
{
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",_postInfoModel.postId,@"postsId",nil];
    NSLog(@"_______________%@%@",URL_PostDetail,pragma);
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_PostDetail pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        [HDHud hideHUDInView:self.view];
        NSLog(@"%@",response);
        NSDictionary *dict = (NSDictionary *)response[0];
        _postInfoModel = [JLPostListModel mj_objectWithKeyValues:dict];
        [_table reloadData];
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}

//获取评论
-(void)loadListDataWithPage:(NSInteger)page
{
    [HDHud showHUDInView:self.view title:@"加载中"];
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:_postInfoModel.postId,@"postsId",@(page),@"page",@(PageSzie),@"num",nil];
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_PostCommentList pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSArray *resultList = (NSArray *)response;
        if(page==1){
            [_DataList removeAllObjects];
        }
        if(resultList.count>0){
            NSArray *modelList = [JLPostCommentListModel mj_objectArrayWithKeyValuesArray:resultList];
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
        [HDHud hideHUDInView:self.view];
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

//点赞人员
-(void)LoadAdmireList
{
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:_postInfoModel.postId,@"postsId",@(1),@"page",@(20),@"num",nil];
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_AdmirePeoples pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSArray *resultList = (NSArray *)response;
        _AdmireList = [[NSMutableArray alloc]init];
        if(resultList.count>0){
            NSArray *modelList = [JLPostUserInfoModel mj_objectArrayWithKeyValuesArray:resultList];
            [_AdmireList addObjectsFromArray:modelList];
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
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0,64, kMainBoundsWidth, kMainBoundsHeight-64-40) style:UITableViewStyleGrouped];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section==0){
        return 1;
    }else
        return _DataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    JLPostListCell *cell = [tableView dequeueReusableCellWithIdentifier:[JLPostListCell cellIdentifier]];
    if(indexPath.section==0){
        if(!cell){
            cell = [JLPostListCell loadFromXib];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [cell fillPostDetailCellWithObject:_postInfoModel admireListArr:_AdmireList];
        return cell;
    }else{
        JLCommentListCell *commentCell = [tableView dequeueReusableCellWithIdentifier:[JLCommentListCell cellIdentifier]];
        if(!commentCell){
            commentCell = [JLCommentListCell loadFromXib];
            commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [commentCell fillCellWithObject:_DataList[indexPath.row]];
        return commentCell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return [JLPostListCell rowHeightForObject:_postInfoModel];
    }else{
        return [JLCommentListCell rowHeightForObject:_DataList[indexPath.row]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1) return 25;
    else return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 25)];
    NSString *commentNum = [NSString stringWithFormat:@"评论%@",_postInfoModel.remarkTotal];
    if(section==1){
        UILabel *label = [UILabel labelWithFrame:CGRectMake(10, 3, 100, 20) text:commentNum textColor:[UIColor grayColor] font:[UIFont boldSystemFontOfSize:13.0] backgroundColor:[UIColor clearColor]];
        [view addSubview:label];
    }
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0) return;
    [_textfield becomeFirstResponder];
    JLPostCommentListModel *commentModel = [_DataList objectAtIndex:indexPath.row];
    _selectCommentModel = commentModel;
    NSString *placeHoler = [NSString stringWithFormat:@"@%@：",commentModel.remarkName];
    _textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHoler attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
}

-(UIView *)setCommentView
{
       UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, 322, 50)];
        view.backgroundColor = RGBACOLOR(30., 32., 35., 1);
        view.layer.borderColor = [UIColor darkGrayColor].CGColor;
        view.layer.borderWidth = 0.5;
        
         UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(10,6, kMainBoundsWidth-20, 36)];
        [tf setBorderStyle:UITextBorderStyleNone];
        tf.delegate = self;
        tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  想对我说点什么" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        tf.textColor = [UIColor whiteColor];
        tf.returnKeyType = UIReturnKeyDone;
        tf.backgroundColor = [UIColor clearColor];
        tf.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        tf.layer.borderWidth = 0.5f;
        tf.layer.cornerRadius = 3.0f;
        [view addSubview:tf];
    _textfield = tf;
    return view;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _selectCommentModel = nil;
    _textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  想对我说点什么" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"发送");
    NSString *content = [Helper RemoveStringWhiteSpace:textField];
    if(content.length>0){
        [JLComRequestManager CommentPostWithPostInfoModel:_postInfoModel ReplyUserId:_selectCommentModel.remarkUserId Content:content Success:^(id response) {
            NSLog(@"评论成功");
            textField.text = @"";
            [_table.header beginRefreshing];
        } Fail:^(id error) {
            [HDHud showMessageInView:self.view title:error];
        } netFail:^(id error) {
            [HDHud showNetWorkErrorInView:self.view];
        }];
    }
    [_textfield resignFirstResponder];
    return YES;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textfield resignFirstResponder];
}

#pragma mark -
#pragma mark - PostDelegate
-(void)postCellzanBtn:(UIButton *)zanBtn clickedWithData:(JLPostListModel *)celldata;
{
    [JLComRequestManager AdmirePostWithPostInfoModel:celldata Success:^(id response) {
        NSLog(@"点赞成功");
        [self LoadPostDetail];
        [self LoadAdmireList];
    } Fail:^(id error) {
        [HDHud showMessageInView:self.view title:error];
    } netFail:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}

-(void)postCellattentionBtn:(UIButton *)commentBtn clickedWithData:(JLPostListModel *)celldata;
{
    [HDHud showHUDInView:self.view title:@"提交"];
    [JLComRequestManager attentionUserWithPostInfoModel:celldata.grssUser Success:^(id response) {
        NSLog(@"%@",response);
        [self LoadPostDetail];
    } Fail:^(id error) {
        [HDHud hideHUDInView:self.view];
        [HDHud showMessageInView:self.view title:error];
    } netFail:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}


-(void)shareBtnClick
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示" message:@"是否转载该帖子"
                          delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"确定",nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0) return;
    [JLComRequestManager repasteWithPostInfoModel:_postInfoModel Success:^(id response) {
        NSLog(@"转帖成功");
        [HDHud showMessageInView:self.view title:@"转载成功"];
    } Fail:^(id error) {
        [HDHud showMessageInView:self.view title:error];
    } netFail:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}

-(void)starPostCell:(JLPostListCell *)cell userImageTapWithData:(id)celldata;
{
    JLPostListModel *model = (JLPostListModel *)celldata;
    JLPersonalCenterViewController *vc = [JLPersonalCenterViewController viewController];
    vc.userModel = model.grssUser;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  JLAddCommunityViewController.m
//  Accompany
//
//  Created by 王园园 on 16/2/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLAddCommunityViewController.h"
#import "JLPostListViewController.h"
#import "JLMyCommunitysViewController.h"
#import "JLMycomListCell.h"
#import "JLMyCommunityModel.h"

#define PageSzie 20

@interface JLAddCommunityViewController ()<UISearchBarDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextField *searchField;
    UIButton *cancalBtn;
}
@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)NSMutableArray *DataList;
@property BOOL isSearching;
@end

@implementation JLAddCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButton:YES];
    [self setTabBarHide:YES];
    [self setupViews];
    [self setupDatas];
}

-(void)setupViews
{
    self.enableKeyboardToolBar = NO;
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(40, 27, kMainBoundsWidth-50, 30)];
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.backgroundColor = [UIColor blackColor];
    searchField.layer.cornerRadius = 10.;
    searchField.font = [UIFont systemFontOfSize:14.0];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.layer.masksToBounds = YES;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.clearsOnBeginEditing = YES;
    searchField.textColor = [UIColor whiteColor];
    searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"🔍搜索用户名 手机号 昵称" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    searchField.tintColor = kTabBarItemSelectColor;
    searchField.delegate = self;
    [self.view addSubview:searchField];
    [self.view addSubview:self.table];
    [self addRefresh];
}

-(void)showCancelBtn:(BOOL)show
{
    if(!cancalBtn){
        cancalBtn = [UIButton buttonWithFrame:CGRectMake(kMainBoundsWidth, 24, 45, 40) title:@"取消" titleColor:[UIColor redColor] font:[UIFont systemFontOfSize:14] backgroundColor:[UIColor clearColor]];
        [cancalBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancalBtn];
    }
    [UIView animateWithDuration:0.2 animations:^{
        if(show){
            searchField.frame = CGRectMake(40, 27, kMainBoundsWidth-85, 30);
            cancalBtn.frame = CGRectMake(kMainBoundsWidth-45, 24, 45, 40);
        }else{
            searchField.frame = CGRectMake(40, 27, kMainBoundsWidth-50, 30);
            cancalBtn.frame = CGRectMake(kMainBoundsWidth, 24, 45, 40);
        }
    }];
}

-(UITableView *)table
{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0,64, kMainBoundsWidth, kMainBoundsHeight-64) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorColor = kSeparatorLineColor;
        _table.backgroundColor = [UIColor clearColor];
    }
    return _table;
}

//添加更新控件
-(void)addRefresh
{
    [_table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _table.footer.hidden = YES;
}

-(void)setupDatas
{
    _isSearching = NO;
    _DataList = [[NSMutableArray alloc]init];
    [_table reloadData];
}

-(void)cancelBtnClick
{
    [searchField resignFirstResponder];
    searchField.text = @"";
    [self showCancelBtn:NO];
    [self setupDatas];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _isSearching?_DataList.count:(_DataList.count+1);
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
    if(_isSearching){
        [cell fillCellWithObject:_DataList[indexPath.row]];
    }else{
        if(indexPath.row==0){
            [cell fillRecommendCellWithObject:nil];
        }else{
            [cell fillCellWithObject:_DataList[indexPath.row-1]];
        }
    }
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
    if(!_isSearching && indexPath.row == 0){
        NSLog(@"推荐社区");
        JLMyCommunitysViewController *listVC = [JLMyCommunitysViewController viewController];
        listVC.type = RecommendCommunity;
        [self.navigationController pushViewController:listVC animated:YES];
    }else{
        JLMyCommunityModel *model = _DataList[indexPath.row];
        JLPostListViewController *listVC = [[JLPostListViewController alloc]init];
        listVC.communityId = model.communityId;
        listVC.communityName = model.name;
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    [self showCancelBtn:YES];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self showCancelBtn:YES];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"搜索方法");
    [searchField resignFirstResponder];
    if([Helper RemoveStringWhiteSpace:textField].length>0){
        [self searchMethodWithString:[Helper RemoveStringWhiteSpace:textField]];
    }
    return YES;
}

-(void)searchMethodWithString:(NSString *)searchStr
{
    [HDHud showHUDInView:self.view title:@"搜索中"];
    [self loadListDataWithPage:1];
    _isSearching = YES;
    _table.footer.hidden = NO;
    [_table reloadData];
}

//加载更多数据
-(void)loadMoreData
{
    NSInteger page = (_DataList.count%PageSzie)?_DataList.count/PageSzie+1:_DataList.count/PageSzie+2;
    [self loadListDataWithPage:page];
}


-(void)loadListDataWithPage:(NSInteger)page
{
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:[Helper RemoveStringWhiteSpace:searchField],@"keyword",@(page),@"page",@(PageSzie),@"num",nil];
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_SearchCommunity pragma:pragma];
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
    [_table.footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

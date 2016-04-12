//
//  JLAddUsersViewController.m
//  Accompany
//
//  Created by 王园园 on 16/2/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLAddUsersViewController.h"
#import "JLAddFrendListCell.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "RealtimeSearchUtil.h"
#import "NickNameAndHeadImage.h"
@interface JLAddUsersViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,AddFrendListCellDelegate>
{
//    UITextField *searchField;
//    UIButton *cancalBtn;
}
@property(nonatomic,strong)UITableView *table;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;

//@property(nonatomic,strong)NSArray *searchArr;
@property(nonatomic,strong)NSMutableArray *DataList;
@property(nonatomic,strong)NSMutableArray *selectDataList;
//@property BOOL isSearching;

@end

@implementation JLAddUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"添加好友"];
    [self showBackButton:YES];
    [self setTabBarHide:YES];
    [self setupViews];
    [self setupDatas];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"updateNickNameAndPhoto" object:nil];
    
}

-(void)setupViews
{
    [self.RightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.RightBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.RightBtn setTitleColor:kTabBarItemSelectColor forState:UIControlStateNormal];
    
    self.enableKeyboardToolBar = NO;
    [self searchController];
    self.searchBar.frame = CGRectMake(0, 64, kMainBoundsWidth, 44);
    [self.view addSubview:self.searchBar];
    
    [self.view addSubview:self.table];
}

-(void)setupDatas
{
    _DataList = [NSMutableArray array];
    _selectDataList = [[NSMutableArray alloc]init];
    [self loadDataSource];
    
    
}

- (void)loadDataSource
{
    
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList];
    for (EMBuddy *buddy in buddyList) {
        if (![blockList containsObject:buddy.username]) {
            [_DataList addObject:buddy];
        }
    }
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if (loginUsername && loginUsername.length > 0) {
        EMBuddy *loginBuddy = [EMBuddy buddyWithUsername:loginUsername];
        [_DataList addObject:loginBuddy];
    }
    [_table reloadData];
    
    [self updateUserNameAndPhoto];
}

-(void)updateUserNameAndPhoto
{
    [[NickNameAndHeadImage shareInstance] loadUserProfileInBackgroundWithBuddy:self.DataList];
}


-(void)reloadTable
{
     [_table reloadData];
}

//#pragma mark - getter
//
//- (EMSearchBar *)searchBar
//{
//    if (_searchBar == nil) {
//        _searchBar = [[EMSearchBar alloc] init];
//        _searchBar.delegate = self;
//        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
//        [_searchBar setTintColor:kTabBarItemSelectColor];
//        [_searchBar setBackgroundImage:[UIImage imageNamed:@"searchbarBG"]];
//        _searchBar.backgroundColor = kDefaultBackgroundColor;
//        
//        for(id cc in [_searchBar.subviews[0] subviews]){
//            
//            if([cc isKindOfClass:[UIButton class]]){
//                
//                UIButton *btn = (UIButton *)cc;
//                [btn setTitle:@"取消"  forState:UIControlStateNormal];
//                [btn setTitleColor:kTabBarItemSelectColor forState:UIControlStateNormal];
//            }
//            
//            if ([cc isKindOfClass:[UITextField class]]) {
//                UITextField * tf = (UITextField*)cc;
//                tf.backgroundColor = RGBACOLOR(45, 50, 54, 1);
//                tf.layer.cornerRadius = 5;
//                tf.layer.borderWidth = 0.4;
//                tf.layer.borderColor = [UIColor grayColor].CGColor;
//                tf.textColor = [UIColor whiteColor];
//            }
//        }
//    }
//    return _searchBar;
//}
//
//- (EMSearchDisplayController *)searchController
//{
//    if (_searchController == nil) {
//        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
//        _searchController.delegate = self;
//        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _searchController.searchResultsTableView.backgroundColor = kDefaultBackgroundColor;
//        
//        __weak JLAddUsersViewController *weakSelf = self;
//        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
//            JLAddFrendListCell *cell = [tableView dequeueReusableCellWithIdentifier:[JLAddFrendListCell cellIdentifier]];
//            if(!cell){
//                cell = [JLAddFrendListCell loadFromXib];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            NSDictionary *dict = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
//            [cell fillCellWithObject:dict];
//            return cell;
//        }];
//        
//        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
//            return [JLAddFrendListCell rowHeightForObject:nil];
//        }];
//        
//        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
//            [tableView deselectRowAtIndexPath:indexPath animated:YES];
//            
//            
//            [weakSelf.searchController.searchBar endEditing:YES];
//            
//            NSDictionary *dict = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
//            
//        }];
//    }
//    
//    return _searchController;
//}


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
    JLAddFrendListCell *cell = [tableView dequeueReusableCellWithIdentifier:[JLAddFrendListCell cellIdentifier]];
    if(!cell){
        cell = [JLAddFrendListCell loadFromXib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [cell fillCellWithObject:_DataList[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JLAddFrendListCell rowHeightForObject:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

#pragma mark - AddFrendListCellDelegate

-(void)addFrendListCellBtnSelectData:(EMBuddy *)EMBuddyModel WithState:(BOOL)isAdd;
{
    if(isAdd){
        [_selectDataList addObject:EMBuddyModel];
    }else{
        [_selectDataList removeObject:EMBuddyModel];
    }
}

//#pragma mark - UISearchBarDelegate
//
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    [searchBar setShowsCancelButton:YES animated:YES];
//    
//    return YES;
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    __weak typeof(self) weakSelf = self;
//    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:_DataList searchText:(NSString *)searchText collationStringSelector:@selector(showName) resultBlock:^(NSArray *results) {
//        if (results) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.searchController.resultsSource removeAllObjects];
//                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
//                [weakSelf.searchController.searchResultsTableView reloadData];
//            });
//        }
//    }];
//}
//
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
//{
//    return YES;
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    searchBar.text = @"";
//    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
//    [searchBar resignFirstResponder];
//    [searchBar setShowsCancelButton:NO animated:YES];
//}
//
////根据用户昵称进行搜索
//- (NSString*)showName
//{
//    //return [[NickNameAndHeadImage shareInstance]getNicknameByUserName:self.username];
//    return @"";
//}


-(void)sureBtnClick
{
    if(_selectDataList.count==0)
        return;
    NSString *uersId = @"";
    
    for (EMBuddy *model in _selectDataList) {
        NSString *str = model.username;
        if([_selectDataList indexOfObject:model]==0){
            uersId = str;
        }else
        uersId = [uersId stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
    }
    
    [HDHud showHUDInView:self.view title:@"加载中"];
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:_infoModel.communityId,@"communityId",uersId,@"userIds", nil];
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_GetCommunityUsers pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSLog(@"--%@",response);
        
        [HDHud hideHUDInView:self.view];
        [HDHud showMessageInView:self.view title:@"邀请成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(),^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

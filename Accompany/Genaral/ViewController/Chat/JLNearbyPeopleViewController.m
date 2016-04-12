//
//  JLNearbyPeopleViewController.m
//  Accompany
//
//  Created by GongXin on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLNearbyPeopleViewController.h"
#import "JLApplyViewController.h"
#import "JLAddFriendCell.h"
#import "InvitationManager.h"
#import "Config.h"
@interface JLNearbyPeopleViewController ()<UITextFieldDelegate, UIAlertViewDelegate>


@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation JLNearbyPeopleViewController


-(void)viewWillAppear:(BOOL)animated
{
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
    [self setNavTitle:@"附近的人"];
    [self setupDatas];
    [self setupViews];
    [self showBackButton:YES];
   
    _IsScreen = NO;
    
     self.update = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatmenuClick:) name:@"NearbyMenuClick" object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)chatmenuClick:(NSNotification*)notification
{
    id obj = [notification object];
    
    NSString * String = [NSString stringWithFormat:@"%@",obj];
    
    if ([String isEqualToString:@"0"]) {
        self.IsScreen = YES;
        _userSex = @"1";
        [_TableView.header beginRefreshing];
    }else if ([String isEqualToString:@"1"])
    {
        self.IsScreen = YES;
       
        _userSex = @"2";
        
         [_TableView.header beginRefreshing];
        
    }else if ([String isEqualToString:@"2"])
    {
        self.IsScreen = NO;
        [_TableView.header beginRefreshing];
        
    }else if([String isEqualToString:@"3"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    NSLog(@"%@",String);
    [_TableView reloadData];
    
}

//请求数据
-(void)headerRereshing
{
    _page = @"1";
    if (_IsScreen==NO) {
        [self requestDataWithPage:1];
    }else if(_IsScreen==YES)
        
    {
        [self ScreenDataWithPage:1];
    }

    
}

//加载更多数据
-(void)loadMoreData
{
    int page = [_page intValue];
    page ++;
    _page = [NSString stringWithFormat:@"%d",page];
    if (_IsScreen==NO) {
        [self requestDataWithPage:2];
    }else if(_IsScreen==YES)
    {
        [self ScreenDataWithPage:2];
    }
}

//请求数据的方法
-(void)requestDataWithPage:(int)Type
{
    
    userInfo = [UserInfo sharedUserInfo];
    
    NSString * token = userInfo.token;
    
    Config * config = [Config currentConfig];
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page",token,@"token",config.latitude,@"lat",config.longitude,@"lng",  nil];
    
    NSLog(@"%@",postDict);
    
    
    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_searchNearbyUser pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        
        NSLog(@"%@%@",obj,postDict);
        
        _UsersArray = obj;
        _UsersModelArray = [JLPostUserInfoModel mj_objectArrayWithKeyValuesArray:_UsersArray];
        
        if (Type == 1) {
            _UsersListArray = [NSMutableArray arrayWithArray:_UsersModelArray];
            [_TableView.header endRefreshing];
            [_TableView reloadData];
            
        }else if(Type == 2){
            
            NSMutableArray * Array = [[NSMutableArray alloc] init];
            [Array addObjectsFromArray:_UsersListArray];
            [Array addObjectsFromArray:_UsersModelArray];
            _UsersListArray = Array;
            [_TableView.footer endRefreshing];
            [_TableView reloadData];
        }
        
        if ([_UsersListArray count]==0) {
            [HDHud showMessageInView:self.view title:@"暂无数据"];
        }else if([_UsersListArray count]>9)
        {
            [_TableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            [_TableView reloadData];
            
        }

        
    };
    request.failureBlock = ^(id obj){
        
        [HDHud showNetWorkErrorInView:self.view];
    };
    
    
}
-(void)ScreenDataWithPage:(int)Type
{
    
    userInfo = [UserInfo sharedUserInfo];
    
    NSString * token = userInfo.token;
    
    Config * config = [Config currentConfig];
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page",token,@"token",config.latitude,@"lat",config.longitude,@"lng",_userSex,@"sex",nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_searchNearbyUser pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        _UsersArray = obj;
        _UsersModelArray = [JLPostUserInfoModel mj_objectArrayWithKeyValuesArray:_UsersArray];
        
        if (Type == 1) {
            _UsersListArray = [NSMutableArray arrayWithArray:_UsersModelArray];
            [_TableView.header endRefreshing];
            [_TableView reloadData];
            
        }else if(Type == 2){
            
            NSMutableArray * Array = [[NSMutableArray alloc] init];
            [Array addObjectsFromArray:_UsersListArray];
            [Array addObjectsFromArray:_UsersModelArray];
            _UsersListArray = Array;
            [_TableView.footer endRefreshing];
            [_TableView reloadData];
        }
        
        if ([_UsersListArray count]==0) {
            [HDHud showMessageInView:self.view title:@"暂无数据"];
        }else if([_UsersListArray count]>9)
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
    self.RightBtn.frame = CGRectMake(kMainBoundsWidth-64, 20*Proportion, 64, 44);
    [self.RightBtn setBackgroundImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    
    [self.RightBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.TableView];

}
-(void)menuButtonClick:(UIButton*)sender
{
    NSLog(@"");
    [JLNearbyMenuView showOnWindow];
}

-(UITableView*)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 63.9, kMainBoundsWidth, kMainBoundsHeight-63.9) style:UITableViewStyleGrouped];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
        _TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addRefresh];
    }
    
    return _TableView;
}

#pragma mark - getter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_UsersListArray count]>0?[_UsersListArray count]:0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return .1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

{
    return .1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JLPostUserInfoModel * model = _UsersListArray[indexPath.row];
    static NSString * cellID = @"cellID";
    JLOtherAddFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[JLOtherAddFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    
    JLPostUserInfoModel * model = _UsersListArray[indexPath.row];
    
    NSString *buddyName = model.userId;
    
    NSString * nickName = model.nikeName;
    
    if ([self didBuddyExist:buddyName]) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.repeat", @"'%@'has been your friend!"), nickName];
        
        [EMAlertView showAlertWithTitle:message
                                message:nil
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
        
        
        
    }
    else if([self hasSendBuddyRequest:buddyName])
    {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.repeatApply", @"you have send fridend request to '%@'!"), nickName];
        [EMAlertView showAlertWithTitle:message
                                message:nil
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
        
    }else{
        [self showMessageAlertView];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action



- (BOOL)hasSendBuddyRequest:(NSString *)buddyName
{
    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
    for (EMBuddy *buddy in buddyList) {
        if ([buddy.username isEqualToString:buddyName] &&
            buddy.followState == eEMBuddyFollowState_NotFollowed &&
            buddy.isPendingApproval) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)didBuddyExist:(NSString *)buddyName
{
    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
    for (EMBuddy *buddy in buddyList) {
        if ([buddy.username isEqualToString:buddyName] &&
            buddy.followState != eEMBuddyFollowState_NotFollowed) {
            return YES;
        }
    }
    return NO;
}

- (void)showMessageAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"saySomething", @"say somthing")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                                          otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        UITextField *messageTextField = [alertView textFieldAtIndex:0];
        
        NSString *messageStr = @"";
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
        if (messageTextField.text.length > 0) {
            messageStr = [NSString stringWithFormat:@"%@：%@", username, messageTextField.text];
        }
        else{
            messageStr = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyInvite", @"%@ invite you as a friend"), username];
        }
        [self sendFriendApplyAtIndexPath:self.selectedIndexPath
                                 message:messageStr];
    }
}

- (void)sendFriendApplyAtIndexPath:(NSIndexPath *)indexPath
                           message:(NSString *)message
{
 
    JLPostUserInfoModel * model = _UsersListArray[indexPath.row];
    NSString *buddyName = model.userId;
    
    if (buddyName && buddyName.length > 0) {
        [self showHudInView:self.view hint:NSLocalizedString(@"friend.sendApply", @"sending application...")];
        EMError *error;
        [[EaseMob sharedInstance].chatManager addBuddy:buddyName message:message error:&error];
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"friend.sendApplyFail", @"send application fails, please operate again")];
        }
        else{
            [self showHint:NSLocalizedString(@"friend.sendApplySuccess", @"send successfully")];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end

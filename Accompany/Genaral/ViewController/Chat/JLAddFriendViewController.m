//
//  JLAddFriendViewController.m
//  Accompany
//
//  Created by GongXin on 16/2/2.
//  Copyright © 2016年 GX. All rights reserved.
//
#import "JLAddFriendViewController.h"

#import "JLApplyViewController.h"
#import "JLAddFriendCell.h"
#import "InvitationManager.h"
#import "JLPersonalCenterViewController.h"
@interface JLAddFriendViewController ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation JLAddFriendViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataSource = [NSMutableArray array];
    [self setNavTitle:@"添加好友"];
    [self showBackButton:YES];
    [self setupViews];
    

}
-(void)setupViews
{
    [self.RightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.RightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.RightBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.TableView];
    
    //[self.view addSubview:self.textField];
}

-(UITableView*)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainBoundsWidth,kMainBoundsHeight-64) style:UITableViewStyleGrouped];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
        _TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _TableView.tableHeaderView = self.headerView;
        
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
        _TableView.tableFooterView = footerView;
    }
    
    return _TableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[SearchTextField alloc] initWithFrame:CGRectMake(10,6, self.view.frame.size.width - 20, 28)];
        _textField.layer.borderColor = [UIColor grayColor].CGColor;
        _textField.layer.borderWidth = 0.4;
        _textField.layer.cornerRadius = 5;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.backgroundColor = RGBACOLOR(45, 50, 54, 1);
        _textField.placeholder = NSLocalizedString(@"friend.inputNameToSearch", @"input to find friends");
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.tintColor = [UIColor redColor];
        _textField.delegate = self;
        _textField.textColor = [UIColor whiteColor];
    }
    
    return _textField;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 40)];
        _headerView.backgroundColor = kDefaultBackgroundColor;
        
        [_headerView addSubview:self.textField];
    }
    
    return _headerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.UsersListArray count];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark - getter
-(void)postCell:(JLOtherAddFriendCell *)cell userImageTapWithData:(id)celldata;
{
    NSLog(@"%@",celldata);
    
    JLPersonalCenterViewController * pcVc = [JLPersonalCenterViewController viewController];
    pcVc.userModel = (JLPostUserInfoModel *)celldata;
    [self.navigationController pushViewController:pcVc animated:YES];
    
}
-(void)addCell:(JLOtherAddFriendCell *)cell addFriendTapWithData:(id)celldata;
{
    JLPostUserInfoModel * model = (JLPostUserInfoModel*)celldata;
    
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

//- (void)searchAction
//{
//    [_textField resignFirstResponder];
//    if(_textField.text.length > 0)
//    {
//#warning 由用户体系的用户，需要添加方法在已有的用户体系中查询符合填写内容的用户
//#warning 以下代码为测试代码，默认用户体系中有一个符合要求的同名用户
//        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
//        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
//        if ([_textField.text isEqualToString:loginUsername]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notAddSelf", @"can't add yourself as a friend") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//            [alertView show];
//            
//            return;
//        }
//        
//        //判断是否已发来申请
//        NSArray *applyArray = [[JLApplyViewController viewController] dataSource];
//        if (applyArray && [applyArray count] > 0) {
//            for (ApplyEntity *entity in applyArray) {
//                ApplyStyle style = [entity.style intValue];
//                BOOL isGroup = style == ApplyStyleFriend ? NO : YES;
//                if (!isGroup && [entity.applicantUsername isEqualToString:_textField.text]) {
//                    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"friend.repeatInvite", @"%@ have sent the application to you"), _textField.text];
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:str delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//                    [alertView show];
//                    
//                    return;
//                }
//            }
//        }
//        
//        [self.dataSource removeAllObjects];
//        [self.dataSource addObject:_textField.text];
//        [self.TableView reloadData];
//    }
//}

-(void)searchAction
{
    
    
    [_textField resignFirstResponder];
    if(_textField.text.length > 0)
    {

        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if ([_textField.text isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notAddSelf", @"can't add yourself as a friend") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
        
        //判断是否已发来申请
        NSArray *applyArray = [[JLApplyViewController viewController] dataSource];
        if (applyArray && [applyArray count] > 0) {
            for (ApplyEntity *entity in applyArray) {
                ApplyStyle style = [entity.style intValue];
                BOOL isGroup = style == ApplyStyleFriend ? NO : YES;
                if (!isGroup && [entity.applicantUsername isEqualToString:_textField.text]) {
                    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"friend.repeatInvite", @"%@ have sent the application to you"), _textField.text];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:str delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    return;
                }
            }
        }
        
        userInfo = [UserInfo sharedUserInfo];
        NSString * token = userInfo.token;
        NSString * keyword = _textField.text;
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",keyword,@"keyword", nil];
        
        NSLog(@"%@",postDict);
        
        
        HttpRequest * request = [[HttpRequest alloc]init];
        [request RequestDataWithUrl:URL_searchUser pragma:postDict];
        
        
        request.successBlock = ^(id obj){
            
            _UsersArray = obj;
            _UsersModelArray = [JLPostUserInfoModel mj_objectArrayWithKeyValuesArray:_UsersArray];
            
            
            _UsersListArray = [NSMutableArray arrayWithArray:_UsersModelArray];
            [_TableView.header endRefreshing];
            [_TableView reloadData];
            
            
            
        };
        request.failureDataBlock = ^(id error)
        {
            [HDHud hideHUDInView:self.view];
            NSString * message = (NSString *)error;
            [HDHud showMessageInView:self.view title:message];
        };
        
        request.failureBlock = ^(id obj){
            [HDHud hideHUDInView:self.view];
            [HDHud showNetWorkErrorInView:self.view];
        };
        


    }

    
    
    
    
   }


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



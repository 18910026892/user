//
//  JLContactsViewController.m
//  Accompany
//
//  Created by GongXin on 16/2/2.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLContactsViewController.h"
#import "ChatViewController.h"

#import "JLAddFriendViewController.h"
#import "JLApplyViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "RealtimeSearchUtil.h"
#import "UserProfileManager.h"

#import "NickNameAndHeadImage.h"

@implementation EMBuddy (search)

//根据用户昵称进行搜索
- (NSString*)showName
{
    return [[NickNameAndHeadImage shareInstance]getNicknameByUserName:self.username];
}

@end
@interface JLContactsViewController ()<UISearchBarDelegate, UISearchDisplayDelegate,BaseTableCellDelegate,UIActionSheetDelegate,EaseUserCellDelegate>
{
    NSIndexPath *_currentLongPressIndex;
}

@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *contactsSource;

@property (nonatomic) NSInteger unapplyCount;
@property (strong, nonatomic) EMSearchBar *searchBar;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@end
@interface JLContactsViewController ()

@end

@implementation JLContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
    [self setupViews];
    self.showRefreshHeader = YES;
    
    _contactsSource = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];

    
  
    [self searchController];
 
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self.view addSubview:self.searchBar];
    
    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height-113);
    
    
    self.tableView.sectionIndexColor = [UIColor redColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];


    [self reloadDataSource];
    
    [self setTabBarHide:YES];
    [self setNavigationBarHide:YES];
    
    [self updateUserNameAndPhoto];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserNameAndPhoto) name:@"updateUserNameAndPhoto" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"updateNickNameAndPhoto" object:nil];
    
  

    
}

-(void)updateUserNameAndPhoto
{
   [[NickNameAndHeadImage shareInstance] loadUserProfileInBackgroundWithBuddy:self.contactsSource];
}

-(void)reloadTable
{
    [self reloadDataSource];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:NO];
    [self reloadApplyView];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)setupViews
{

    self.view.backgroundColor = kDefaultBackgroundColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (EMSearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        [_searchBar setTintColor:[UIColor redColor]];
        [_searchBar setBackgroundImage:[UIImage imageNamed:@"searchbarBG"]];
        _searchBar.backgroundColor = kDefaultBackgroundColor;
        
        for(id cc in [_searchBar.subviews[0] subviews]){
            
            if([cc isKindOfClass:[UIButton class]]){
                
                UIButton *btn = (UIButton *)cc;
                
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            
            if ([cc isKindOfClass:[UITextField class]]) {
                UITextField * tf = (UITextField*)cc;
                tf.backgroundColor = RGBACOLOR(45, 50, 54, 1);
                tf.layer.cornerRadius = 5;
                tf.layer.borderWidth = 0.4;
                tf.layer.borderColor = [UIColor grayColor].CGColor;
                tf.textColor = [UIColor whiteColor];
            }
            
           
        }

        
        
    
    }
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchController.searchResultsTableView.backgroundColor = kDefaultBackgroundColor;
        
        __weak JLContactsViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor = kDefaultBackgroundColor;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
            
            EMBuddy *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            
            NSString * imageURL = [[NickNameAndHeadImage shareInstance]getUserPhotoByUserName:buddy.username];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
            cell.textLabel.text = [[NickNameAndHeadImage shareInstance]getNicknameByUserName:buddy.username];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.username = [[NickNameAndHeadImage shareInstance]getNicknameByUserName:buddy.username];
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            
              [weakSelf.searchController.searchBar endEditing:YES];
            
            EMBuddy *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];

            if (buddy) {
                
                if(weakSelf.contactsDelegate){
                    [weakSelf.contactsDelegate SearchViewController:weakSelf didSelectRowmodel:buddy];
                }
                
            }
            
            
        }];
    }
    
    return _searchController;
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller NS_DEPRECATED_IOS(3_0,8_0);
{
    
     [self.searchBar removeFromSuperview];
     [self.view addSubview:self.searchBar];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataArray count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    
    return [[self.dataArray objectAtIndex:(section - 1)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
    EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        cell.model = nil;
        if (indexPath.row == 0) {
            NSString *CellIdentifier = @"addFriend";
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.avatarView.image = [UIImage imageNamed:@"notice"];
            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
            cell.avatarView.badge = self.unapplyCount;
            return cell;
        }
      
    }
    else{
        NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section - 1)];
        EaseUserModel *model = [userSection objectAtIndex:indexPath.row];

        
        model.nickname = [[NickNameAndHeadImage shareInstance]getNicknameByUserName:model.buddy.username];
        
        model.avatarURLPath = [[NickNameAndHeadImage shareInstance]getUserPhotoByUserName:model.buddy.username];
        
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.model = model;
        
        
        
    }
    

    
    return cell;
}

#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else{
        return 20;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-1, 0, kMainBoundsWidth+2, 20)];
    label.layer.borderColor = [UIColor whiteColor].CGColor;
    label.layer.borderWidth = 0.5;
    label.backgroundColor = kDefaultBackgroundColor;
    label.textColor = [UIColor whiteColor];
    NSString * sextiontiles = [NSString stringWithFormat:@"   %@",[self.sectionTitles objectAtIndex:(section - 1)]];
    
    [label setText:sextiontiles];
    [contentView addSubview:label];
    return contentView;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
    
            
            if(_contactsDelegate){
                [_contactsDelegate gotoApplyViewController];
                
                [self setTabBarHide:YES];
            }
            
        }
  
    }
    else{
        EaseUserModel *model = [[self.dataArray objectAtIndex:(section - 1)] objectAtIndex:row];
        
        
        if (model) {
            
            if(_contactsDelegate){
                [_contactsDelegate ViewController:self didSelectRowmodel:model];
            }
   
        }

    }
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        if ([model.buddy.username isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notDeleteSelf", @"can't delete self") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
        
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager removeBuddy:model.buddy.username removeFromRemote:YES error:&error];
        if (!error) {
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.buddy.username deleteMessages:YES append2Chat:YES];
            
            [tableView beginUpdates];
            [[self.dataArray objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
            [self.contactsSource removeObject:model.buddy];
            [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView  endUpdates];
        }
        else{
            [self showHint:[NSString stringWithFormat:NSLocalizedString(@"deleteFailed", @"Delete failed:%@"), error.description]];
            [tableView reloadData];
        }
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:(NSString *)searchText collationStringSelector:@selector(showName) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - BaseTableCellDelegate

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row >= 1) {
        // 群组，聊天室
        return;
    }
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    if ([model.buddy.username isEqualToString:loginUsername])
    {
        return;
    }
    
    _currentLongPressIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"friend.block", @"join the blacklist") otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - action

- (void)menuClick:(UIButton*)sender;
{
    JLAddFriendViewController *addController = [JLAddFriendViewController viewController];
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - private data

- (void)_sortDataArray:(NSArray *)buddyList
{
    [self.dataArray removeAllObjects];
    [self.sectionTitles removeAllObjects];
    NSMutableArray *contactsSource = [NSMutableArray array];
    
    //从获取的数据中剔除黑名单中的好友
    NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList];
    for (EMBuddy *buddy in buddyList) {
        if (![blockList containsObject:buddy.username]) {
            [contactsSource addObject:buddy];
        }
    }
    
    //建立索引的核心, 返回27，是a－z和＃
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    NSInteger highSection = [self.sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //按首字母分组
    for (EMBuddy *buddy in contactsSource) {
        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:buddy];
        if (model) {
            model.nickname = [[NickNameAndHeadImage shareInstance]getNicknameByUserName:model.buddy.username];
            
            model.avatarURLPath = [[NickNameAndHeadImage shareInstance]getUserPhotoByUserName:model.buddy.username];
            
            
            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:[[NickNameAndHeadImage shareInstance]getNicknameByUserName:model.buddy.username]];
            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            
            NSMutableArray *array = [sortedArray objectAtIndex:section];
            [array addObject:model];
        }
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EaseUserModel *obj1, EaseUserModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.buddy.username];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.buddy.username];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    //去掉空的section
    for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
        NSArray *array = [sortedArray objectAtIndex:i];
        if ([array count] == 0) {
            [sortedArray removeObjectAtIndex:i];
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }
    
    [self.dataArray addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
}

#pragma mark - EaseUserCellDelegate

- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row >= 1) {
        // 群组，聊天室
        return;
    }
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    if ([model.buddy.username isEqualToString:loginUsername])
    {
        return;
    }
    
    _currentLongPressIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"friend.block", @"join the blacklist") otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex && _currentLongPressIndex) {
        EaseUserModel *model = [[self.dataArray objectAtIndex:(_currentLongPressIndex.section - 1)] objectAtIndex:_currentLongPressIndex.row];
        [self hideHud];
        [self showHudInView:self.view hint:NSLocalizedString(@"wait", @"Pleae wait...")];
        
        __weak typeof(self) weakSelf = self;
        [[EaseMob sharedInstance].chatManager asyncBlockBuddy:model.buddy.username relationship:eRelationshipFrom withCompletion:^(NSString *username, EMError *error){
            typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf hideHud];
            if (!error)
            {
                //由于加入黑名单成功后会刷新黑名单，所以此处不需要再更改好友列表
            }
            else
            {
                [strongSelf showHint:error.description];
            }
        } onQueue:nil];
    }
    _currentLongPressIndex = nil;
}

#pragma mark - data

- (void)tableViewDidTriggerHeaderRefresh
{
    //    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak JLContactsViewController *weakSelf = self;
    [[[EaseMob sharedInstance] chatManager] asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (error == nil) {
                [self.contactsSource removeAllObjects];
                [self.contactsSource addObjectsFromArray:buddyList];
                NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
                NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
                if (loginUsername && loginUsername.length > 0) {
                    EMBuddy *loginBuddy = [EMBuddy buddyWithUsername:loginUsername];
                    [self.contactsSource addObject:loginBuddy];
                }
                
                [weakSelf _sortDataArray:self.contactsSource];
            }
            else{
                [weakSelf showHint:NSLocalizedString(@"loadDataFailed", @"Load data failed.")];
            }
            
            [weakSelf tableViewDidFinishTriggerHeader:YES reload:YES];
        });
    } onQueue:nil];
}

#pragma mark - public

- (void)reloadDataSource
{
    [self.dataArray removeAllObjects];
    [self.contactsSource removeAllObjects];
    
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList];
    for (EMBuddy *buddy in buddyList) {
        if (![blockList containsObject:buddy.username]) {
            [self.contactsSource addObject:buddy];
        }
    }
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if (loginUsername && loginUsername.length > 0) {
        EMBuddy *loginBuddy = [EMBuddy buddyWithUsername:loginUsername];
        [self.contactsSource addObject:loginBuddy];
    }
    
    [self _sortDataArray:self.contactsSource];
    
    
    [self.tableView reloadData];
}

- (void)reloadApplyView
{
    NSInteger count = [[[JLApplyViewController viewController] dataSource] count];
    self.unapplyCount = count;
    [self.tableView reloadData];
    
   
}


#pragma mark - EMChatManagerBuddyDelegate
- (void)didUpdateBlockedList:(NSArray *)blockedList
{
    [self reloadDataSource];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

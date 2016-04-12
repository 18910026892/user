//
//  JLApplyViewController.m
//  Accompany
//
//  Created by GongXin on 16/2/2.
//  Copyright © 2016年 GX. All rights reserved.
//
#import "JLApplyViewController.h"

#import "JLApplyFriendCell.h"
#import "InvitationManager.h"
#import "NickNameAndHeadImage.h"

static JLApplyViewController *controller = nil;

@interface JLApplyViewController ()<ApplyFriendCellDelegate>

@end

@implementation JLApplyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] init];
      
    }
    return self;
}

+ (instancetype)viewController;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] initWithStyle:UITableViewStylePlain];
   
      
    });
    
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.title = NSLocalizedString(@"title.apply", @"Application and notification");
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kDefaultBackgroundColor;
    
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    [self.tableView reloadData];

    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.hidesBackButton = YES;
    
    [self.navigationController.navigationBar addSubview:self.BackButton];
    
    [self loadDataSourceFromLocalDB];
   


}

-(UIButton*)BackButton
{
    if (!_BackButton) {
        _BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _BackButton.frame = CGRectMake(10,0, 64*Proportion, 44);
        _BackButton.imageEdgeInsets = UIEdgeInsetsMake(0,-20, 0, 25);
        [_BackButton setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
        [_BackButton setImage:[UIImage imageNamed:@"BackButtonHighlighted"] forState:UIControlStateHighlighted];
        [_BackButton addTarget:self action:@selector(BackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _BackButton;
}

-(void)BackButtonClick:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserNameAndPhoto" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
    
    [self.BackButton removeFromSuperview];
}
#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSString *)loginUsername
{
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    return [loginInfo objectForKey:kSDKUsername];
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
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ApplyFriendCell";
    JLApplyFriendCell *cell = ( JLApplyFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ JLApplyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(self.dataSource.count > indexPath.row)
    {
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        if (entity) {
            cell.indexPath = indexPath;
            ApplyStyle applyStyle = [entity.style intValue];
            if (applyStyle == ApplyStyleGroupInvitation) {
                cell.titleLabel.text = NSLocalizedString(@"title.groupApply", @"Group Notification");
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            }
            else if (applyStyle == ApplyStyleJoinGroup)
            {
                cell.titleLabel.text = NSLocalizedString(@"title.groupApply", @"Group Notification");
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            }
            else if(applyStyle == ApplyStyleFriend){
              
                cell.titleLabel.text = [[NickNameAndHeadImage shareInstance]getNicknameByUserName:entity.applicantUsername];
            
                
                NSString * imageUrl = [[NickNameAndHeadImage shareInstance]getUserPhotoByUserName:entity.applicantUsername];
                
                UIImage * tianchongImage = [UIImage imageNamed:@"otherphoto"];
                
                [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:tianchongImage];
                
            }
            
            NSString * str = [entity.reason  stringByReplacingOccurrencesOfString:entity.applicantUsername withString:@""];
            

            NSString * String = [str stringByReplacingOccurrencesOfString:@"：" withString:@""];
        
            NSLog(@"%@  %@",String,str);
            
            cell.contentLabel.text = String;
            
            
        }
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    NSString * str = [entity.reason  stringByReplacingOccurrencesOfString:entity.applicantUsername withString:@""];
    NSString * String = [str stringByReplacingOccurrencesOfString:@"：" withString:@""];
    return [JLApplyFriendCell heightWithContent:String];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ApplyFriendCellDelegate

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
        
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        ApplyStyle applyStyle = [entity.style intValue];
        EMError *error;
        
        /*if (applyStyle == ApplyStyleGroupInvitation) {
         [[EaseMob sharedInstance].chatManager acceptInvitationFromGroup:entity.groupId error:&error];
         }
         else */if (applyStyle == ApplyStyleJoinGroup)
         {
             [[EaseMob sharedInstance].chatManager acceptApplyJoinGroup:entity.groupId groupname:entity.groupSubject applicant:entity.applicantUsername error:&error];
         }
         else if(applyStyle == ApplyStyleFriend){
             [[EaseMob sharedInstance].chatManager acceptBuddyRequest:entity.applicantUsername error:&error];
         }
        
        [self hideHud];
        if (!error) {
            [self.dataSource removeObject:entity];
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
            [self.tableView reloadData];
        }
        else{
            [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
        }
    }
}

- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        ApplyStyle applyStyle = [entity.style intValue];
        EMError *error;
        
        if (applyStyle == ApplyStyleGroupInvitation) {
            [[EaseMob sharedInstance].chatManager rejectInvitationForGroup:entity.groupId toInviter:entity.applicantUsername reason:@""];
        }
        else if (applyStyle == ApplyStyleJoinGroup)
        {
            [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:entity.groupId groupname:entity.groupSubject toApplicant:entity.applicantUsername reason:nil];
        }
        else if(applyStyle == ApplyStyleFriend){
            [[EaseMob sharedInstance].chatManager rejectBuddyRequest:entity.applicantUsername reason:@"" error:&error];
        }
        
        [self hideHud];
        if (!error) {
            [self.dataSource removeObject:entity];
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
            
            [self.tableView reloadData];
        }
        else{
            [self showHint:NSLocalizedString(@"rejectFail", @"reject failure")];
        }
    }
}

#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{
    if (dictionary && [dictionary count] > 0) {
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        ApplyStyle style = [[dictionary objectForKey:@"applyStyle"] intValue];
        
        if (applyUsername && applyUsername.length > 0) {
            for (int i = ((int)[_dataSource count] - 1); i >= 0; i--) {
                ApplyEntity *oldEntity = [_dataSource objectAtIndex:i];
                ApplyStyle oldStyle = [oldEntity.style intValue];
                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername]) {
                    if(style != ApplyStyleFriend)
                    {
                        NSString *newGroupid = [dictionary objectForKey:@"groupname"];
                        if (newGroupid || [newGroupid length] > 0 || [newGroupid isEqualToString:oldEntity.groupId]) {
                            break;
                        }
                    }
                    
                    oldEntity.reason = [dictionary objectForKey:@"applyMessage"];
                    [_dataSource removeObject:oldEntity];
                    [_dataSource insertObject:oldEntity atIndex:0];
                    [self.tableView reloadData];
                    
                    return;
                }
            }
            
            //new apply
            ApplyEntity * newEntity= [[ApplyEntity alloc] init];
            newEntity.applicantUsername = [dictionary objectForKey:@"username"];
            newEntity.style = [dictionary objectForKey:@"applyStyle"];
            newEntity.reason = [dictionary objectForKey:@"applyMessage"];
            
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginName = [loginInfo objectForKey:kSDKUsername];
            newEntity.receiverUsername = loginName;
            
            NSString *groupId = [dictionary objectForKey:@"groupId"];
            newEntity.groupId = (groupId && groupId.length > 0) ? groupId : @"";
            
            NSString *groupSubject = [dictionary objectForKey:@"groupname"];
            newEntity.groupSubject = (groupSubject && groupSubject.length > 0) ? groupSubject : @"";
            
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            
            
             [[InvitationManager sharedInstance] removeInvitation:newEntity loginUser:loginUsername];
            
            [[InvitationManager sharedInstance] addInvitation:newEntity loginUser:loginUsername];
            
            [_dataSource insertObject:newEntity atIndex:0];
            [self.tableView reloadData];
            
        }
    }
}

- (void)loadDataSourceFromLocalDB
{
    [_dataSource removeAllObjects];
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginName = [loginInfo objectForKey:kSDKUsername];
    if(loginName && [loginName length] > 0)
    {
        
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        [self.dataSource addObjectsFromArray:applyArray];
        
        [self.tableView reloadData];
    }
    
    
    [[NickNameAndHeadImage shareInstance] loadUserProfileInBackgroundWithApplicant:self.dataSource];


   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"updateNickNameAndPhoto1" object:nil];


}
-(void)reloadTable
{
    [self.tableView reloadData];
}

- (void)clear
{
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
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

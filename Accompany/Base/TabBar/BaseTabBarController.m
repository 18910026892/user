//
//  BaseTabBarController.m
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseTabBarController.h"
#import "JLCommunityViewContrller.h"
#import "JLVideoViewController.h"
#import "JLStadiumViewController.h"
#import "JLMessageListViewController.h"
#import "JLChatViewController.h"
#import "JLMeViewController.h"
#import "JLApplyViewController.h"
#import "ChatViewController.h"
#import "UserProfileManager.h"
#import "JLContactsViewController.h"
#import "LoginViewController.h"
#import "ApplyViewController.h"
static NSInteger num =0;
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";
@interface BaseTabBarController()
{
    UIView *barView;
    SubItem *tempSelectItem;
    JLMessageListViewController * _chatListVC;
    JLChatViewController * _chatAllVc;
    JLMeViewController *_meVC;
    JLContactsViewController * _contactsVC;
}

@property (nonatomic,assign)NSInteger ViewControllerCount;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation BaseTabBarController

static BaseTabBarController* _myTabBarVC = nil;

+(BaseTabBarController*)shareTabBarController{
    @synchronized(self){
        if (!_myTabBarVC) {
            _myTabBarVC = [[BaseTabBarController alloc]init];
        }
    }
    return _myTabBarVC;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissBackTabbar) name:@"dissmissBackTabbar" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOK:) name:@"loginOK" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgoutOK) name:@"lgoutOK" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancleApply:) name:@"cancleApply" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StatisticsNotReadMessageCount) name:@"setupUntreatedApplyCount" object:nil];
    
    [self registerNotifications];
    //自定义的tabBar
    barView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    barView.backgroundColor = kTabBarBackColor;
    barView.userInteractionEnabled = YES;
    self.tabBar.hidden = YES;
    [self.view addSubview:barView];
    
    
    
    [self initContactsVC];
    [self initSubViews];
  
    [self StatisticsNotReadMessageCount];
}

-(void)cancleApply:(NSNotification*)notification
{
     [self setTabBarSelectedIndex:0];
}
//
//-(void)loginOK:(NSNotification*)notification
//{
//    id obj = [notification object];
//    
//    NSInteger select = [obj integerValue];
//    [self setTabBarSelectedIndex:select];
//}
//-(void)dissmissBackTabbar
//{
//    [self setTabBarSelectedIndex:0];
//}
//-(void)lgoutOK
//
//{
//    [self setTabBarSelectedIndex:0];
//}

-(void)initContactsVC
{
  
    _contactsVC = [JLContactsViewController viewController];
    
    
}
#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    
}


-(void)StatisticsNotReadMessageCount
{
    
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount1 = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount1 += conversation.unreadMessagesCount;
    }
    
    
       NSInteger unreadCount2 = [[[JLApplyViewController viewController] dataSource] count];
    
    _UnReadCount = unreadCount1 + unreadCount2;
    
    
    if (_chatAllVc) {
        
        if (_UnReadCount > 0) {
            
            
            UILabel * label = (UILabel*)[self.view viewWithTag:5003];
            label.hidden = NO;
            label.text = [NSString stringWithFormat:@"%ld",(long)_UnReadCount];
            
        }else{
            
            
            UILabel * label = (UILabel*)[self.view viewWithTag:5003];
            label.hidden = YES;
        }
    }

    
}




- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

#pragma mark - IChatManagerDelegate 消息变化


- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self StatisticsNotReadMessageCount];
    
    [_chatAllVc MessageListRefreshDataSource];

}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
   [self StatisticsNotReadMessageCount];
    [_chatAllVc MessageListRefreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages
{
    [self StatisticsNotReadMessageCount];

    
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}
// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateInactive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
#endif
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        else if (message.messageType == eMessageTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName)
            {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}


#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        NSString *hintText = NSLocalizedString(@"reconnection.retry", @"Fail to log in your account, is try again... \nclick 'logout' button to jump to the login page \nclick 'continue to wait for' button for reconnection successful");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"reconnection.wait", @"continue to wait")
                                                  otherButtonTitles:NSLocalizedString(@"logout", @"Logout"),
                                  nil];
        alertView.tag = 99;
        [alertView show];
        [_chatListVC isConnect:NO];
    }
}

#pragma mark - IChatManagerDelegate 好友变化

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        //发送本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), username];
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
    }
#endif
    
    [_chatAllVc ContactsListReloadApplyView];

    
    
}

- (void)_removeBuddies:(NSArray *)userNames
{
    [[EaseMob sharedInstance].chatManager removeConversationsByChatters:userNames deleteMessages:YES append2Chat:YES];
    [_chatListVC refreshDataSource];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    ChatViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[ChatViewController class]] && [userNames containsObject:[(ChatViewController *)viewController conversation].chatter])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    if (chatViewContrller)
    {
        [viewControllers removeObject:chatViewContrller];
        if ([viewControllers count] > 0) {
            [self.navigationController setViewControllers:@[viewControllers[0]] animated:YES];
        } else {
            [self.navigationController setViewControllers:viewControllers animated:YES];
        }
    }
    [self showHint:@"删除成功"];
}

- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd
{
    if (!isAdd)
    {
        NSMutableArray *deletedBuddies = [NSMutableArray array];
        for (EMBuddy *buddy in changedBuddies)
        {
            if ([buddy.username length])
            {
                [deletedBuddies addObject:buddy.username];
            }
        }
        if (![deletedBuddies count])
        {
            return;
        }
        
        [self _removeBuddies:deletedBuddies];
    } else {
        // clear conversation
        NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
        NSMutableArray *deleteConversations = [NSMutableArray arrayWithArray:conversations];
        NSMutableDictionary *buddyDic = [NSMutableDictionary dictionary];
        for (EMBuddy *buddy in buddyList) {
            if ([buddy.username length]) {
                [buddyDic setObject:buddy forKey:buddy.username];
            }
        }
        for (EMConversation *conversation in conversations) {
            if (conversation.conversationType == eConversationTypeChat) {
                if ([buddyDic objectForKey:conversation.chatter]) {
                    [deleteConversations removeObject:conversation];
                }
            } else {
                [deleteConversations removeObject:conversation];
            }
        }
        if ([deleteConversations count] > 0) {
            NSMutableArray *deletedBuddies = [NSMutableArray array];
            //            for (EMConversation *conversation in deleteConversations) {
            //                if (![[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
            //                    [deletedBuddies addObject:conversation.chatter];
            //                }
            //            }
            if ([deletedBuddies count] > 0) {
                [self _removeBuddies:deletedBuddies];
            }
        }
    }
    [_chatAllVc ContactsListRefreshDataSource];
}

- (void)didRemovedByBuddy:(NSString *)username
{
  
    [self _removeBuddies:@[username]];
    [_chatAllVc ContactsListRefreshDataSource];
}

- (void)didAcceptedByBuddy:(NSString *)username
{
   [_chatAllVc ContactsListRefreshDataSource];
}

- (void)didRejectedByBuddy:(NSString *)username
{
    NSString *message = [NSString stringWithFormat:@"您的好友申请被无情的拒绝了"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)didAcceptBuddySucceed:(NSString *)username
{

   [_chatAllVc ContactsListReloadApplyView];
}


-(void)initSubViews
{
    _ViewControllerCount = 5;
    
    JLStadiumViewController *staVC = [JLStadiumViewController viewController];
    [self setupItemWithViewController:staVC ItemData:@{@"title":@"首页",@"imageStr":@"tab1_gray",@"imageStr_s":@"tab1_red"}];
    
    
    JLVideoViewController *vidVC = [JLVideoViewController viewController];
    [self setupItemWithViewController:vidVC ItemData:@{@"title":@"视频",@"imageStr":@"tab2_gray",@"imageStr_s":@"tab2_red"}];
    
    
    JLCommunityViewContrller *comVC = [JLCommunityViewContrller viewController];
    [self setupItemWithViewController:comVC ItemData:@{@"title":@"社区",@"imageStr":@"tab3_gray",@"imageStr_s":@"tab3_red"}];
    
    _chatAllVc =  [JLChatViewController viewController];
    [self setupItemWithViewController:_chatAllVc ItemData:@{@"title":@"聊天",@"imageStr":@"tab4_gray",@"imageStr_s":@"tab4_red"}];
    
    _meVC = [JLMeViewController viewController];
    [self setupItemWithViewController:_meVC ItemData:@{@"title":@"我",@"imageStr":@"tab5_gray",@"imageStr_s":@"tab5_red"}];
    
    
    
}


-(void)setupItemWithViewController:(BaseViewController *)vc ItemData:(NSDictionary *)data
{
    //封装item数据
    Item *item = [[Item alloc]initItemWithDictionary:data];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    //[vc setNavTitle:item.title];
    [self addChildViewController:nav];
    
    
    CGFloat SubItemWidth = barView.frame.size.width/_ViewControllerCount;
    subItem = [[SubItem alloc]initWithFrame:CGRectMake(SubItemWidth*num, 0,SubItemWidth, kTabBarHeight)];
    subItem.item = item;
    subItem.userInteractionEnabled = YES;
    subItem.tag = num;
   
    
    
    _badgeView = [[UILabel alloc] init];
    _badgeView.frame = CGRectMake(SubItemWidth-23*Proportion, 3, 16, 16);
    _badgeView.translatesAutoresizingMaskIntoConstraints = NO;
    _badgeView.textAlignment = NSTextAlignmentCenter;
    _badgeView.textColor = [UIColor whiteColor];
    _badgeView.backgroundColor = [UIColor redColor];
    _badgeView.font = [UIFont systemFontOfSize:9];
    _badgeView.hidden = YES;
    _badgeView.layer.cornerRadius = 8;
    _badgeView.clipsToBounds = YES;
    _badgeView.tag = 5000+num;
    
    [subItem addSubview:_badgeView];
    [barView addSubview:subItem];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SelectSubItemIndex:)];
    [subItem addGestureRecognizer:tap];
    num++;
    
    [self initDefaultItem:0];
}



//默认选中item0
-(void)initDefaultItem:(NSInteger)index
{
    SubItem *subitem  = barView.subviews[index];
    tempSelectItem = subitem;
    [subitem setItemSlected:^{
    }];
}

//点击方法
-(void)SelectSubItemIndex:(UIGestureRecognizer *)gesture
{
    NSInteger selectindex = gesture.view.tag;
    
    if (selectindex==1) {
       
        userInfo = [UserInfo sharedUserInfo];
        
        if([userInfo.userType isEqualToString:@"coach"])
        {
           [self setTabBarSelectedIndex:selectindex];
        }else
        {
            ApplyViewController * applyVc = [[ApplyViewController alloc]init];
            
            UINavigationController *userNav = [[UINavigationController alloc]
                                               initWithRootViewController:applyVc];
            
            [self presentModalViewController:userNav animated:YES];
        }
        
      
    }
    
//    if(!userInfo)
//    {
//        userInfo = [UserInfo sharedUserInfo];
//    }
//    
//    if (userInfo.isLog) {
//        [self setTabBarSelectedIndex:selectindex];
//    }else if (!userInfo.isLog)
//    {
//        if (selectindex==3||selectindex==4) {
//            
//            LoginViewController *loginViewController = [LoginViewController viewController];
//            loginViewController.ISRootPresent = @"is";
//            NSString * string = [NSString stringWithFormat:@"%ld",selectindex];
//            
//            loginViewController.pushFrom = string;
//            
//            UINavigationController *userNav = [[UINavigationController alloc]
//                                               initWithRootViewController:loginViewController];
//            
//            [self presentModalViewController:userNav animated:YES];
    
//
//            
//        }else
//        {
//            [self setTabBarSelectedIndex:selectindex];
//        }
//    }
    
      [self setTabBarSelectedIndex:selectindex];
    
    
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [super presentViewController:modalViewController animated:animated completion:NULL];
    }else{
        [super presentModalViewController:modalViewController animated:animated];
    }
}


-(void)setTabBarSelectedIndex:(NSUInteger)selectedIndex
{
    self.selectedIndex = selectedIndex;
    SubItem *selectSubitem  = (SubItem *)barView.subviews[selectedIndex];
    if(selectedIndex != tempSelectItem.tag){
        [selectSubitem setItemSlected:^{
            [tempSelectItem setItemNomal];
        }];
        tempSelectItem = selectSubitem;
    }
}

-(void)hiddenTabBar:(BOOL)hidden;
{
    [UIView beginAnimations:@"hiddenTabbar" context:nil];
    [UIView setAnimationDuration:0.3];
    if(hidden){
        barView.frame = CGRectMake(0,kMainBoundsHeight ,kMainBoundsWidth,kTabBarHeight);
    }else{
        barView.frame = CGRectMake(0,kMainBoundsHeight-49 ,kMainBoundsWidth, kTabBarHeight);
    }
    [UIView commitAnimations];
}

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[JLChatViewController class]]) {
        _chatAllVc = (JLChatViewController *)self.navigationController.topViewController;
        //        [chatController hideImagePicker];
    }
    else if(_chatAllVc)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setTabBarSelectedIndex:3];
        
    }
    
}
- (EMConversationType)conversationTypeFromMessageType:(EMMessageType)type
{
    EMConversationType conversatinType = eConversationTypeChat;
    switch (type) {
        case eMessageTypeChat:
            conversatinType = eConversationTypeChat;
            break;
        case eMessageTypeGroupChat:
            conversatinType = eConversationTypeGroupChat;
            break;
        case eMessageTypeChatRoom:
            conversatinType = eConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.chatter isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMMessageType messageType = [userInfo[kMessageType] intValue];
                        ChatViewController * chatVC = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        
                        switch (messageType) {
                            case eMessageTypeGroupChat:
                            {
                                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                                for (EMGroup *group in groupArray) {
                                    if ([group.groupId isEqualToString:conversationChatter]) {
                                        chatViewController.title = group.groupSubject;
                                        break;
                                    }
                                }
                            }
                                break;
                            default:
                                chatViewController.title = conversationChatter;
                                break;
                        }
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = (ChatViewController *)obj;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMMessageType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                switch (messageType) {
                    case eMessageTypeGroupChat:
                    {
                        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                        for (EMGroup *group in groupArray) {
                            if ([group.groupId isEqualToString:conversationChatter]) {
                                chatViewController.title = group.groupSubject;
                                break;
                            }
                        }
                    }
                        break;
                    default:
                        chatViewController.title = conversationChatter;
                        break;
                }
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatAllVc)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatAllVc];
    }
}


@end

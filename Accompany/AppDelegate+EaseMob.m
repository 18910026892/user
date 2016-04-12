//
//  AppDelegate+EaseMob.m
//  Accompany
//
//  Created by GongXin on 16/2/2.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "AppDelegate+EaseMob.h"
#import "AppDelegate+Parse.h"
#import "LoginViewController.h"
#import "JLApplyViewController.h"
#import "JLIntrolViewController.h"
#import "BaseTabBarController.h"
#import "Helper+UserDefault.h"
@implementation AppDelegate (EaseMob)

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig
{
    [[EaseSDKHelper shareHelper] easemobApplication:application
                      didFinishLaunchingWithOptions:launchOptions
                                             appkey:@"gongxin#accompany"
                                       apnsCertName:apnsCertName
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    

    
    
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    [self registerEaseMobNotification];
    
    [self loginStateChange:nil];

    
}

#pragma mark - App Delegate

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

#pragma mark - login changed

- (void)loginStateChange:(NSNotification *)notification
{
    NSLog(@"loginStateChange");

    UINavigationController *navigationController = nil;
    
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
 
    
    if (isAutoLogin || loginSuccess) {//登陆成功加载主窗口控制器
        //加载申请通知的数据
        [[JLApplyViewController viewController] loadDataSourceFromLocalDB];
        if (self.BaseTabbarVC == nil) {
            self.BaseTabbarVC = [BaseTabBarController shareTabBarController];
            self.window.rootViewController = self.BaseTabbarVC;
            
        }else{
        
            self.window.rootViewController = self.BaseTabbarVC;
        }
        // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处
      //  [self initParse];
    }
    else{//登陆失败加载登陆页面控制器
        self.BaseTabbarVC = nil;
        
        LoginViewController *loginController = [[LoginViewController alloc] init];
        navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
        [self clearParse];
        
          self.window.rootViewController = navigationController;
    }
    

    
}

#pragma mark - IChatManagerDelegate

#pragma mark - EMChatManagerBuddyDelegate

// 好友申请回调
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username) {
        return;
    }
    
    if (!message) {
        message = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), username];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
    

    [[JLApplyViewController viewController] addNewApply:dic];
    
    if (self.BaseTabbarVC) {
        [self.BaseTabbarVC StatisticsNotReadMessageCount];
    }
    
  

    
}

#pragma mark - EMChatManagerGroupDelegate

// 离开群组回调
//- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
//{
//    NSString *tmpStr = group.groupSubject;
//    NSString *str;
//    if (!tmpStr || tmpStr.length == 0) {
//        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//        for (EMGroup *obj in groupArray) {
//            if ([obj.groupId isEqualToString:group.groupId]) {
//                tmpStr = obj.groupSubject;
//                break;
//            }
//        }
//    }
//    
//    if (reason == eGroupLeaveReason_BeRemoved) {
//        str = [NSString stringWithFormat:NSLocalizedString(@"group.beKicked", @"you have been kicked out from the group of \'%@\'"), tmpStr];
//    }
//    if (str.length > 0) {
//        TTAlertNoTitle(str);
//    }
//}

// 申请加入群组被拒绝回调
//- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId
//                                   groupname:(NSString *)groupname
//                                      reason:(NSString *)reason
//                                       error:(EMError *)error{
//    if (!reason || reason.length == 0) {
//        reason = [NSString stringWithFormat:NSLocalizedString(@"group.beRefusedToJoin", @"be refused to join the group\'%@\'"), groupname];
//    }
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:reason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    [alertView show];
//}

//接收到入群申请
//- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
//                         groupname:(NSString *)groupname
//                     applyUsername:(NSString *)username
//                            reason:(NSString *)reason
//                             error:(EMError *)error
//{
//    if (!groupId || !username) {
//        return;
//    }
//    
//    if (!reason || reason.length == 0) {
//        reason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoin", @"%@ apply to join groups\'%@\'"), username, groupname];
//    }
//    else{
//        reason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoinWithName", @"%@ apply to join groups\'%@\'：%@"), username, groupname, reason];
//    }
//    
//    if (error) {
//        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.sendApplyFail", @"send application failure:%@\nreason：%@"), reason, error.description];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//        [alertView show];
//    }
//    else{
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupname, @"groupId":groupId, @"username":username, @"groupname":groupname, @"applyMessage":reason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
//        [[JLApplyViewController viewController] addNewApply:dic];
//        if (self.BaseTabbarVC) {
//            [self.BaseTabbarVC setupUntreatedApplyCount];
//        }
//    }
//}
//
// 已经同意并且加入群组后的回调
//- (void)didAcceptInvitationFromGroup:(EMGroup *)group
//                               error:(EMError *)error
//{
//    if(error){
//        return;
//    }
//    
//    NSString *groupTag = group.groupSubject;
//    if ([groupTag length] == 0) {
//        groupTag = group.groupId;
//    }
//    
//    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed and joined the group of \'%@\'"), groupTag];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    [alertView show];
//}

#pragma mark - EMChatManagerUtilDelegate

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [self.BaseTabbarVC networkChanged:connectionState];
}

#pragma mark - EMPushManagerDelegateDevice

// 绑定deviceToken回调
- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        //        TTAlertNoTitle(NSLocalizedString(@"apns.failToBindDeviceToken", @"Fail to bind device token"));
    }
}

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
    
}

#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


@end

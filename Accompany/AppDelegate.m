//
//  AppDelegate.m
//  Accompany
//
//  Created by GX on 16/1/18.
//  Copyright © 2016年 GX. All rights reserved.
//
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑             永无BUG
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？
#import "AppDelegate.h"
#import <OpenUDID.h>
#import "IQKeyboardManager.h"
#import "JLIntrolViewController.h"
#import "BaseTabBarController.h"
#import "JLCommunityViewContrller.h"
#import "Helper+UserDefault.h"
#import "AppDelegate+Parse.h"
#import "AppDelegate+EaseMob.h"
#import "AppDelegate+Umeng.h"
#import "AppDelegate+BaiduMap.h"
#import <UMSocial.h>
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
 
    
    _connectionState = eEMConnectionConnected;
    
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
  
    [self parseApplication:application didFinishLaunchingWithOptions:launchOptions];
    

    [self SystemConfiguration];
    [self setKeyboardConfic];
   
    
    //初始化友盟统计
    [self initUmengSocial];
    [self initMobClick];
    
    //初始化百度
    [self initBaiduMap];
    [self inituserInfo];
    
   NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"yonghud";
#else
    apnsCertName = @"yonghup";
#endif
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:@"bjjoinus#coachaccompanying"
                apnsCertName:apnsCertName
                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    

    
    
    //向微信注册wx65d8cec5be724bcb
    [WXApi registerApp:@"wx81081a8c63bf91af" withDescription:@"accompanyUser"];

    
//    if(![Helper boolValueWithKey:KFirstRuning]){
//        JLIntrolViewController *intolVC = [[JLIntrolViewController alloc]init];
//        self.window.rootViewController = intolVC;
//        [Helper saveBoolValue:YES withKey:KFirstRuning];
//    }else{
//        _BaseTabbarVC = [BaseTabBarController shareTabBarController];
//        self.window.rootViewController = _BaseTabbarVC;
//    }
    
    [_window makeKeyAndVisible];
    
    return YES;
}
-(void)inituserInfo
{
    UserInfo * userInfo = [UserInfo sharedUserInfo];

    if (userInfo.token==nil) {
        userInfo.isLog=NO;
        
       
    }else
        
    {
        userInfo.isLog = YES;
        
    }
    
    
    
    
}
// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}
// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}
//配置主题色
-(void)SystemConfiguration
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[UINavigationBar appearance] setTintColor:kNavTintColor];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kNavTitleColor,NSForegroundColorAttributeName,nil]];
}

-(void)setKeyboardConfic
{
    //打开键盘通知
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:50];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (_BaseTabbarVC) {
        [_BaseTabbarVC jumpToChatList];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_BaseTabbarVC) {
        [_BaseTabbarVC didReceiveLocalNotification:notification];
    }
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
                NSString *message = @"";
                switch([[resultDic objectForKey:@"resultStatus"] integerValue])
                {
                    case 9000:message = @"订单支付成功";break;
                    case 8000:message = @"正在处理中";break;
                    case 4000:message = @"订单支付失败";break;
                    case 6001:message = @"用户中途取消";break;
                    case 6002:message = @"网络连接错误";break;
                    default:message = @"未知错误";
                }
                
                UIAlertController *aalert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
                [aalert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
                UIViewController *root = self.window.rootViewController;
                [root presentViewController:aalert animated:YES completion:nil];
                
                NSLog(@"result = %@",resultDic);
            }];
        }else
        {
            
            BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
            
            return  isSuc;
        }
        

    }
    return result;
    
    
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}


// 微信支付成功或者失败回调
-(void)onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end

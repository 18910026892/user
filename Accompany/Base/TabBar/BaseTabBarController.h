//
//  BaseTabBarController.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EaseMob.h>
#import "UserInfo.h"
#import "SubItem.h"
@interface BaseTabBarController : UITabBarController<IChatManagerDelegate>
{
    EMConnectionState _connectionState;
    
    UserInfo * userInfo;
    
    SubItem * subItem;
    
}
@property (strong, nonatomic) UILabel *badgeView;

+(BaseTabBarController*)shareTabBarController;

-(void)setTabBarSelectedIndex:(NSUInteger)selectedIndex;

-(void)hiddenTabBar:(BOOL)hidden;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)setupUntreatedApplyCount;

-(void)StatisticsNotReadMessageCount;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)jumpToChatList;

@property (nonatomic,assign)NSInteger UnReadCount;

@end

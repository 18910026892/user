//
//  JLContactsViewController.h
//  Accompany
//
//  Created by GongXin on 16/2/2.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTextField.h"
@class JLContactsViewController;
@protocol ContactsListVCDelegate <NSObject>

-(void)ViewController:(JLContactsViewController *)contactsVC didSelectRowmodel:(EaseUserModel*)UserModel;

-(void)SearchViewController:(JLContactsViewController *)contactsVC didSelectRowmodel:(EMBuddy *)buddy;


-(void)gotoApplyViewController;

@end
@interface JLContactsViewController :EaseUsersListViewController

@property(nonatomic,strong)id<ContactsListVCDelegate>contactsDelegate;


//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyView;

//群组变化时，更新群组页面
//- (void)reloadGroupView;

//好友个数变化时，重新获取数据
- (void)reloadDataSource;

//添加好友的操作被触发
- (void)addFriendAction;


@end

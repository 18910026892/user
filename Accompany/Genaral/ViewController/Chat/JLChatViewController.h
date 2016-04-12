//
//  JLChatViewController.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "JLChatMenuView.h"

@interface JLChatViewController : BaseViewController

@property (nonatomic,strong)JLChatMenuView * MenuView;
@property (nonatomic,assign) NSInteger headerIndex;

-(void)MessageListRefreshDataSource;

-(void)ContactsListRefreshDataSource;

-(void)ContactsListReloadApplyView;

@end

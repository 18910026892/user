//
//  JLMessageListViewController.h
//  Accompany
//
//  Created by 巩鑫 on 16/1/30.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
@class JLMessageListViewController;
@protocol messageListVCDelegate <NSObject>

-(void)viewcontroller:(JLMessageListViewController *)messageVC didSelectRowData:(id<IConversationModel>)conversationModel;




@end
@interface JLMessageListViewController :EaseConversationListViewController

@property(nonatomic,strong)id<messageListVCDelegate>MessageListdelegate;

- (void)refreshDataSource;
- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;


@end

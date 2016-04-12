//
//  JLSystemMessageViewController.h
//  Accompany
//
//  Created by GongXin on 16/2/19.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageModel.h"
#import "MessageTableViewCell.h"
@class JLSystemMessageViewController;
@protocol SystemMessageVCDelegate <NSObject>

-(void)viewcontroller:(JLSystemMessageViewController*)messageVC didSelectSystemModel:(MessageModel*)messageModel;

@end
@interface JLSystemMessageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UserInfo * userInfo;
}
@property (nonatomic,strong)UITableView * TableView;
@property(nonatomic,strong)id<SystemMessageVCDelegate>delegate;
//是否刷新的标志
@property(nonatomic,assign)BOOL update;
//页面参数
@property (nonatomic,copy)NSString * page;

//解析到的对象字典
@property (nonatomic,strong)NSMutableDictionary * objDict;


@property (nonatomic,strong)NSMutableArray * MessageArray;


//数据模型数组
@property (nonatomic,strong)NSArray * MessageModelArray;

//消息数组
@property (nonatomic,strong)NSMutableArray * MessageListArray;
@end

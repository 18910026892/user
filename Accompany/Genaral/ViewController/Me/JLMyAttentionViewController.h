//
//  JLMyAttentionViewController.h
//  Accompany
//
//  Created by GongXin on 16/2/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "JLPostUserInfoModel.h"
#import "JLAttentionCell.h"
@interface JLMyAttentionViewController : BaseViewController
<UITableViewDataSource,UITableViewDelegate>

{
    UserInfo * userInfo;
}
@property (nonatomic,strong)UITableView * TableView;

//是否刷新的标志
@property(nonatomic,assign)BOOL update;

//页面参数
@property (nonatomic,copy)NSString * page;

@property (nonatomic,strong)NSMutableArray * AttentionsArray;
@property (nonatomic,strong)NSMutableArray * AttentionsModelArray;
@property (nonatomic,strong)NSMutableArray * AttentionsListArray;
@end

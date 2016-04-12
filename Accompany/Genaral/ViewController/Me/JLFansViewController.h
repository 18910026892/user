//
//  JLFansViewController.h
//  Accompany
//
//  Created by GongXin on 16/2/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "JLPostUserInfoModel.h"
#import "JLFansCell.h"
@interface JLFansViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

{
    UserInfo * userInfo;
}
@property (nonatomic,strong)UITableView * TableView;

//是否刷新的标志
@property(nonatomic,assign)BOOL update;

//页面参数
@property (nonatomic,copy)NSString * page;

@property (nonatomic,strong)NSMutableArray * FansArray;
@property (nonatomic,strong)NSMutableArray * FansModelArray;
@property (nonatomic,strong)NSMutableArray * FansListArray;

@property (nonatomic,strong)NSString * UserID;

@end

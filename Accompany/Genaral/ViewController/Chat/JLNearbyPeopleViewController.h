//
//  JLNearbyPeopleViewController.h
//  Accompany
//
//  Created by GongXin on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "JLNearbyMenuView.h"
#import "JLPostUserInfoModel.h"
#import "JLOtherAddFriendCell.h"
@interface JLNearbyPeopleViewController :BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UserInfo * userInfo;
}
@property(nonatomic,strong)UITableView * TableView;


//是否刷新的标志
@property(nonatomic,assign)BOOL update;

//页面参数
@property (nonatomic,copy)NSString * page;

@property (nonatomic,strong)NSMutableArray * UsersArray;
@property (nonatomic,strong)NSMutableArray * UsersModelArray;
@property (nonatomic,strong)NSMutableArray * UsersListArray;

@property (nonatomic,copy)NSString * userSex;
//是否筛选
@property BOOL IsScreen;


@end

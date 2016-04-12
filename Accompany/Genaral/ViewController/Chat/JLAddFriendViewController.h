//
//  JLAddFriendViewController.h
//  Accompany
//
//  Created by GongXin on 16/2/2.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTextField.h"
#import "JLOtherAddFriendCell.h"
#import "JLPostUserInfoModel.h"
@interface JLAddFriendViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UserInfo * userInfo;
}

@property(nonatomic,strong)UITableView * TableView;

@property (nonatomic,strong)NSMutableArray * UsersArray;
@property (nonatomic,strong)NSMutableArray * UsersModelArray;
@property (nonatomic,strong)NSMutableArray * UsersListArray;

@end

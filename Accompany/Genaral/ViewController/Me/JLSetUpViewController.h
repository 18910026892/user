//
//  JLSetUpViewController.h
//  Accompany
//
//  Created by GongXin on 16/1/26.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"

@interface JLSetUpViewController : BaseViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UserInfo * userInfo;
}
@property (nonatomic,strong)UITableView * TableView;

@property (nonatomic,strong)UILabel * sectionTitle;

@property (nonatomic,strong)UILabel * cellTitle;

@property(nonatomic,strong)UILabel * UPcellLine;

@property(nonatomic,strong)UILabel * DowncellLine;


@property (nonatomic,strong)UISwitch * Switch;

@property (nonatomic,strong)UIButton * LogoutButton;

@property (nonatomic,strong)UIView * FooterView;

//DATA
@property(nonatomic,strong)NSArray * cellTitleArray;

@property BOOL setUpChange;

@property (nonatomic,strong)NSMutableArray * setUpArray;

@property (nonatomic,copy)NSString * reply;
@property (nonatomic,copy)NSString * praise;
@property (nonatomic,copy)NSString * privateChat;
@property (nonatomic,copy)NSString * NewFans;
@property (nonatomic,copy)NSString * systemMessage;




@end

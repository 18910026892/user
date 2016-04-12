//
//  JLSearchCoachResultViewController.h
//  Accompany
//
//  Created by GongXin on 16/2/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "CoachListTableViewCell.h"
#import "CocahModel.h"
@interface JLSearchCoachResultViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * TableView;

//是否刷新的标志
@property(nonatomic,assign)BOOL update;
//页面参数
@property (nonatomic,copy)NSString * page;
@property (nonatomic,copy)NSString * keyword;

@property (nonatomic,strong)NSMutableArray * coachArray;
@property (nonatomic,strong)NSMutableArray * coachModelArray;
@property (nonatomic,strong)NSMutableArray * coachListArray;
@end

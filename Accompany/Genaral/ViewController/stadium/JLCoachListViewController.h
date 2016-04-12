//
//  JLCoachListViewController.h
//  Accompany
//
//  Created by 巩鑫 on 16/2/6.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import <DZNSegmentedControl.h>
#import "CoachListTableViewCell.h"
#import "CocahModel.h"
@interface JLCoachListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,DZNSegmentedControlDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
//搜索按钮
@property (nonatomic,strong)UIButton * SearchBarButton;

@property(nonatomic,strong)UILabel * lineLabel1,*lineLabel2;

@property(nonatomic,strong)UIButton * MenuButton;

@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, strong) NSArray *menuItems;

@property (nonatomic,strong)UITableView * TableView;
//是否刷新的标志
@property(nonatomic,assign)BOOL update;

//页面参数
@property (nonatomic,copy)NSString * page;
@property (nonatomic,strong)NSMutableArray * coachArray;
@property (nonatomic,strong)NSMutableArray * coachModelArray;
@property (nonatomic,strong)NSMutableArray * coachListArray;


@property (nonatomic,copy)NSString * coachType;




//筛选按钮的相关
@property(nonatomic, unsafe_unretained) BOOL isHidden;
@property (nonatomic,strong) UIView        *screenView;
@property (nonatomic,strong) UIPickerView  *pickerView;
@property (nonatomic,strong) UIToolbar     *aboveViewToolBar;
@property (nonatomic,strong)NSArray * areaArray;
@property (nonatomic,strong)NSArray * sexArray;

@property (nonatomic,copy)NSString * area;
@property (nonatomic,copy)NSString * userSex;

//是否筛选
@property BOOL IsScreen;

@end

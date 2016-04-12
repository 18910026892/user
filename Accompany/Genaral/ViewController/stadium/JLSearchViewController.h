//
//  JLSearchViewController.h
//  Accompany
//
//  Created by 巩鑫 on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "ChooseSearchTypeView.h"
#import "SearchTextField.h"
@interface JLSearchViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

//是否能添加的标志
@property BOOL CanAddRecord;

@property(nonatomic,strong)NSMutableArray * oldSearchArray;

//场馆搜索记录数组
@property (nonatomic,strong)NSMutableArray * VenueSearchArray;

//教练搜索记录数组
@property (nonatomic,strong)NSMutableArray * CoachSearchArray;


//搜索历史记录数组
@property (nonatomic,strong)NSMutableArray * searchRecordArray;


@property(nonatomic,strong)UITableView * TableView;
@property(nonatomic,strong)UIButton * cleanRecordButton;
@property(nonatomic,strong)UIView * FooterView;

//图片视图
@property (nonatomic,strong)UIView * SearchBarView;

//选择搜索类型按钮
@property (nonatomic,strong)UIButton * SearchTypeButton;

//搜索框
@property (nonatomic,strong)SearchTextField * SearchBar;

//取消
@property (nonatomic,strong)UIButton * CancleButton;

//搜索类型参数
@property (nonatomic,copy)NSString * searchType;



@end

//
//  JLLessonsViewController.h
//  Accompany
//
//  Created by GongXin on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "JLInputCell.h"
@interface JLLessonsViewController : BaseViewController
<UITableViewDataSource,UITableViewDelegate,inputCellDelegate>

{
    UserInfo * userInfo;
}

@property(nonatomic,strong)UITableView * TableView;

@property (nonatomic,strong)UILabel * cellTitle;

@property(nonatomic,strong)UILabel * UPcellLine;

@property(nonatomic,strong)UILabel * DowncellLine;

@property (nonatomic,strong)UILabel * cellContent;

//DATA
@property(nonatomic,strong)NSArray * cellTitleArray;

@property (nonatomic,copy)NSString * price;

@property (nonatomic,copy)NSString * showMoney;

@property (nonatomic,copy)NSString * lessonCount;

@end

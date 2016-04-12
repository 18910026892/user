//
//  JLExchangeVoucherViewController.h
//  Accompany
//
//  Created by 巩鑫 on 16/2/20.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "JLExchangeModel.h"
#import "JLExchangeVoucherCell.h"
#import "CocahModel.h"
@interface JLExchangeVoucherViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UserInfo * userInfo;
}

@property(nonatomic,strong)CocahModel * CoachModel;
@property(nonatomic,strong)JLExchangeModel * ExchangeModel;

@property(nonatomic,strong)UITableView * TableView;

@property(nonatomic,strong)JLExchangeVoucherCell * ExchangeCell;



//是否刷新的标志
@property(nonatomic,assign)BOOL update;

//页面参数
@property (nonatomic,copy)NSString * page;

@property (nonatomic,strong)NSMutableArray * ExchangeArray;
@property (nonatomic,strong)NSMutableArray * ExchangeModelArray;
@property (nonatomic,strong)NSMutableArray * ExchangeListArray;


@end

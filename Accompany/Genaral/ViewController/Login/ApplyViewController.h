//
//  ApplyViewController.h
//  Accompany
//
//  Created by GX on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UserInfo * userInfo;
}
@property(nonatomic,strong)UIButton * BackButton;

@property(nonatomic,strong)UITableView * TableView;

@property(nonatomic,strong)UILabel * UPcellLine;

@property(nonatomic,strong)UILabel * DowncellLine;

@property(nonatomic,strong)UIButton * applyButton;

@property (nonatomic,copy)NSMutableDictionary * UserDict;
@end

//
//  JLChangePhoneViewController.h
//  Accompany
//
//  Created by 巩鑫 on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"

@interface JLChangePhoneViewController : BaseViewController
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UserInfo * userInfo;
}
@property(nonatomic,strong)UITableView * TableView;


@property (nonatomic,strong)UIButton * SubmitButton;

@property (nonatomic,strong)UIView * FooterView;

@property (nonatomic,strong)UILabel * cellTitle;

@property (nonatomic,strong)CustomTextField * cellTextField;

@property(nonatomic,strong)UILabel * UPcellLine;

@property(nonatomic,strong)UILabel * DowncellLine;

@property(nonatomic,strong)UIButton * sendButton;
//DATA
@property(nonatomic,strong)NSArray * cellTitleArray;
@property (nonatomic,copy)NSString * OldPassWord;
@property (nonatomic,copy)NSString * OldPhoneNumber;
@property (nonatomic,copy)NSString * NewPhoneNumber;
@property (nonatomic,copy)NSString * CodeNumber;

@property (nonatomic,copy)NSMutableDictionary * UserDict;

@end

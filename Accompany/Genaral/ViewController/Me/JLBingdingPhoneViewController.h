//
//  JLBingdingPhoneViewController.h
//  Accompany
//
//  Created by GongXin on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"

@interface JLBingdingPhoneViewController : BaseViewController
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
@property (nonatomic,copy)NSString * PhoneNumber;
@property (nonatomic,copy)NSString * CodeNumber;
@property (nonatomic,copy)NSMutableDictionary * UserDict;
@end

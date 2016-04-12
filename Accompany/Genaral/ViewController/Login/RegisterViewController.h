//
//  RegisterViewController.h
//  Accompany
//
//  Created by GX on 16/1/20.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUnderlinedButton.h"

@interface RegisterViewController : BaseViewController
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UserInfo * userInfo;
}

@property(nonatomic,strong)UITableView * TableView;

@property(nonatomic,strong)UIButton * sendButton;

@property(nonatomic,strong)UIButton * registerButton;

@property(nonatomic,strong)UILabel * agreeLabel;

@property(nonatomic,strong)UIUnderlinedButton * AgreeButton;

@property(nonatomic,strong)CustomTextField * cellTF;

@property(nonatomic,strong)UILabel * UPcellLine;

@property(nonatomic,strong)UILabel * DowncellLine;

//data

@property (nonatomic,copy)NSString * PhoneNumber;

@property (nonatomic,copy)NSString * sendCode;

@property (nonatomic,copy)NSString * passWord;

@property (nonatomic,copy)NSString * AgainPassWord;

@property (nonatomic,copy)NSMutableDictionary * UserDict;

@end

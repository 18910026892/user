//
//  JLTakeMoneyViewController.m
//  Accompany
//
//  Created by 王园园 on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLTakeMoneyViewController.h"
#import "JLInputCell.h"

@interface JLTakeMoneyViewController ()<UITableViewDataSource,UITableViewDelegate,inputCellDelegate>
{
    NSArray *titleList;
    NSArray *_DataList;
    NSString *inputMoney;
    NSString *AccountBalance;
}

@property(nonatomic,strong)UITableView *table;

@end


@implementation JLTakeMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"提现"];
    [self setTabBarHide:YES];
    [self showBackButton:YES];
    [self setupViews];
    [self setupDatas];
}

-(void)setupViews
{
    self.enableIQKeyboardManager = YES;
    self.enableKeyboardToolBar = YES;
    [self.view addSubview:self.table];
    [self seTableFooterView];
}

-(void)setupDatas
{
    titleList = @[@"银行卡号",@"最多提现"];
    
  //   [UserDefaultsUtils saveValue:cardNo forKey:@"cardNo"]
    
    NSString * cardNo = [UserDefaultsUtils valueWithKey:@"cardNo"];
    AccountBalance =[NSString stringWithFormat:@"%@元",[UserDefaultsUtils valueWithKey:@"AccountBalance"]];
    
    if (cardNo==nil||AccountBalance==nil) {
        NSLog(@"有问题");
    }else
    {
        _DataList = @[cardNo,AccountBalance];
    }
    
}

-(UITableView *)table
{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsWidth, kMainBoundsHeight-64) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorColor = kSeparatorLineColor;
        _table.backgroundColor = [UIColor clearColor];
    }
    return _table;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(indexPath.section<2){
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        cell.textLabel.text = titleList[indexPath.section];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.text = _DataList[indexPath.section];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
    }else{
        JLInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[JLInputCell cellIdentifier]];
        if(!cell){
            cell = [JLInputCell loadFromXib];
            cell.delegate = self;
            cell.tag = indexPath.section;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.inputtextfieldType = inputTextFieldRight;
        cell.keyboardType = UIKeyboardTypeNumberPad;
        [cell fillCellWithTitle:@"金额" InputText:inputMoney placeHolder:@"请输入提现金额"];
        return cell;
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(void)seTableFooterView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 100)];
    UIButton *btn = [UIButton buttonWithFrame:CGRectMake(30, 50, kMainBoundsWidth-60, 40) title:@"提现" titleColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:14.0] backgroundColor:kSliderRedColor];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 20;
    [btn addTarget:self action:@selector(takeMoneyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    _table.tableFooterView = view;
}

-(void)takeMoneyBtnClick
{
   
   
    int m1 = [AccountBalance intValue];
    int m2 = [inputMoney intValue];
    
    if (m2>m1) {
        [HDHud showMessageInView:self.view title:@"体现金额超过了余额"];
    }else
    {
         NSLog(@"%@",inputMoney);
        userInfo = [UserInfo sharedUserInfo];
        
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.token,@"token",inputMoney,@"money",nil];
        
        
        HttpRequest * request = [[HttpRequest alloc]init];
        [request RequestDataWithUrl:URL_bindingBank pragma:postDict];
        
        request.successBlock = ^(id obj){
            
            NSLog(@"%@***%@",postDict,obj);
            
            [HDHud showMessageInView:self.view title:@"提现成功"];

            
        };
        request.failureDataBlock = ^(id error)
        {
            [HDHud hideHUDInView:self.view];
            NSString * message = (NSString *)error;
            [HDHud showMessageInView:self.view title:message];
        };
        
        request.failureBlock = ^(id obj){
            
            [HDHud showNetWorkErrorInView:self.view];
        };
        

    }
    
    
}

#pragma mark-
#pragma mark - inputCellDelegate
- (BOOL)inputCell:(JLInputCell *)cell TextFieldShouldBeginEditing:(UITextField *)textField;
{
 
    return YES;
}
- (BOOL)inputCell:(JLInputCell *)cell TextFieldShouldEndEditing:(UITextField *)textField;
{
    
    if([textField.text rangeOfString:@"元"].location !=NSNotFound)//_roaldSearchText
    {
        NSLog(@"yes");
        
        inputMoney =  [textField.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
    }
    else
    {
        NSLog(@"no");
        
        if ([textField.text isEqualToString:@""]) {
            return YES;
        }else
        {
            textField.text = [NSString stringWithFormat:@"%@元",textField.text];
            
            inputMoney =  [textField.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
        }
        
        
        
        
    }
   
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

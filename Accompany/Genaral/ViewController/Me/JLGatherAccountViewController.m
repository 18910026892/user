//
//  JLGatherAccountViewController.m
//  Accompany
//
//  Created by 王园园 on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLGatherAccountViewController.h"
#import "JLInputCell.h"
#import "JLArowInputCell.h"
#import "JLReceiveAccountModel.h"
#import "JLCustomPickerView.h"

@interface JLGatherAccountViewController ()<UITableViewDataSource,UITableViewDelegate,inputCellDelegate,CustomPickerViewDelegate>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *DataList;
@property(nonatomic,strong)NSArray *toastInfoList;
@property(nonatomic,assign)BOOL isFinish;
@property(nonatomic,strong)JLReceiveAccountModel *accountModel;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)JLCustomPickerView *pickerView;
@end

@implementation JLGatherAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"收款账户"];
    [self setTabBarHide:YES];
    [self showBackButton:YES];
    // Do any additional setup after loading the view.
    
    [self setupDatas];
    [self setupViews];
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
    _accountModel = [[JLReceiveAccountModel alloc]init];

    NSString * cardNO = [UserDefaultsUtils valueWithKey:@"cardNo"];
    NSString *openAccountBank = [UserDefaultsUtils valueWithKey:@"openAccountBank"];
    NSString *openAccountCity = [UserDefaultsUtils valueWithKey:@"openAccountCity"];
    NSString *openAccountName = [UserDefaultsUtils valueWithKey:@"openAccountName"];
    
    
    if (openAccountName) {
        _accountModel.name = openAccountName;
    }
    
    if (cardNO) {
        _accountModel.cardNum= cardNO;
    }
    
    if (openAccountCity) {
        _accountModel.cityName = openAccountCity;
    }
    
    if (openAccountBank) {
        _accountModel.bankName = openAccountBank;
    }
    
    
    _DataList = @[@"收款人",@"银行卡号",@"开户银行",@"开户省市"];
    
    
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
    return _DataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    JLInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[JLInputCell cellIdentifier]];
    if(indexPath.section<3){
        if(!cell){
            cell = [JLInputCell loadFromXib];
            cell.delegate = self;
            cell.tag = indexPath.section;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.section==0){
            [cell fillCellWithTitle:@"收款人" InputText:_accountModel.name placeHolder:@"  请输入姓名"];
        }else if(indexPath.section==1){
            cell.inputtextfieldType = inputTextFieldLeft;
            [cell fillCellWithTitle:@"银行卡号" InputText:_accountModel.cardNum placeHolder:@"请输入储蓄卡号"];
        }else{
            [cell fillCellWithTitle:@"开户银行" InputText:_accountModel.bankName placeHolder:@"请输入开户银行"];
        }
    }else{
        JLArowInputCell *arowCell = [tableView dequeueReusableCellWithIdentifier:[JLArowInputCell cellIdentifier]];
        if(!arowCell){
            arowCell = [JLArowInputCell loadFromXib];
            arowCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        arowCell.title = _DataList[indexPath.section];
        
        
        if(_accountModel && ![Helper isBlankString:_accountModel.cityName]){
            [arowCell fillCellWithString:_accountModel.cityName WithColor:[UIColor whiteColor]];
        }else{
            [arowCell fillCellWithString:@"请选择省市" WithColor:[UIColor grayColor]];
        }
        return arowCell;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 35;
    }else
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 35)];
    UILabel *label = [UILabel labelWithFrame:CGRectMake(10, 5, 100, 30) text:@"设置银行卡信息" textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:14.0] backgroundColor:[UIColor clearColor]];
    [view addSubview:label];
    if(section==0){
        return view;
    }
    else return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section<2)
    {
        return;
    }
    _pickerView = [[JLCustomPickerView alloc]init];
    _pickerView.delegate = self;
    _pickerView.tag = indexPath.section;
    if(indexPath.section==2){
        [_pickerView loadData:[NSMutableArray arrayWithArray:@[@{@"name":@"中国银行",@"id":@"1"},@{@"name":@"农业银行",@"id":@"2"},@{@"name":@"工商银行",@"id":@"3"}]]];
    }else if (indexPath.section==3){
        [_pickerView loadData:[NSMutableArray arrayWithArray:@[@{@"name":@"北京",@"id":@"1"},@{@"name":@"上海",@"id":@"2"},@{@"name":@"广州",@"id":@"3"},@{@"name":@"深圳",@"id":@"4"},@{@"name":@"天津",@"id":@"5"},@{@"name":@"杭州",@"id":@"6"},@{@"name":@"苏州",@"id":@"7"}]]];
    }
    [_pickerView showInView:self.view];
}



-(void)judgeInfoFinish
{
    if(![Helper isBlankString:_accountModel.name] && ![Helper isBlankString:_accountModel.cardNum] && ![Helper isBlankString:_accountModel.bankName] && ![Helper isBlankString:_accountModel.cityName]){
        _isFinish = YES;
    }else{
        _isFinish = NO;
    }
    [_table reloadData];
    [self seTableFooterView];
}

-(void)seTableFooterView
{
    if(!_sureBtn){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 100)];
        UIButton *btn = [UIButton buttonWithFrame:CGRectMake(30, 50, kMainBoundsWidth-60, 40) title:@"保存" titleColor:RGBACOLOR(87.0, 88.0, 89.0, 1) font:[UIFont boldSystemFontOfSize:14.0] backgroundColor:RGBACOLOR(75.0, 75.0, 77.0, 1)];
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 20;
        [btn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        _sureBtn = btn;
        _table.tableFooterView = view;
    }
    
    if(_isFinish){
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.backgroundColor = kSliderRedColor;
        _sureBtn.userInteractionEnabled = YES;
    }else{
        [_sureBtn setTitleColor:RGBACOLOR(87.0, 88.0, 89.0, 1) forState:UIControlStateNormal];
        _sureBtn.backgroundColor = RGBACOLOR(75.0, 75.0, 77.0, 1);
        _sureBtn.userInteractionEnabled = NO;
    }
}

-(void)sureBtnClick
{
    NSLog(@"信息有效－－保存");
    
    userInfo = [UserInfo sharedUserInfo];
    
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userId,@"userId",userInfo.token,@"token",_accountModel.name, @"payee",_accountModel.cardNum,@"cardNumber",_accountModel.bankName, @"bankName",_accountModel.cityName,@"bankArea",nil];
    

    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_bindingBank pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        NSLog(@"%@***%@",postDict,obj);
        
       [HDHud showMessageInView:self.view title:@"绑定成功"];
        

        
        NSDictionary * resultDict = obj[0];
        
        NSString * cardNo = [resultDict valueForKey:@"cardNo"];
        NSString * openAccountBank = [resultDict valueForKey:@"openAccountBank"];
        
        NSString * openAccountCity = [resultDict valueForKey:@"openAccountCity"];
        NSString * openAccountName = [resultDict valueForKey:@"openAccountName"];
        
        [UserDefaultsUtils saveValue:cardNo forKey:@"cardNo"];
        [UserDefaultsUtils saveValue:openAccountBank forKey:@"openAccountBank"];
        [UserDefaultsUtils saveValue:openAccountCity forKey:@"openAccountCity"];
        [UserDefaultsUtils saveValue:openAccountName forKey:@"openAccountName"];
        
        
        [UserDefaultsUtils saveValue:@"Accountinformation" forKey:@"Accountinformation"];
        
       
        
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




#pragma mark - inputCellDelegate
- (BOOL)inputCell:(JLInputCell *)cell TextFieldShouldBeginEditing:(UITextField *)textField;
{
    return YES;
}
- (BOOL)inputCell:(JLInputCell *)cell TextFieldShouldEndEditing:(UITextField *)textField;
{
    if(cell.tag==1){
        _accountModel.cardNum = textField.text;
    }else if(cell.tag==0){
        _accountModel.name = textField.text;
    }else{
        _accountModel.bankName = textField.text;
    }
    [self judgeInfoFinish];
    return YES;
}

#pragma mark - CustomPickerViewDelegate

- (void)PickerView:(JLCustomPickerView*)view didSelectMenuPickerData:(id)selectData ;
{
    NSDictionary *selectDict = (NSDictionary *)selectData;
    
    _accountModel.cityName = selectDict[@"name"];
    _accountModel.cityId = selectDict[@"id"];
    
    [self judgeInfoFinish];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  JLLessonsViewController.m
//  Accompany
//
//  Created by GongXin on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLLessonsViewController.h"
#import "JLCourseOrdersViewController.h"

@interface JLLessonsViewController ()
{
     NSString *inputMoney;
}
@end

@implementation JLLessonsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTabBarHide:YES];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"我的课程"];
    [self setupDatas];
    [self setupViews];
  
    [self getInputMoney];
    [self showBackButton:YES];
    self.enableIQKeyboardManager = YES;
    
}
-(void)setupDatas
{
    _cellTitleArray = @[@"课程订单数",@"课程价格"];
}
-(void)setupViews
{

    [self.view addSubview:self.TableView];
    [self setTableFooterView];
    
}

-(UITableView*)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainBoundsWidth, kMainBoundsHeight-64) style:UITableViewStyleGrouped];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
        
        _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _TableView;
}
#pragma TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [_cellTitleArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    
    UITableViewCell * cell;
    if(indexPath.section==0){

    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 120, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor whiteColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
        _cellTitle.text = [_cellTitleArray objectAtIndex:indexPath.section];
        [cell.contentView addSubview:_cellTitle];
        
    
        _UPcellLine = [[UILabel alloc]init];
        
        _UPcellLine.frame = CGRectMake(0,0,kMainBoundsWidth, .5);
        _UPcellLine.backgroundColor = kSeparatorLineColor;
        [cell.contentView addSubview:_UPcellLine];
        
        
        _DowncellLine = [[UILabel alloc]init];
        
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = kSeparatorLineColor;
        [cell.contentView addSubview:_DowncellLine];
        
        _cellContent = [[UILabel alloc]initWithFrame:CGRectMake(kMainBoundsWidth/2, 12, 145, 20)];
        _cellContent.backgroundColor = [UIColor clearColor];
        _cellContent.textColor = [UIColor whiteColor];
        _cellContent.textAlignment = NSTextAlignmentRight;
        _cellContent.font = [UIFont systemFontOfSize:14];
        _cellContent.text = _lessonCount;
        [cell.contentView addSubview:_cellContent];
        
    }
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
        [cell fillCellWithTitle:@"课程价格" InputText:inputMoney placeHolder:@"请设置您的课程价格"];
        
        _UPcellLine = [[UILabel alloc]init];
        
        _UPcellLine.frame = CGRectMake(0,0,kMainBoundsWidth, .5);
        _UPcellLine.backgroundColor = kSeparatorLineColor;
        [cell.contentView addSubview:_UPcellLine];
        
        
        _DowncellLine = [[UILabel alloc]init];
        
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = kSeparatorLineColor;
        [cell.contentView addSubview:_DowncellLine];
        
        return cell;
    }
    
  
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

{
    if (indexPath.section==0) {
        NSLog(@"1");
//        [self.navigationController pushViewController:[JLCourseOrdersViewController viewController] animated:YES];
//        
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
    
    
    if([textField.text rangeOfString:@"元"].location !=NSNotFound)
        //_roaldSearchText
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
-(void)setTableFooterView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 100)];
    UIButton *btn = [UIButton buttonWithFrame:CGRectMake(30, 50, kMainBoundsWidth-60, 40) title:@"保存" titleColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:14.0] backgroundColor:kSliderRedColor];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 20;
    [btn addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    _TableView.tableFooterView = view;
}

-(void)getInputMoney
{
    userInfo = [UserInfo sharedUserInfo];
    NSString * token = userInfo.token;
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token", nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_setUpCourse pragma:postDict];
    
    
    request.successBlock = ^(id obj){
  
        NSLog(@"%@ ",obj);
        _showMoney = [obj[0] valueForKey:@"price"];
        inputMoney = [NSString stringWithFormat:@"%@元",_showMoney];
        
         NSNumber * lessonNumber = [obj[0] valueForKey:@"orderCount"];
        
        _lessonCount = [NSString stringWithFormat:@"%@单",lessonNumber];
        
        [_TableView reloadData];
    };
    request.failureDataBlock = ^(id error)
    {
        [HDHud hideHUDInView:self.view];
        NSString * message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    };
    
    request.failureBlock = ^(id obj){
        [HDHud hideHUDInView:self.view];
        [HDHud showNetWorkErrorInView:self.view];
    };

}

-(void)saveButtonClick:(UIButton*)sender
{
  

 
    if ([inputMoney length]==0) {
        [HDHud showMessageInView:self.view title:@"您还没有输入课程价格"];
    }else
    {
        [HDHud showHUDInView:self.view title:@"正在提交..."];
        userInfo = [UserInfo sharedUserInfo];
        NSString * token = userInfo.token;
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",inputMoney,@"price", nil];

        HttpRequest * request = [[HttpRequest alloc]init];
        [request RequestDataWithUrl:URL_setUpCourse pragma:postDict];
        
        
        request.successBlock = ^(id obj){
            
            [HDHud hideHUDInView:self.view];
            NSLog(@"%@",obj);
            
            [HDHud showMessageInView:self.view title:@"提交成功"];
           
            
            
            
        };
        request.failureDataBlock = ^(id error)
        {
            [HDHud hideHUDInView:self.view];
            NSString * message = (NSString *)error;
            [HDHud showMessageInView:self.view title:message];
        };
        
        request.failureBlock = ^(id obj){
            [HDHud hideHUDInView:self.view];
            [HDHud showNetWorkErrorInView:self.view];
        };
        
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

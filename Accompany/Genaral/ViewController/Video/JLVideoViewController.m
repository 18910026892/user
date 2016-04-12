//
//  JLVideoViewController.m
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLVideoViewController.h"
#import "JLVideoViewListViewController.h"
#import "JLVideoModel.h"
@interface JLVideoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView *footerView;
    UITextField *otherTextField;
}

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *DataList;
@property(nonatomic,strong)NSMutableDictionary *selectDataDict;
@end

@implementation JLVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"视频"];
    [self setupViews];
    [self setupDatas];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:_isHandelOrder];
    if(_isFirstEnter){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HANDELSUBJECT"];
    }
    _isFirstEnter = NO;
    if(_isHandelOrder){
        [self showBackButton:YES];
        _selectDataDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"HANDELSUBJECT"] ];
        [_table reloadData];
    }
}


-(void)setupViews
{
    [self.view addSubview:self.table];
    if(_isHandelOrder){
        [self footerView];
        self.enableIQKeyboardManager = YES;
        self.enableKeyboardToolBar = YES;
    }
}

-(void)setupDatas
{
    [HDHud showHUDInView:self.view title:@"加载中"];
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_VideoParentList pragma:nil];
    [request getResultWithSuccess:^(id response) {
        NSLog(@"--%@",response);
        NSArray *data =  (NSArray *)response;//[[[response firstObject] allValues] firstObject];
        _DataList = [JLVideoModel mj_objectArrayWithKeyValuesArray:data];
        [_table reloadData];
        [HDHud hideHUDInView:self.view];
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];

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

-(void)footerView
{
    footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 140)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLable = [UILabel labelWithFrame:CGRectMake(10, 10, 40, 30) text:@"备注：" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13.0]];
    [footerView addSubview:titleLable];
    
    otherTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, kMainBoundsWidth-55, 30)];
    otherTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"说点什么吧..." attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    otherTextField.font = [UIFont systemFontOfSize:14];
    otherTextField.textColor =  [UIColor whiteColor];
    otherTextField.delegate = self;
    [footerView addSubview:otherTextField];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kMainBoundsWidth, 0.5)];
    line.backgroundColor = kSeparatorLineColor;
    [footerView addSubview:line];

    UIButton *btn = [UIButton buttonWithFrame:CGRectMake(20, 90, kMainBoundsWidth-40, 40) title:@"确定" titleColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:14.0] backgroundColor:kSliderRedColor];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 20;
    [btn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    
    self.table.tableFooterView = footerView;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return _DataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    JLVideoModel *model = [_DataList objectAtIndex:section];
    NSString *name = model.name;
    NSArray *arr = [NSArray array];
    if([[_selectDataDict allKeys] containsObject:name]){
        arr = [_selectDataDict valueForKey:name];
    }
    return 1+arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(kMainBoundsWidth-25, 16, 8, 12)];
        img.image = [UIImage imageNamed:@"rightRow"];
        img.tag = 100;
        [cell addSubview:img];
        if(_isHandelOrder){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(kMainBoundsWidth-50, 0, 50, 42) ;
            [btn setImage:[UIImage imageNamed:@"chahao"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
    }
    
    UIImageView *arow = (UIImageView *)[cell viewWithTag:100];
    if(indexPath.row==0){
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        arow.hidden = NO;
        for (UIView *vv in cell.subviews) {
            if([vv isKindOfClass:[UIButton class]]){
                vv.hidden = YES;
            }
        }
        JLVideoModel *model = (JLVideoModel *)_DataList[indexPath.section];
        cell.textLabel.text = model.name;
    }else{
        arow.hidden = YES;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];

        for (UIView *vv in cell.subviews) {
            if([vv isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)vv;
                btn.tag = 1000*indexPath.section+indexPath.row;
                btn.hidden = NO;
            }
        }
        JLVideoModel *model = [_DataList objectAtIndex:indexPath.section];
        NSString *name = model.name;
        NSArray *arr = [_selectDataDict valueForKey:name];
        NSDictionary *dict = arr[indexPath.row-1];
        cell.textLabel.text = dict[@"name"];
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row? 38: 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        JLVideoModel *model = (JLVideoModel *)_DataList[indexPath.section];
        JLVideoViewListViewController *listVC = [JLVideoViewListViewController viewController];
        listVC.videoModel = model;
        listVC.isHandelOrder = _isHandelOrder;
        listVC.categoryName = model.name;
        [self.navigationController pushViewController:listVC animated:YES];
    }
}



-(void)sureBtnClick:(UIButton *)btn
{
    [otherTextField resignFirstResponder];
    if([_selectDataDict allKeys].count==0){
        [HDHud showMessageInView:self.view title:@"请先选择课程"];
    }else{
        [self handelOrderMethod];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [otherTextField resignFirstResponder];
    return YES;
}


-(void)handelOrderMethod
{
    [HDHud showHUDInView:self.view title:@"加载中"];
    NSString *otherStr = otherTextField.text;
    __block NSString *videosId = @"";
    for(NSString *key in [_selectDataDict allKeys]){
        NSArray *arr = [NSArray arrayWithArray:_selectDataDict[key]];
        [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(videosId.length==0){
                videosId = obj[@"id"];
            }else{
                videosId = [videosId stringByAppendingString:[NSString stringWithFormat:@",%@",obj[@"id"]]];
            }
        }];
    }
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",_oderId,@"orderId",videosId,@"vcIds",otherStr,@"coachComment",nil];
    
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_handleOrder pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSLog(@"--%@",response);
        [HDHud showMessageInView:self.view title:@"订单处理成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(),^{
            _selectDataDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"HANDELSUBJECT"] ];
            NSInteger index= [self.navigationController.viewControllers indexOfObject:self]-2;
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index] animated:YES];
        });
        
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}


-(void)deleteButtonClick:(UIButton *)btn
{
    NSInteger section = btn.tag/1000;
    NSInteger row = btn.tag%1000;

    JLVideoModel *model = [_DataList objectAtIndex:section];
    NSString *name = model.name;
    NSMutableArray *arr = [NSMutableArray arrayWithArray: [_selectDataDict valueForKey:name] ];
    [arr removeObjectAtIndex:row-1];
    [_selectDataDict setObject:arr forKey:name];
    [[NSUserDefaults standardUserDefaults]setObject:_selectDataDict forKey:@"HANDELSUBJECT"];
    [_table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

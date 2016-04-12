//
//  JLVideoViewListViewController.m
//  Accompany
//
//  Created by 王园园 on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLVideoViewListViewController.h"
#import "JLVideoCollectViewController.h"

@interface JLVideoViewListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *DataList;

@end

@implementation JLVideoViewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:_videoModel.name];
    [self setTabBarHide:YES];
    [self showBackButton:YES];
    [self setupViews];
    [self setupDatas];
    // Do any additional setup after loading the view.
}

-(void)setupViews
{
    [self.view addSubview:self.table];
}

-(void)setupDatas
{
    [HDHud showHUDInView:self.view title:@"加载中"];
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:_videoModel.prarentId,@"parentId", nil];
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_VideoSubList pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSLog(@"--%@",response);
        _DataList = [JLVideoModel mj_objectArrayWithKeyValuesArray:response];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    JLVideoModel *model = (JLVideoModel *)_DataList[indexPath.section];
    cell.textLabel.text = model.name;
    cell.textLabel.textColor = [UIColor whiteColor];
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JLVideoModel *model = (JLVideoModel *)_DataList[indexPath.section];
    if(!_listType){
        JLVideoViewListViewController *listVC = [JLVideoViewListViewController viewController];
        listVC.listType = 1;
        listVC.videoModel = model;
        listVC.categoryName = _categoryName;
        listVC.isHandelOrder =  _isHandelOrder;
        [self.navigationController pushViewController:listVC animated:YES];
    }else{
        JLVideoCollectViewController *listVC = [JLVideoCollectViewController viewController];
        listVC.videoModel = model;
        listVC.categoryName = _categoryName;
        listVC.isHandelOrder =  _isHandelOrder;
        [self.navigationController pushViewController:listVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

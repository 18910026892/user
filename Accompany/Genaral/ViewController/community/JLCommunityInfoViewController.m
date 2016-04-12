//
//  JLCommunityInfoViewController.m
//  Accompany
//
//  Created by 王园园 on 16/2/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLCommunityInfoViewController.h"
#import "JLMycomListCell.h"
#import "JLAddUsersViewController.h"
#import "JLMyCommunityModel.h"
#import "UIImageView+WebCache.h"
#import "JLMoreUserViewController.h"
static const char kRepresentedObject;

@interface JLCommunityInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MyComListCellDelegate>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *DataList;

@property(nonatomic,strong)JLMyCommunityModel *infoModel;
@property(nonatomic,strong)NSArray *usersList;
@end

@implementation JLCommunityInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"社区信息"];
    [self showBackButton:YES];
    [self setTabBarHide:YES];
    [self setupViews];
    [self setupDatas];
}

-(void)setupViews
{
    [self.RightBtn setImage:[UIImage imageNamed:@"inviteFriend"] forState:UIControlStateNormal];
    [self.RightBtn addTarget:self action:@selector(inviteUsersBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.table];
    [self setTableFooterView];
    
}

-(void)setupDatas
{
    [self getCommunityInfoData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCommunityUsersData];
}

//社区信息
-(void)getCommunityInfoData
{
    [HDHud showHUDInView:self.view title:@"加载中"];
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:_comId,@"communityId",[UserInfo sharedUserInfo].token,@"token",nil];
    NSLog(@"%@,%@",URL_GetCommunityInfo,pragma);
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_GetCommunityInfo pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSLog(@"--%@",response);
        _infoModel = [JLMyCommunityModel mj_objectWithKeyValues:[response firstObject]];
        [_table reloadData];
        [HDHud hideHUDInView:self.view];
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}
//社区居民
-(void)getCommunityUsersData
{
    [HDHud showHUDInView:self.view title:@"加载中"];
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:_comId,@"communityId",nil];
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_GetCommunityUsers pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSLog(@"--%@",response);
        _usersList = [JLPostUserInfoModel mj_objectArrayWithKeyValuesArray:response];
        [_table reloadData];
        [HDHud hideHUDInView:self.view];
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}


-(void)inviteUsersBtnClick:(UIButton *)btn
{
    JLAddUsersViewController *addUserVC = [JLAddUsersViewController viewController];
    [self.navigationController pushViewController:addUserVC animated:YES];
}

-(UITableView *)table
{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0,64, kMainBoundsWidth, kMainScreenHeight-64) style:UITableViewStyleGrouped];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(indexPath.section==0){
        JLMycomListCell *cell = [tableView dequeueReusableCellWithIdentifier:[JLMycomListCell cellIdentifier]];
        if(!cell){
            cell = [JLMycomListCell loadFromXib];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [cell fillCellWithObject:_infoModel];
        return cell;
    }else if(indexPath.section==3){
        cell = [self introlCellFortableView:tableView RowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        cell = [self infoCellFortableView:tableView RowAtIndexPath:indexPath];
        if(indexPath.section==2){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return [JLMycomListCell rowHeightForObject:nil];
    }else if (indexPath.section==3){
        float height = [self HeightForIntroCellOfObject:_infoModel.comment]+35;
        return height>55?height:55;
    }else{
        return 50;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0 || section==3){
        return 0.1;
    }else
        return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==2){
        JLMoreUserViewController *vc = [JLMoreUserViewController viewController];
        vc.infoModel = _infoModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 简介Cell
-(UITableViewCell *)introlCellFortableView:(UITableView *)tableView RowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntrolCell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntrolCell"];
       UILabel *titleLable = [UILabel labelWithFrame:CGRectMake(10, 5, 60, 25) text:@"简介" textColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:14] backgroundColor:[UIColor clearColor]];
        [cell addSubview:titleLable];
        
        UILabel *desLable = [UILabel labelWithFrame:CGRectMake(10, 30, kMainScreenWidth-15, 25) text:@"简介" textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:14] backgroundColor:[UIColor clearColor]];
        desLable.tag = 1000;
        [cell addSubview:desLable];
    }
    UILabel *desLable = (UILabel *)[cell viewWithTag:1000];
    desLable.text = _infoModel.comment;
    desLable.numberOfLines = 0;
    [desLable sizeToFit];
    return cell;
}

-(CGFloat)HeightForIntroCellOfObject:(NSString *)des
{
    des = _infoModel.comment;
    return [Helper heightForLabelWithString:des withFontSize:14 withWidth:(kMainScreenWidth-15) withHeight:1000];
}

#pragma Mark- 信息展示Cell
-(UITableViewCell *)infoCellFortableView:(UITableView *)tableView RowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    UILabel *titleLable;
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoCell"];
        titleLable = [UILabel labelWithFrame:CGRectMake(10, 10, 60, 30) text:@"社区主任" textColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:14] backgroundColor:[UIColor clearColor]];
        [cell addSubview:titleLable];
    }
    NSArray *userArr;
    if(indexPath.section==1){
        titleLable.text = @"社区主任";
        if(_infoModel){
            userArr = @[_infoModel.grssUser];
        }
    }else{
        titleLable.text = @"居民";
        userArr =_usersList;
    }
    [cell.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIImageView class]]){
            [obj removeFromSuperview];
        }
    }];
    [userArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx>=6){
            return;
        }
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(70+35*idx, 10, 30, 30)];
        img.layer.masksToBounds = YES;
        img.layer.cornerRadius = 15;
        JLPostUserInfoModel *userModel = (JLPostUserInfoModel *)userArr[idx];
        [img sd_setImageWithURL:[NSURL URLWithString:userModel.userPhoto] placeholderImage:[UIImage imageNamed:@"touxiang-"]];
        [cell addSubview:img];
    }];
    return cell;
}


#pragma mark - FooterView
-(void)setTableFooterView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 100)];
    UIButton *btn = [UIButton buttonWithFrame:CGRectMake(30, 50, kMainBoundsWidth-60, 40) title:@"举报" titleColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:14.0] backgroundColor:kSliderRedColor];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 20;
    [btn addTarget:self action:@selector(jubaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    _table.tableFooterView = view;
}

-(void)jubaoBtnClick
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否举报该社区" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 3000;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==3000){
        if(buttonIndex==1){
            NSLog(@"举报....");
            [HDHud showHUDInView:self.view title:@"提交中"];
            NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",_comId,@"commnuityId",nil];
            HttpRequest *request = [[HttpRequest alloc]init];
            [request RequestDataWithUrl:URL_JubaoCommunity pragma:pragma];
            [request getResultWithSuccess:^(id response) {
                [HDHud showMessageInView:self.view title:@"举报成功"];
            } DataFaiure:^(id error) {
                NSString *message = (NSString *)error;
                [HDHud showMessageInView:self.view title:message];
            } Failure:^(id error) {
                [HDHud showNetWorkErrorInView:self.view];
            }];
        }

    }else{
        if(buttonIndex==0) return;
        JLMyCommunityModel *data = (JLMyCommunityModel *)objc_getAssociatedObject(alertView,&kRepresentedObject);
        [HDHud showHUDInView:self.view title:@"提交中"];
        NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",data.communityId,@"communityId",nil];
        NSString *url = URL_JoinCommunity;
        if(data.isJoin.integerValue!=0){
            url = URL_QuitCommunity;
        }
        HttpRequest *request = [[HttpRequest alloc]init];
        [request RequestDataWithUrl:url pragma:pragma];
        [request getResultWithSuccess:^(id response) {
            [self getCommunityInfoData];
            [self getCommunityUsersData];
        } DataFaiure:^(id error) {
            NSString *message = (NSString *)error;
            [HDHud showMessageInView:self.view title:message];
        } Failure:^(id error) {
            [HDHud showNetWorkErrorInView:self.view];
        }];

    }
}
#pragma mark -
#pragma mark - MyComListCellDelegate
-(void)joinCommunityBtn:(UIButton *)btn selectedWithData:(JLMyCommunityModel *)data;
{
    NSString *message = @"确定加入该社区?";
    if(data.isJoin.integerValue==1){
        message = @"确定退出该社区?";
    }
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示" message:message
                          delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"确定",nil];
    objc_setAssociatedObject(alert,
                             &kRepresentedObject,
                             data,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

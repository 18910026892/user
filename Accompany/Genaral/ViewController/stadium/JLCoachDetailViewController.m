//
//  JLCoachDetailViewController.m
//  Accompany
//
//  Created by 巩鑫 on 16/2/6.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLCoachDetailViewController.h"
#import "JLBuyCourseViewController.h"
#import "ChatViewController.h"

#import "JLPublicViewController.h"
#import "JLPostListCell.h"
#import "JLPostListModel.h"
#import "MJRefresh.h"
#import "JLComRequestManager.h"

#import "JLCommentListCell.h"
#import "JLPostCommentListModel.h"

#import "JLPostDetailViewController.h"

#import "NickNameAndHeadImage.h"

#import "JLCommentModel.h"

#import "JLWaitHandleViewController.h"
#define PageSzie 10
static const char kRepresentedObject;
@interface JLCoachDetailViewController ()<PostListCellDelegate>

@end

@implementation JLCoachDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarHide:YES];
    [self setupDatas];
    [self setupViews];
    _selectIndex = 0;
 
    _privateChat = YES;
    
 
    [[NickNameAndHeadImage shareInstance] loadUserProfileInBackgroundWithUserId:self.coachModel.userId];
}


-(void)setupDatas
{

    
    _dynamicArray = [NSMutableArray array];
 
    _commentArray =  [NSMutableArray array];
   
    _tableArray = [NSMutableArray array];
    self.menuItems = @[@"最新动态",@"教练评价"];
    
    [HDHud showHUDInView:self.TableView title:@"加载中"];
    [self headerRereshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PostRefresh:) name:KN_POSTREFRESH object:nil];
    
     [self GetUserSetup];
    
}
//请求数据
-(void)headerRereshing
{
    [self loadListDataWithPage:1];
}
//加载更多数据
-(void)loadMoreData
{
    NSInteger page = (_dynamicArray.count%PageSzie)?_dynamicArray.count/PageSzie+1:_dynamicArray.count/PageSzie+2;
    [self loadListDataWithPage:page];
}

-(void)PostRefresh:(NSNotification *)notify
{
    [self headerRereshing];
}
-(void)loadListDataWithPage:(NSInteger)page
{
 
    NSString * userId = self.coachModel.userId;
    
    NSMutableDictionary *pragma = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",@(page),@"page",@(PageSzie),@"num",userId,@"userId",nil];
    NSString *url = URL_GetUserPostList;
    
    
    NSLog(@"%@---%@",pragma,url);
    
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:url pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSArray *resultList = (NSArray *)response;
        
        
        if(page==1){
            [_dynamicArray removeAllObjects];
        }
        if(resultList.count>0){
            NSArray *modelList = [JLPostListModel mj_objectArrayWithKeyValuesArray:resultList];
            [_dynamicArray addObjectsFromArray:modelList];
        }
        [self stopLoadData];
        
        _tableArray = _dynamicArray;
        
        [_TableView reloadData];
        if(resultList.count<PageSzie){
            [_TableView.footer noticeNoMoreData];
        }
        if(_dynamicArray.count==0){
            [_TableView.footer noticeNoData];
        }
        
    
        
    } DataFaiure:^(id error) {
        [self stopLoadData];
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [self stopLoadData];
        [HDHud showNetWorkErrorInView:self.view];
    }];
}
-(void)loadCommentDataWithPage:(NSInteger)page
{
    [HDHud showHUDInView:self.view title:@"加载中"];

    NSString * coachID = self.coachModel.userId;
    
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:coachID,@"coachId",@(page),@"page",@(PageSzie),@"num",nil];
    
    
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_coachCommentList pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSArray *resultList = (NSArray *)response;
        
        
        NSLog(@"%@ -__ - %@ ---%@",resultList,pragma,URL_coachCommentList
              );
        
        if(page==1){
            [_commentArray removeAllObjects];
        }
        if(resultList.count>0){
            NSArray *modelList = [JLCommentModel mj_objectArrayWithKeyValuesArray:resultList];
            [_commentArray addObjectsFromArray:modelList];
        }
        [self stopLoadData];
        
        _tableArray = _commentArray;
        
        [_TableView reloadData];
        if(resultList.count<PageSzie){
            [_TableView.footer noticeNoMoreData];
        }
        if(_tableArray.count==0){
            [_TableView.footer noticeNoData];
        }
        [HDHud hideHUDInView:self.view];
    } DataFaiure:^(id error) {
        [self stopLoadData];
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [self stopLoadData];
        [HDHud showNetWorkErrorInView:self.view];
    }];
}


-(void)stopLoadData
{
    [HDHud hideHUDInView:self.TableView];
    [_TableView.footer endRefreshing];
}

-(void)GetUserSetup
{
    NSString * userID = self.coachModel.userId;
    NSMutableDictionary *pragma = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID,@"userId",nil];
    
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_getUserSetUp pragma:pragma];
    [request getResultWithSuccess:^(id response) {
    
        NSLog(@"%@",response);
        _shareUrl = [response[1] valueForKey:@"shareUrl"];
        
        NSNumber * number = [response[0] valueForKey:@"privateChat"];
        
        NSString *privateChat = [number stringValue];
        
        
        if ([privateChat isEqualToString:@"0"]) {
            _privateChat = NO;
        }else if([privateChat isEqualToString:@"1"])
        {
            _privateChat = YES;
        }
        
    } DataFaiure:^(id error) {
     
    } Failure:^(id error) {
      
    }];
    
}


-(void)setupViews
{
    [self.view addSubview:self.TableView];
    [self.view addSubview:self.FooterView];
}

-(CoachDetailHeader*)Header
{
    if (!_Header) {
        _Header = [[CoachDetailHeader alloc]init];
        _Header.frame = CGRectMake(0, 0, kMainBoundsWidth, 220*Proportion);
        _Header.delegate = self;
        _Header.userInteractionEnabled = YES;
        _Header.image = [UIImage imageNamed:@"userCenterHeader"];
        
    }
    return _Header;
}

//头像试图
-(UIImageView*)PhotoImageView
{
    if (!_PhotoImageView) {
        _PhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 140*Proportion, 60*Proportion, 60*Proportion)];
        _PhotoImageView.layer.borderColor = [UIColor grayColor].CGColor;
        _PhotoImageView.layer.borderWidth = 0.5;
        _PhotoImageView.layer.masksToBounds = YES;
        _PhotoImageView.layer.cornerRadius = 30 * Proportion;
        
        NSString * tianChongImage = @"userPhoto";
        NSString * photoURL = self.coachModel.userPhoto;
        
        [_PhotoImageView sd_setImageWithURL:[NSURL URLWithString:photoURL] placeholderImage:[UIImage imageNamed:tianChongImage]];
    }
    return _PhotoImageView;
}


//买课按钮
-(UIButton*)BuyClassButtonButton
{
    if (!_BuyClassButtonButton) {
        
        NSString * attentionTitle = @"购课";
        
        _BuyClassButtonButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _BuyClassButtonButton.frame = CGRectMake(kMainBoundsWidth-80*Proportion,180*Proportion,60*Proportion, 25*Proportion);
        _BuyClassButtonButton.backgroundColor = [UIColor clearColor];
        [_BuyClassButtonButton setTitle:attentionTitle forState:UIControlStateNormal];
        [_BuyClassButtonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _BuyClassButtonButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _BuyClassButtonButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _BuyClassButtonButton.layer.cornerRadius = 12.5*Proportion;
        _BuyClassButtonButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _BuyClassButtonButton.layer.borderWidth = .5;
        [_BuyClassButtonButton addTarget:self action:@selector(BuyClassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _BuyClassButtonButton;
}

-(void)BuyClassButtonClick:(UIButton*)sender
{
    NSString * price =[self.coachModel.grssCourse valueForKey:@"price"];
    
    NSLog(@"&&&&&&%@",price);
    userInfo = [UserInfo sharedUserInfo];
    
    
    if (!price) {
        [HDHud showMessageInView:self.view title:@"对不起，该教练无有效课程，暂时无法够课"];
    }else if([userInfo.userId isEqualToString:self.coachModel.userId])
    {
        [HDHud showMessageInView:self.view title:@"对不起，您无法购买自己的课程"];
        
    }else
    {
        JLBuyCourseViewController * BuyCourseVc= [JLBuyCourseViewController viewController];
        BuyCourseVc.coachModel = self.coachModel;
        [self.navigationController pushViewController:BuyCourseVc animated:YES];
        
        
//        JLWaitHandleViewController * Whvc = [JLWaitHandleViewController viewController];
//        [self.navigationController pushViewController:Whvc animated:YES];
        
    }
    

    
}


//昵称标签
-(UILabel*)NickNameLabel
{
    
    NSString * nickName = self.coachModel.nikeName;
    if (!_NickNameLabel) {
        _NickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*Proportion, 180*Proportion, kMainBoundsWidth/2, 20*Proportion)];
        _NickNameLabel.backgroundColor = [UIColor clearColor];
        _NickNameLabel.text = nickName;
        _NickNameLabel.textColor = [UIColor whiteColor];
        _NickNameLabel.font = [UIFont systemFontOfSize:14];
        _NickNameLabel.textAlignment = NSTextAlignmentLeft;
        
        
    }
    return _NickNameLabel;
}
//昵称标签
-(UILabel*)InfoLabel
{
    
    NSString * sex;
    if ([self.coachModel.userSex isEqualToString:@"1"]) {
        sex = @"男";
    }else if([self.coachModel.userSex isEqualToString:@"2"])
    {
        sex = @"女";
    }
    NSString * age;
    NSString * realAge ;
    if ([self.coachModel.birthday length]>10) {
        age = [self.coachModel.birthday substringToIndex:10];
        realAge =[NSString stringWithFormat:@"%@岁",[self getAgeFromBirthday:age]];
    }else
    {
        age = @"";
        realAge = @"";
    }
    
    NSString * constellation = self.coachModel.constellation;
    
    NSString * info = [NSString stringWithFormat:@"%@ %@ %@",sex,realAge,constellation];

  
    if (!_InfoLabel) {
        _InfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*Proportion, 200*Proportion, kMainBoundsWidth/2, 20*Proportion)];
        _InfoLabel.backgroundColor = [UIColor clearColor];
        _InfoLabel.text = info;
        _InfoLabel.textColor = [UIColor grayColor];
        _InfoLabel.font = [UIFont systemFontOfSize:12];
        _InfoLabel.textAlignment = NSTextAlignmentLeft;
        
        
    }
    return _InfoLabel;
}


-(NSString*)getAgeFromBirthday:(NSString*)birthday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //定义一个NSCalendar对象
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birthday];
    //用来得到具体的时差
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0]; if([date year] >0) { NSLog(@"%@",[NSString stringWithFormat:(@"%ld岁%ld月%ld天"),(long)[date year],(long)[date month],(long)[date day]]) ; } else if([date month] >0) { NSLog(@"%@",[NSString stringWithFormat:(@"%ld月%ld天"),(long)[date month],(long)[date day]]); } else if([date day]>0){ NSLog(@"%@",[NSString stringWithFormat:(@"%ld天"),(long)[date day]]); } else { NSLog(@"0天");}
    
    NSString * age = [NSString stringWithFormat:@"%ld",(long)[date year]];
    return age;
    
}

#pragma HeaderDelegate

-(void)BackButtonClick:(UIButton*)Button;
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView*)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight-40) style:UITableViewStylePlain];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
        _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_TableView setParallaxHeaderView:self.Header
                                     mode:VGParallaxHeaderModeFill
                                   height:220*Proportion];
        
        [_TableView addSubview:self.PhotoImageView];
        [_TableView addSubview:self.NickNameLabel];
        [_TableView addSubview:self.InfoLabel];
        [_TableView addSubview:self.BuyClassButtonButton];
    }
    
    return _TableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_TableView shouldPositionParallaxHeader];
    
}

#pragma TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (indexPath.section==7&&_selectIndex==0) {
      return [JLPostListCell rowHeightForObject:[_tableArray objectAtIndex:indexPath.row]];
    }else if (indexPath.section==7&&_selectIndex==1)
    {
        
         return [JLCommentListCell RowHeightForModel:_tableArray[indexPath.row]];
    }else
    {
        return 44;
    }


}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section==7) {
        if (_selectIndex==0) {
            return 0;
        }else if(_selectIndex==1)
        {
            return 30;
        }
    }
        return 0;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{

   
    _sectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 20)];
    _sectionTitle.backgroundColor = [UIColor clearColor];
    _sectionTitle.textColor = [UIColor grayColor];
    _sectionTitle.textAlignment = NSTextAlignmentLeft;
    _sectionTitle.font = [UIFont systemFontOfSize:14.0f];
    _sectionTitle.text = [NSString stringWithFormat:@"     评论数%lu",(unsigned long)[_tableArray count]];
  
    return _sectionTitle;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section==7) {
        
        return [_tableArray count];
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    
    static NSString * cellID = @"CellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
                

    }else{
        
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if (indexPath.section==0) {
        
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 80, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor grayColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:_cellTitle];
        _cellTitle.text = @"场馆";
        
        _cellContent = [[UILabel alloc]initWithFrame:CGRectMake(100, 12, kMainBoundsWidth-160, 20)];
        _cellContent.backgroundColor = [UIColor clearColor];
        _cellContent.textColor = [UIColor whiteColor];
        _cellContent.textAlignment = NSTextAlignmentLeft;
        _cellContent.font = [UIFont systemFontOfSize:14];
        
        NSString * venueName = [self.coachModel.grssClub valueForKey:@"clubName"];
        
        if ([venueName isEqualToString:@""]) {
            _cellContent.text = @"暂无";
        }else
        {
            _cellContent.text = venueName;
        }
        [cell.contentView addSubview:_cellContent];
        
        
        _DowncellLine = [[UILabel alloc]init];
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = RGBACOLOR(150,150,150, 1);
        [cell.contentView addSubview:_DowncellLine];
        
        
    }else
    
    if (indexPath.section==1) {
        
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 80, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor grayColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:_cellTitle];
        _cellTitle.text = @"价格";
        
        _cellContent = [[UILabel alloc]initWithFrame:CGRectMake(100, 12, kMainBoundsWidth-160, 20)];
        _cellContent.backgroundColor = [UIColor clearColor];
        _cellContent.textColor = [UIColor whiteColor];
        _cellContent.textAlignment = NSTextAlignmentLeft;
        _cellContent.font = [UIFont systemFontOfSize:14];
        
        NSString * price = [self.coachModel.grssCourse valueForKey:@"price"];
        
        NSString * showPrice = [NSString stringWithFormat:@"￥ %@元",price];
        
        
        if ([showPrice isEqualToString:@"￥ 元"]) {
            _cellContent.text = @"暂无";
        }else
        {
            _cellContent.text = showPrice;
        }
        [cell.contentView addSubview:_cellContent];
        
        
        _DowncellLine = [[UILabel alloc]init];
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = RGBACOLOR(150,150,150, 1);
        [cell.contentView addSubview:_DowncellLine];
        
        
    }else
    
    if (indexPath.section==2) {
        
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 80, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor grayColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:_cellTitle];
        _cellTitle.text = @"执教人数";
        
        _cellContent = [[UILabel alloc]initWithFrame:CGRectMake(100, 12, kMainBoundsWidth-160, 20)];
        _cellContent.backgroundColor = [UIColor clearColor];
        _cellContent.textColor = [UIColor whiteColor];
        _cellContent.textAlignment = NSTextAlignmentLeft;
        _cellContent.font = [UIFont systemFontOfSize:14];
        
        NSString * zhidaoCount = [NSString stringWithFormat:@"%@人", self.coachModel.guidanceCount];
        
        if ([zhidaoCount isEqualToString:@""]) {
            _cellContent.text = zhidaoCount;
        }else
        {
            _cellContent.text = zhidaoCount;
        }
        [cell.contentView addSubview:_cellContent];
        
        
        _DowncellLine = [[UILabel alloc]init];
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = RGBACOLOR(150,150,150, 1);
        [cell.contentView addSubview:_DowncellLine];
        
        
    }else
    if (indexPath.section==3) {
        
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 80, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor grayColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:_cellTitle];
        _cellTitle.text = @"执教时间";
        
        _cellContent = [[UILabel alloc]initWithFrame:CGRectMake(100, 12, kMainBoundsWidth-160, 20)];
        _cellContent.backgroundColor = [UIColor clearColor];
        _cellContent.textColor = [UIColor whiteColor];
        _cellContent.textAlignment = NSTextAlignmentLeft;
        _cellContent.font = [UIFont systemFontOfSize:14];
        
        NSString * regCoachTime;
        if([self.coachModel.regCoachDate length]>10)
        {
        regCoachTime = [self.coachModel.regCoachDate substringToIndex:10];
        }else
        {
            regCoachTime = @"";
        }
        

        if ([regCoachTime isEqualToString:@""]) {
            _cellContent.text = @"暂无";
        }else
        {
            _cellContent.text = regCoachTime;
        }
        [cell.contentView addSubview:_cellContent];
        
        
        _DowncellLine = [[UILabel alloc]init];
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = RGBACOLOR(150,150,150, 1);
        [cell.contentView addSubview:_DowncellLine];
        
        
    }else if (indexPath.section==4) {
      
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 80, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor grayColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:_cellTitle];
        _cellTitle.text = @"个性签名";

        _cellContent = [[UILabel alloc]initWithFrame:CGRectMake(100, 12, kMainBoundsWidth-160, 20)];
        _cellContent.backgroundColor = [UIColor clearColor];
        _cellContent.textColor = [UIColor whiteColor];
        _cellContent.textAlignment = NSTextAlignmentLeft;
        _cellContent.font = [UIFont systemFontOfSize:14];
        if ([self.coachModel.userDesc isEqualToString:@""]) {
            _cellContent.text = @"暂无";
        }else
        {
            _cellContent.text = self.coachModel.userDesc;
        }
        [cell.contentView addSubview:_cellContent];
        
        
        _DowncellLine = [[UILabel alloc]init];
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = RGBACOLOR(150,150,150, 1);
        [cell.contentView addSubview:_DowncellLine];
        
        
    }else if(indexPath.section==5)
    {
        
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 80, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor grayColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:_cellTitle];
        _cellTitle.text = @"等级";
   
        _starView = [[DJQRateView alloc]initWithFrame:CGRectMake(100, 12, 120, 20)];
        _starView.rate = [self.coachModel.userLevel intValue];
        [cell.contentView addSubview:_starView];
        
        
        _DowncellLine = [[UILabel alloc]init];
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = RGBACOLOR(150,150,150, 1);
        [cell.contentView addSubview:_DowncellLine];
        
        
     }else if(indexPath.section==6)
    {
        
    [cell.contentView addSubview:self.control];
    [cell.contentView addSubview:self.lineLabel];
                
    }
    if (indexPath.section==7) {

    switch (_selectIndex) {
    case 0:
    {
        JLPostListCell *cell = [tableView dequeueReusableCellWithIdentifier:[JLPostListCell cellIdentifier]];
        if(!cell){
            cell = [JLPostListCell loadFromXib];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           // cell.delegate = self;
            
        }
        
        [cell fillCellWithObject:_tableArray[indexPath.row]];
        return cell;
    }
    break;
    case 1:
    {
        
        JLCommentModel * model = _tableArray[indexPath.row];
        JLCommentListCell *commentCell = [tableView dequeueReusableCellWithIdentifier:[JLCommentListCell cellIdentifier]];
        if(!commentCell){
            commentCell = [JLCommentListCell loadFromXib];
            commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        commentCell.commentModel = model;
       
        return commentCell;
            }
                break;
            default:
                break;
        }
    }
   return cell;

}

-(UILabel*)lineLabel
{
    if (!_lineLabel) {
        _lineLabel= [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
        _lineLabel.frame = CGRectMake(kMainBoundsWidth/2, 17, 1, 10);
    }
    return _lineLabel;
}


- (DZNSegmentedControl *)control
{
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:self.menuItems];
        _control.delegate = self;
        _control.selectedSegmentIndex = 0;
        _control.bouncySelectionIndicator = NO;
        _control.height = 40.0f;
        _control.frame = CGRectMake(20, 2, kMainBoundsWidth-40, 40);
        _control.showsGroupingSeparators = NO;
        _control.backgroundColor =kDefaultBackgroundColor;
        _control.tintColor = [UIColor redColor];
        _control.showsCount = NO;
        _control.selectionIndicatorHeight = 0;
        [_control addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}
- (void)didChangeSegment:(DZNSegmentedControl *)control
{

    _selectIndex = control.selectedSegmentIndex;

    [_tableArray  removeAllObjects];
    
    if (_selectIndex==0) {
        
        if([_dynamicArray count]!=0)
        {
            _tableArray = _dynamicArray;
        }else
        {
            [self loadListDataWithPage:1];
        }
        
    }else if(_selectIndex==1)
    {
        if ([_commentArray count]!=0) {
            _tableArray = _commentArray;
        }else
        {
              [self loadCommentDataWithPage:1];
        }
      
    }
    
    [self.TableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(indexPath.section==7&&_selectIndex==0){
       
       JLPostDetailViewController *postDetailVC = [[JLPostDetailViewController alloc]init];
       postDetailVC.postInfoModel = _tableArray[indexPath.row];
       [self.navigationController pushViewController:postDetailVC animated:YES];
        
    }
}
//
//#pragma mark -
//#pragma mark - PostDelegate
//-(void)postCellzanBtn:(UIButton *)zanBtn clickedWithData:(JLPostListModel *)celldata;
//{
//    [JLComRequestManager AdmirePostWithPostInfoModel:celldata Success:^(id response) {
//        NSLog(@"点赞成功");
//        //[zanBtn setImage:[UIImage imageNamed:@"zan_red"] forState:UIControlStateNormal];
//         [self loadListDataWithPage:1];
//    } Fail:^(id error) {
//        [HDHud showMessageInView:self.view title:error];
//    } netFail:^(id error) {
//        [HDHud showNetWorkErrorInView:self.view];
//    }];
//}
//-(void)postCellshareBtn:(UIButton *)shareBtn clickedWithData:(id)celldata;
//{
//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle:@"提示" message:@"是否转载该帖子"
//                          delegate:self
//                          cancelButtonTitle:@"取消"
//                          otherButtonTitles:@"确定",nil];
//    objc_setAssociatedObject(alert,
//                             &kRepresentedObject,
//                             celldata,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [alert show];
//}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if(buttonIndex==0) return;
//    id celldata = objc_getAssociatedObject(alertView,&kRepresentedObject);
//    [JLComRequestManager repasteWithPostInfoModel:celldata Success:^(id response) {
//        NSLog(@"转帖成功");
//        [HDHud showMessageInView:self.view title:@"转载成功"];
//         [self loadListDataWithPage:1];
//    } Fail:^(id error) {
//        [HDHud showMessageInView:self.view title:error];
//    } netFail:^(id error) {
//        [HDHud showNetWorkErrorInView:self.view];
//    }];
//}
//
//-(void)postCellcommentBtn:(UIButton *)commentBtn clickedWithData:(JLPostListModel *)celldata;
//{
//    if(_delegate){
//        [_delegate starLeverVCcommentBtn:commentBtn clickedWithData:celldata];
//    }
//}
//
//

#pragma mark - DZNSegmentedControlDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionAny;
}

- (UIBarPosition)positionForSelectionIndicator:(id<UIBarPositioning>)bar
{
    return UIBarPositionAny;
}


-(UIView*)FooterView
{
    if (!_FooterView) {
        _FooterView = [[UIView alloc]init];
        _FooterView.frame = CGRectMake(0, kMainBoundsHeight-40, kMainBoundsWidth, 40);
        _FooterView.backgroundColor = RGBACOLOR(25, 21, 14, 1);
        
        [_FooterView addSubview:self.ShareButton];
        [_FooterView addSubview:self.ChatButton];
        [_FooterView addSubview:self.BlackListButton];
    }
    return _FooterView;
}

-(UIButton*)ShareButton
{
    if (!_ShareButton) {
        _ShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ShareButton.frame = CGRectMake(20*Proportion, 0, 80*Proportion, 40);
        [_ShareButton setImage:[UIImage imageNamed:@"coachshare"] forState:UIControlStateNormal];
        [_ShareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _ShareButton;
}

-(void)shareButtonClick:(UIButton*)sender
{
    NSLog(@"share");
    //微信
    
    [UMSocialData setAppKey:@"56f9ebd9e0f55a288f0002b2"];
    
      [UMSocialWechatHandler setWXAppId:@"wx81081a8c63bf91af" appSecret:@"bb612dc3b9bde84633fbd54b692a70d6" url:_shareUrl];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"教练随行";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"教练随行";
    
    
    //打开新浪微博的SSO开关
    //  [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2227762321" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1104475469" appKey:@"v73xN4C1jk7NrN2N" url:_shareUrl];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialData defaultData].extConfig.qqData.title = @"教练随行";
    [UMSocialData defaultData].extConfig.qzoneData.title = @"教练随行";
    
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56f9ebd9e0f55a288f0002b2"
                                      shareText:@"教练随行"
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,nil]
                                       delegate:self];
    
    
}

-(UIButton*)ChatButton
{
    if (!_ChatButton) {
        _ChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ChatButton.frame = CGRectMake(kMainBoundsWidth/2-40*Proportion, 0, 80*Proportion, 40);
        [_ChatButton setImage:[UIImage imageNamed:@"coachchat"] forState:UIControlStateNormal];
        [_ChatButton addTarget:self action:@selector(ChatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ChatButton;
}

-(void)ChatButtonClick:(UIButton*)sender
{
    NSLog(@"chatbutton");
    
    if(_privateChat==NO)
    {
        [HDHud showMessageInView:self.view title:@"该用户不允许其他人和他私聊"];
        
    }else if(_privateChat==YES)
    {
        if (!userInfo) {
            userInfo = [UserInfo sharedUserInfo];
        }
        
        if ([userInfo.userId isEqualToString:self.coachModel.userId]) {
            UIAlertView * alert =  [[UIAlertView alloc]initWithTitle:@"提示" message:@"您不能与自己聊天" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            
            [alert show];
        }else
        {
            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.coachModel.userId conversationType:eConversationTypeChat];
            [chatController setNavTitle:self.coachModel.nikeName];
            [self.navigationController pushViewController:chatController animated:YES];
        }
        

    }
    
   
}


-(UIButton*)BlackListButton
{
    if (!_BlackListButton) {
        _BlackListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _BlackListButton.frame = CGRectMake(kMainBoundsWidth-100*Proportion, 0, 80*Proportion, 40);
        [_BlackListButton setImage:[UIImage imageNamed:@"coachblacklist"] forState:UIControlStateNormal];
        [_BlackListButton addTarget:self action:@selector(BlackListButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _BlackListButton;
}

-(void)BlackListButtonClick:(UIButton*)sender
{
    NSLog(@"black List");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

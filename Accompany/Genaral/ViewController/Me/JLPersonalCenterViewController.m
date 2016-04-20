//
//  JLPersonalCenterViewController.m
//  Accompany
//
//  Created by GongXin on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLPersonalCenterViewController.h"
#import "ChatViewController.h"
#import "JLFansViewController.h"
#import "JLPostDetailViewController.h"
#import "JLPublicViewController.h"
#import "JLPostListCell.h"
#import "JLPostListModel.h"
#import "MJRefresh.h"
#import "JLComRequestManager.h"
#import "NickNameAndHeadImage.h"
#define PageSzie 10
static const char kRepresentedObject;

@interface JLPersonalCenterViewController ()<PostListCellDelegate>

@end

@implementation JLPersonalCenterViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.automaticallyAdjustsScrollViewInsets=NO;
    [self setTabBarHide:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarHide:YES];
    [self setupDatas];
    [self setupViews];
    
    if ([_pushFlag isEqualToString:@"chat"]) {
        NSLog(@"chat");
    }else
    {
         [[NickNameAndHeadImage shareInstance] loadUserProfileInBackgroundWithUserId:self.userModel.userId];
    }
   
    
}
-(void)setupDatas
{

    [self GetUserSetup];
    
    _dynamicArray = [NSMutableArray array];
    
    [HDHud showHUDInView:self.view title:@"加载中"];
    [self headerRereshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PostRefresh:) name:KN_POSTREFRESH object:nil];
    
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
  
    
    NSString * userId = self.userModel.userId;
    NSMutableDictionary *pragma = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",@(page),@"page",@(PageSzie),@"num",userId,@"userId", nil];
    NSString *url = URL_GetUserPostList;
   
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:url pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSArray *resultList = (NSArray *)response;

        NSLog(@"**%@",resultList);
        if(page==1){
            [_dynamicArray removeAllObjects];
        }
        if(resultList.count>0){
            NSArray *modelList = [JLPostListModel mj_objectArrayWithKeyValuesArray:resultList];
            [_dynamicArray addObjectsFromArray:modelList];
        }
        [self stopLoadData];
        
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
-(void)stopLoadData
{
    [HDHud hideHUDInView:self.view];
    [_TableView.footer endRefreshing];
}


-(void)GetUserSetup
{
    NSString * userID = self.userModel.userId;
    NSMutableDictionary *pragma = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID,@"userId",nil];
    
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_getUserSetUp pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        
    
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
    [self.TableView addSubview:self.FansButton];
    [self.TableView addSubview:self.PhotoImageView];
    [self.TableView addSubview:self.AttentionButton];
    [self.TableView addSubview:self.NickNameLabel];
    [self.TableView addSubview:self.InfoLabel];

    
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
        _PhotoImageView.backgroundColor = [UIColor clearColor];
        
        NSString * tianChongImage = @"userPhoto";
        NSString * userPhoto =self.userModel.userPhoto;
        
        [_PhotoImageView sd_setImageWithURL:[NSURL URLWithString:userPhoto] placeholderImage:[UIImage imageNamed:tianChongImage]];
        
    }
    return _PhotoImageView;
}

-(UIButton*)FansButton
{
    if (!_FansButton) {
        _FansButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _FansButton.frame = CGRectMake(kMainBoundsWidth-80*Proportion, 140*Proportion, 60*Proportion, 25*Proportion);
        _FansButton.backgroundColor = RGBACOLOR(1, 1, 1, .3);
        
        [_FansButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _FansButton.layer.cornerRadius = 12.5*Proportion;
        _FansButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _FansButton.layer.borderWidth = .5;
        [_FansButton addTarget:self action:@selector(FansButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString * fansCount;
        
        NSLog(@"这个用户的粉丝数是 %@ ",self.userModel.fansCount);
        
        if (self.userModel.fansCount==0||[self.userModel.fansCount isEqualToString:@""]) {
            
            fansCount = @"粉丝";
        }else
        {
            fansCount =[NSString stringWithFormat:@"%@+",self.userModel.fansCount];
        }
        
        [_FansButton setTitle:fansCount forState:UIControlStateNormal];
        _FansButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _FansButton;
}
-(void)FansButtonClick:(UIButton*)sender
{
    
    JLFansViewController * fansVC = [JLFansViewController viewController];
    fansVC.UserID = self.userModel.userId;
    [self.navigationController pushViewController:fansVC animated:YES];
}

//关注数量
-(UIButton*)AttentionButton
{
    if (!_AttentionButton) {
        
     
        if ([self.userModel.followRelationship isEqualToString:@"0"]) {
            _attentionTitle = @"关注";
        }else if ([self.userModel.followRelationship isEqualToString:@"1"])
        {
            _attentionTitle = @"已关注";
        }else if ([self.userModel.followRelationship isEqualToString:@"2"])
        {
            _attentionTitle = @"互相关注";
        }
        
        _AttentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _AttentionButton.frame = CGRectMake(kMainBoundsWidth-80*Proportion,180*Proportion,60*Proportion, 25*Proportion);
        _AttentionButton.backgroundColor = [UIColor clearColor];
        [_AttentionButton setTitle:_attentionTitle forState:UIControlStateNormal];
        [_AttentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _AttentionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _AttentionButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _AttentionButton.layer.cornerRadius = 12.5*Proportion;
        _AttentionButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _AttentionButton.layer.borderWidth = .5;
        [_AttentionButton addTarget:self action:@selector(AttentionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _AttentionButton;
}

-(void)AttentionButtonClick:(UIButton*)sender
{
    
    UIButton * btn = (UIButton*)sender;
    btn.userInteractionEnabled = NO;
    [HDHud showHUDInView:self.view title:@"提交中..."];
    [JLComRequestManager attentionUserWithPostInfoModel:self.userModel Success:^(id response) {
        NSLog(@"%@",response);
        
        [HDHud hideHUDInView:self.view];
        
        btn.userInteractionEnabled = YES;
       
        NSNumber * relate = [response[0] valueForKey:@"followRelationship"];
        
        NSString * followRelationship = [relate stringValue];
        
        if ([followRelationship isEqualToString:@"0"]) {
            _attentionTitle = @"关注";
        }else if ([followRelationship isEqualToString:@"1"])
        {
            _attentionTitle = @"已关注";
        }else if ([followRelationship isEqualToString:@"2"])
        {
            _attentionTitle = @"互相关注";
        }
        
        self.userModel.followRelationship = followRelationship;
        
        
        
        [btn setTitle:_attentionTitle forState:UIControlStateNormal];
        
        
    } Fail:^(id error) {
        [HDHud hideHUDInView:self.view];
        [HDHud showMessageInView:self.view title:error];
          btn.userInteractionEnabled = YES;
    } netFail:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
          btn.userInteractionEnabled = YES;
    }];
}
    


//昵称标签
-(UILabel*)NickNameLabel
{
    
    
    if (!_NickNameLabel) {
        _NickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*Proportion, 180*Proportion, kMainBoundsWidth/2, 20*Proportion)];
        _NickNameLabel.backgroundColor = [UIColor clearColor];
        
        _NickNameLabel.textColor = [UIColor whiteColor];
        _NickNameLabel.font = [UIFont systemFontOfSize:14];
        _NickNameLabel.textAlignment = NSTextAlignmentLeft;
        _NickNameLabel.text = self.userModel.nikeName;
        
    }
    return _NickNameLabel;
}
//昵称标签
-(UILabel*)InfoLabel
{
    
    if (!_InfoLabel) {
        _InfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(100*Proportion, 200*Proportion, kMainBoundsWidth/2, 20*Proportion)];
        _InfoLabel.backgroundColor = [UIColor clearColor];
        _InfoLabel.textColor = [UIColor grayColor];
        _InfoLabel.font = [UIFont systemFontOfSize:12];
        _InfoLabel.textAlignment = NSTextAlignmentLeft;
        
        NSString * sex;
        if ([self.userModel.userSex isEqualToString:@"1"]) {
            sex = @"男";
        }else if([self.userModel.userSex isEqualToString:@"2"])
        {
            sex = @"女";
        }
        
        NSString * age;
        if (self.userModel.birthday) {
            
            if ([self.userModel.birthday length]>10) {
                NSString * str =  [self getAgeFromBirthday:[self.userModel.birthday  substringToIndex:10]];
                age = [NSString stringWithFormat:@"%@岁",str];
            }else
            {
                age = [NSString stringWithFormat:@""];
            }
            
            
        }else
        {
            age = [NSString stringWithFormat:@""];
        }
        
        NSString * constellation = self.userModel.constellation;
        
        NSString * info = [NSString stringWithFormat:@"%@ %@ %@",sex,age,constellation];
        
        _InfoLabel.text = info;
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


-(JLPersonalCenterHeader*)Header
{
    
    if (!_Header) {
        _Header = [[JLPersonalCenterHeader alloc]init];
        _Header.frame = CGRectMake(0, 0, kMainBoundsWidth, 220*Proportion);
        _Header.delegate = self;
        _Header.userInteractionEnabled = YES;
         _Header.image = [UIImage imageNamed:@"userCenterHeader"];
        _Header.UserModel = self.userModel;
    }
    return _Header;
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
    }
    
    return _TableView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_TableView shouldPositionParallaxHeader];
    
}
#pragma TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return  [_dynamicArray count]+2;
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{

    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;

        
    }else{
        
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }

    
    if (indexPath.row==0) {
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 80, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor grayColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:_cellTitle];
         _cellTitle.text = @"个性签名";
        
        _cellContent = [[UILabel alloc]initWithFrame:CGRectMake(120, 12, kMainBoundsWidth-140, 20)];
        _cellContent.backgroundColor = [UIColor clearColor];
        _cellContent.textColor = [UIColor whiteColor];
        _cellContent.textAlignment = NSTextAlignmentLeft;
        _cellContent.font = [UIFont systemFontOfSize:14];
        if ([self.userModel.userDesc isEqualToString:@""]) {
            _cellContent.text = @"暂无信息";
        }else
        {
            _cellContent.text = self.userModel.userDesc;
        }
        [cell.contentView addSubview:_cellContent];
        
        
        _DowncellLine = [[UILabel alloc]init];
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = RGBACOLOR(150,150,150, 1);
        [cell.contentView addSubview:_DowncellLine];
        
    }else if(indexPath.row==1)
    {
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 80, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor grayColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:_cellTitle];
        _cellTitle.text = @"等级";
        
        _starView = [[DJQRateView alloc]initWithFrame:CGRectMake(100, 12,120, 20)];
        _starView.rate = [self.userModel.userLevel intValue];
        [cell.contentView addSubview:_starView];
        
        _DowncellLine = [[UILabel alloc]init];
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = RGBACOLOR(150,150,150, 1);
        [cell.contentView addSubview:_DowncellLine];
 
    }else {
        JLPostListCell *cell = [tableView dequeueReusableCellWithIdentifier:[JLPostListCell cellIdentifier]];
        if(!cell){
            cell = [JLPostListCell loadFromXib];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            
        }

        [cell fillCellWithObject:_dynamicArray[indexPath.row-2]];
        return cell;

    }
    
    
    return cell;
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0||indexPath.row==1) {
        return 44;
    }else
    return [JLPostListCell rowHeightForObject:[_dynamicArray objectAtIndex:indexPath.row-2]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.row!=0&&indexPath.row!=1) {
        JLPostDetailViewController *postDetailVC = [[JLPostDetailViewController alloc]init];
        postDetailVC.postInfoModel = _dynamicArray[indexPath.row-2];
        [self.navigationController pushViewController:postDetailVC animated:YES];
    }
}
#pragma mark -
#pragma mark - PostDelegate
-(void)postCellzanBtn:(UIButton *)zanBtn clickedWithData:(JLPostListModel *)celldata;
{
    [JLComRequestManager AdmirePostWithPostInfoModel:celldata Success:^(id response) {
        NSLog(@"点赞成功");
        [self headerRereshing];
    } Fail:^(id error) {
        [HDHud showMessageInView:self.view title:error];
    } netFail:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}
-(void)postCellshareBtn:(UIButton *)shareBtn clickedWithData:(id)celldata;
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示" message:@"是否转载该帖子"
                          delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"确定",nil];
    alert.tag = 1000;
    objc_setAssociatedObject(alert,
                             &kRepresentedObject,
                             celldata,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0) return;
    id celldata = objc_getAssociatedObject(alertView,&kRepresentedObject);
    if(alertView.tag==1000){
        [JLComRequestManager repasteWithPostInfoModel:celldata Success:^(id response) {
            NSLog(@"转帖成功");
            [HDHud showMessageInView:self.view title:@"转载成功"];
            [_TableView.header beginRefreshing];
        } Fail:^(id error) {
            [HDHud showMessageInView:self.view title:error];
        } netFail:^(id error) {
            [HDHud showNetWorkErrorInView:self.view];
        }];
    }
}

-(void)postCellcommentBtn:(UIButton *)commentBtn clickedWithData:(JLPostListModel *)celldata;
{
    JLPostDetailViewController *detail = [[JLPostDetailViewController alloc]init];
    detail.postInfoModel = celldata;
    detail.isCommentSate = YES;
    [self.navigationController pushViewController:detail animated:YES];
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
        
        if ([userInfo.userId isEqualToString:self.userModel.userId]) {
            UIAlertView * alert =  [[UIAlertView alloc]initWithTitle:@"提示" message:@"您不能与自己聊天" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            
            [alert show];
        }else
        {
            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:self.userModel.userId conversationType:eConversationTypeChat];
            [chatController setNavTitle:self.userModel.nikeName];
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

//
//  JLStadiumViewController.m
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLStadiumViewController.h"
#import "JLSearchViewController.h"
#import "JLWebViewController.h"
#import "JLRecommendVenueViewController.h"
#import "JLCoachListViewController.h"
#import "Config.h"
@interface JLStadiumViewController ()

@end

@implementation JLStadiumViewController

-(PickerButton*)pickerButton
{
    if (!_pickerButton) {
        
        CGRect rect = CGRectMake(10,20, 64*Proportion, 44);
        
         _CityArray = @[@"北京",@"上海",@"广东"];
        
        _pickerButton =  [[PickerButton alloc]initWithItemList:_CityArray];
        
        _pickerButton.frame = rect;
        
        [_pickerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        _pickerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        _pickerButton.isShowSelectItemOnButton = YES;
        
        _pickerButton.delegate = self;
        

        
    }
    
    return _pickerButton;
}
#pragma PickerButton Delegate

- (void)pickerButton:(PickerButton *)button
      didSelectIndex:(NSInteger)index
             andItem:(NSString *)item;
{  
    NSLog(@"%ld **** %@ ",(long)index,item);
}


-(void)searchBarButtonClick:(UIButton*)sender

{
    JLSearchViewController * SearchVC = [JLSearchViewController viewController];
    SearchVC.searchType = @"0";
    [self.navigationController pushViewController:SearchVC animated:YES];
}

-(CCAdsPlayView*)BannerView
{
    if (!_BannerView) {
        
        _BannerView = [CCAdsPlayView adsPlayViewWithFrame:CGRectMake(0, 0,kMainScreenWidth,107*Proportion) imageGroup:_BannerImageArray];
        
        _BannerView.placeHoldImage  = [UIImage imageNamed:@"fillimage"];
        //设置小圆点位置
        _BannerView.pageContolAliment = CCPageContolAlimentCenter;
        //设置动画时间
        _BannerView.animationDuration = 3.;
        
        __weak JLStadiumViewController * stadiumVC = self;
        
        __block StadiumAdModel * StadiumAdModel = StadiumAdModel;
        

        
        [_BannerView startWithTapActionBlock:^(NSInteger index) {
            
      
            
            NSLog(@"点击了第%@张",@(index));
            StadiumAdModel = _BannerArray[index];
            JLWebViewController * WebVc = [JLWebViewController viewController];
            WebVc.RequestUlr = StadiumAdModel.linkUrl;
            WebVc.WebTitle = StadiumAdModel.title;
            [stadiumVC.navigationController pushViewController:WebVc animated:YES];
            
        }];

    }

 
    return _BannerView;
}
//添加更新控件
-(void)addRefresh
{

    [_TableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [_TableView.header setTitle:@"下拉可以刷新了" forState:MJRefreshHeaderStateIdle];
    [_TableView.header setTitle:@"松开马上刷新" forState:MJRefreshHeaderStatePulling];
    [_TableView.header setTitle:@"正在刷新 ..." forState:MJRefreshHeaderStateRefreshing];
    [_TableView.header setTextColor:[UIColor whiteColor]];
}
//更新数据
-(void)headerRereshing
{
    [self setupDatas];
   
}


- (UITableView *)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainBoundsWidth,kMainBoundsHeight-93) style:UITableViewStylePlain];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
        _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       [self addRefresh];
    }
    
    return _TableView;
}
#pragma TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 116*Proportion;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 3;
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
     
    }

    NSString * fillimage = @"fillimage";

    switch (indexPath.row) {
        case 0:
        {
            _cellImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kMainBoundsWidth, 116*Proportion)];
            _cellImage1.userInteractionEnabled = YES;
            _cellImage1.backgroundColor = [UIColor clearColor];
            NSURL * ImageUrl1 = [NSURL URLWithString:_clubImage];
            [_cellImage1 sd_setImageWithURL:ImageUrl1 placeholderImage:[UIImage imageNamed:fillimage]];
            [cell.contentView addSubview:_cellImage1];
        }
            break;
            case 1:
        {
            _cellImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kMainBoundsWidth, 116*Proportion)];
            _cellImage2.userInteractionEnabled = YES;
            _cellImage2.backgroundColor = [UIColor clearColor];
            NSURL * ImageUrl2 = [NSURL URLWithString:_coachImage];
            [_cellImage2 sd_setImageWithURL:ImageUrl2 placeholderImage:[UIImage imageNamed:fillimage]];
            [cell.contentView addSubview:_cellImage2];
        }
            break;
            case 2:
        {
            _cellImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kMainBoundsWidth, 116*Proportion)];
            _cellImage3.userInteractionEnabled = YES;
            _cellImage3.backgroundColor = [UIColor clearColor];
            NSURL * ImageUrl3 = [NSURL URLWithString:_matchImage];
            [_cellImage3 sd_setImageWithURL:ImageUrl3 placeholderImage:[UIImage imageNamed:fillimage]];
            [cell.contentView addSubview:_cellImage3];
        }
            break;
        default:
            break;
    }
    
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row==0) {
        
        JLRecommendVenueViewController * RecommendVenueVc = [JLRecommendVenueViewController viewController];
        
        [self.navigationController pushViewController:RecommendVenueVc animated:YES];
        
    }else if (indexPath.row==1)
    {
        NSLog(@"%ld",(long)indexPath.section);
        
        JLCoachListViewController * coachLsitVc = [JLCoachListViewController viewController];
        
        [self.navigationController pushViewController:coachLsitVc animated:YES];
        
        
    }else if(indexPath.row==2)
    {
        [HDHud showMessageInView:self.view title:@"亲，该模块暂时还未开通，请您耐心等待~"];
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.update = YES;
    [self setNavTitle:@"首页"];
    [self setupViews];
 
    
    if ([[Config currentConfig].cityName length]==0) {
        [self.pickerButton setTitle:@"定位中.." forState:UIControlStateNormal];
  
    }else
    {
        [self.pickerButton setTitle:[Config currentConfig].cityName forState:UIControlStateNormal];
    }
    
   [self initLocService];
    
    
  
    
}

-(void)initLocService
{
    
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_locService stopUserLocationService];
    
    NSString * latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    [UserDefaultsUtils saveValue:latitude forKey:@"latitude"];
      [Config currentConfig].latitude = latitude;
    
    
    NSString * longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    [UserDefaultsUtils saveValue:longitude forKey:@"longitude"];
    [Config currentConfig].longitude = longitude;
    
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    
    [self ReverseGeocodeWithlatitude:latitude longitude:longitude];
    

    
    if (latitude&&longitude) {
        
  
        userInfo = [UserInfo sharedUserInfo];
        if (userInfo.isLog) {
        
            [self renewCoordinateWithLatitude:latitude Longitude:longitude];
        }
    }
    
}
-(void)renewCoordinateWithLatitude:(NSString*)latitude Longitude:(NSString*)longitude;
{
    NSLog(@"lat == %@ long = %@",latitude,longitude);
    
    if (!userInfo) {
        userInfo = [UserInfo sharedUserInfo];
    }
    
    NSString * token = userInfo.token;
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",latitude,@"lat",longitude,@"lng", nil];

    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_renewCoordinate pragma:postDict];
    
    request.successBlock = ^(id obj){
        
        [HDHud hideHUDInView:self.view];
     
        _UserDict = obj[0];
        userInfo = [UserInfo sharedUserInfo];
        userInfo.isLog = YES;
        [userInfo LoginWithDictionary:_UserDict];
        
        
        NSLog(@" %@ 更新经纬度后 用户的信息是%@",postDict, obj);
    };
    request.failureDataBlock = ^(id error)
    {
        [HDHud hideHUDInView:self.view];
      //  NSString * message = (NSString *)error;
       // [HDHud showMessageInView:self.view title:message];
    };
    
    request.failureBlock = ^(id obj){
        [HDHud hideHUDInView:self.view];
      //  [HDHud showNetWorkErrorInView:self.view];
    };
    



}


-(void)ReverseGeocodeWithlatitude:(NSString*)latitude longitude:(NSString*)longitude;
{
    isGeoSearch = false;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    if (latitude != nil && longitude != nil) {
        pt = (CLLocationCoordinate2D){[latitude floatValue], [longitude floatValue]};
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    

    
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;
{
    if (error == 0) {
        
        BMKAddressComponent *addressDetail = result.addressDetail;
     
        NSString * city = [NSString stringWithFormat:@"%@",addressDetail.city];
        
        NSString * cityName = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        
        [UserDefaultsUtils saveValue:cityName forKey:@"cityName"];
        [Config currentConfig].cityName = cityName;
        
        [self.pickerButton setTitle:cityName forState:UIControlStateNormal];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.update == YES) {
            [_TableView.header beginRefreshing];
        self.update = NO;
    }
  
}
　
//请求数据
-(void)setupDatas
{
    
   

    HttpRequest * request = [[HttpRequest alloc]init];
    
    [request RequestDataWithUrl:URL_homePage pragma:nil];
    
    
    request.successBlock = ^(id obj){
        
        
        [HDHud hideHUDInView:self.view];
        
        //轮播图数据
       NSArray * adArray = [obj[0] valueForKey:@"carousel"];
        
        _BannerImageArray = [NSMutableArray array];
        
        for (NSDictionary * dict in adArray) {
            NSString * img_url = [dict valueForKey:@"imageUrl"];
            [_BannerImageArray addObject:img_url];
        }
        
        _bannerModelArray  = [StadiumAdModel mj_objectArrayWithKeyValuesArray:adArray];
        
        _BannerArray = [NSMutableArray arrayWithArray:_bannerModelArray];

        
     
        
        //二三四楼数据
        _clubDict = [obj[0] valueForKey:@"club"];
        _coachDict = [obj[0] valueForKey:@"coach"];
        _matchDict  = [obj[0] valueForKey:@"competition"];
        
        _clubImage = [_clubDict valueForKey:@"imageUrl"];
        _coachImage = [_coachDict valueForKey:@"imageUrl"];
        _matchImage = [_matchDict valueForKey:@"imageUrl"];
        
        
        
        _TableView.tableHeaderView = self.BannerView;

        [_TableView.header endRefreshing];
        
        [_TableView reloadData];
    };
    request.failureDataBlock = ^(id error)
    {
        NSString * message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    };
    
    request.failureBlock = ^(id obj){
        
        [HDHud showNetWorkErrorInView:self.view];
    };
    
  
}

-(void)setupViews
{
    [self.Customview addSubview:self.pickerButton];
    [self.RightBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.RightBtn addTarget:self action:@selector(searchBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.TableView];
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

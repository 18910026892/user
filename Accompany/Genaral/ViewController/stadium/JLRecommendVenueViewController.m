//
//  JLRecommendVenueViewController.m
//  Accompany
//
//  Created by GongXin on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLRecommendVenueViewController.h"
#import "JLSearchViewController.h"
#import "StadiumCollectionViewCell.h"
#import "JLVenueDetailViewController.h"
@interface JLRecommendVenueViewController ()

@end

@implementation JLRecommendVenueViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:YES];
    
    if (self.update == YES) {
        [_CollectionView.header beginRefreshing];
        self.update = NO;
    }
    
}
　
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    self.IsScreen = NO;
    self.update = YES;
    [self setupViews];
    [self setNavTitle:@"推荐场馆"];
    [self showBackButton:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"collectStateChange" object:nil];
    
}


//请求数据的方法
-(void)requestDataWithPage:(int)Type
{
   
    
 
    NSString * token = [UserInfo sharedUserInfo].token;
 
  
    NSDictionary * pragmaDict;
    
    if ([token isEqualToString:@""]) {
        pragmaDict = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page", nil];
    }else
    {
        pragmaDict = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page",token,@"token", nil];
        
    }
 
  
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_listByGrssClub pragma:pragmaDict];
    
    
    request.successBlock = ^(id obj){
    
        NSLog(@"**%@",obj);
        _venueArray = obj;
        _venueModelArray = [StadiumCollectionModel mj_objectArrayWithKeyValuesArray:_venueArray];
        
        if (Type == 1) {
              _VenueListArray = [NSMutableArray arrayWithArray:_venueModelArray];
            [_CollectionView.header endRefreshing];
            [_CollectionView reloadData];
            
        }else if(Type == 2){
            
            NSMutableArray * Array = [[NSMutableArray alloc] init];
            [Array addObjectsFromArray:_VenueListArray];
            [Array addObjectsFromArray:_venueModelArray];
            _VenueListArray = Array;
            [_CollectionView.footer endRefreshing];
            [_CollectionView reloadData];
        }
        
        if ([_VenueListArray count]==0) {
            [HDHud showMessageInView:self.view title:@"暂无数据"];
        }else if([_VenueListArray count]>9)
        {
            [_CollectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            [_CollectionView reloadData];
            
        }

        
        
        
        
    };
    request.failureBlock = ^(id obj){
        
        [HDHud showNetWorkErrorInView:self.view];
    };

    
}
-(void)ScreenDataWithPage:(int)Type
{
    
    
//    参数：type（准确查询 不是必填  'Gym','Swimming','FitStudio','DanceStudio' = 健身房 , 游泳房,健身工作室,舞蹈工作室），area（场馆地区 不是必填），clubName（场馆名称 不是必填）
    
    
    NSString * token = [UserInfo sharedUserInfo].token;
    NSString * area = _AreaStr;
    NSString * type;
    if ([_TypeStr isEqualToString:@"健身房"]) {
        type = @"Gym";
    }else if ([_TypeStr isEqualToString:@"健身房"])
    {
        type = @"Swimming";
    }else if ([_TypeStr isEqualToString:@"健身房"])
    {
        type = @"FitStudio";
    }else if ([_TypeStr isEqualToString:@"健身房"])
    {
        type = @"DanceStudio";
    }
    
    
    
    NSDictionary * pragmaDict;
    
    if ([token isEqualToString:@""]) {
        pragmaDict = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page",area,@"area",type,@"type", nil];
    }else
    {
        pragmaDict = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page",token,@"token",area,@"area",type,@"type", nil];
        
    }
    
    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_listByGrssClub pragma:pragmaDict];
    
    
    request.successBlock = ^(id obj){
        
      
        _venueArray = obj;
        _venueModelArray = [StadiumCollectionModel mj_objectArrayWithKeyValuesArray:_venueArray];
        
        if (Type == 1) {
            _VenueListArray = [NSMutableArray arrayWithArray:_venueModelArray];
            [_CollectionView.header endRefreshing];
            [_CollectionView reloadData];
            
        }else if(Type == 2){
            
            NSMutableArray * Array = [[NSMutableArray alloc] init];
            [Array addObjectsFromArray:_VenueListArray];
            [Array addObjectsFromArray:_venueModelArray];
            _VenueListArray = Array;
            [_CollectionView.footer endRefreshing];
            [_CollectionView reloadData];
        }
        
        if ([_VenueListArray count]==0) {
            [HDHud showMessageInView:self.view title:@"暂无数据"];
        }else if([_VenueListArray count]>9)
        {
            [_CollectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            [_CollectionView reloadData];
            
        }
        
        
        
        
        
    };
    request.failureBlock = ^(id obj){
        
        [HDHud showNetWorkErrorInView:self.view];
    };
    
    
}


-(void)setupViews
{
    [self.Customview addSubview:self.SearchBarButton];
    [self.view addSubview:self.ChoiceButton];
    [self.view addSubview:self.CollectionView];
}

-(void)initData
{
    _areaArray = @[@"朝阳区",@"海淀区",@"西城区",@"东城区",@"丰台区",@"石景山区"];
    _categoryArray = @[
                       @[@"健身房",@"游泳房",@"健身工作室",@"舞蹈工作室"],
                        @[@"健身房",@"游泳房",@"健身工作室",@"舞蹈工作室"],
                        @[@"健身房",@"游泳房",@"健身工作室",@"舞蹈工作室"],
                        @[@"健身房",@"游泳房",@"健身工作室",@"舞蹈工作室"],
                       @[@"健身房",@"游泳房",@"健身工作室",@"舞蹈工作室"],
                       @[@"健身房",@"游泳房",@"健身工作室",@"舞蹈工作室"]
                       ];
    _currentAreaArray = _categoryArray[0];
    [self.view addSubview:self.DropMenu];
}

-(UIButton*)SearchBarButton
{
    if (!_SearchBarButton) {
        _SearchBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _SearchBarButton.frame = CGRectMake(kMainBoundsWidth - 70, 20*Proportion, 64, 44);
        _SearchBarButton.backgroundColor = [UIColor clearColor];
        [_SearchBarButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_SearchBarButton addTarget:self action:@selector(searchBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _SearchBarButton;
}

-(void)searchBarButtonClick:(UIButton*)sender

{

    
    JLSearchViewController * SearchVC = [JLSearchViewController viewController];
    SearchVC.searchType = @"0";
    [self.navigationController pushViewController:SearchVC animated:YES];
    
}

-(UIButton*)ChoiceButton
{
    if (!_ChoiceButton) {
        _ChoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ChoiceButton.frame = CGRectMake(0, 64, kMainBoundsWidth, 40);
        
        _ChoiceButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_ChoiceButton setTitle:@"筛选" forState:UIControlStateNormal];
        [_ChoiceButton setImage:[UIImage imageNamed:@"expandableImage"] forState:UIControlStateNormal];
        _ChoiceButton.imageEdgeInsets = UIEdgeInsetsMake(11, 52, 11, 0);
        [_ChoiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ChoiceButton addTarget:self action:@selector(ChoiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_ChoiceButton setImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
        
        _ChoiceButton.imageEdgeInsets = UIEdgeInsetsMake(0, 75, 0, 0);
        
        [_ChoiceButton setTag:1000];
        
    }
    return _ChoiceButton;
    
}

-(void)ChoiceButtonClick:(UIButton*)sender

{
    NSLog(@"choice");
    
    JLDropMenu *menu = (JLDropMenu*)[self.view viewWithTag:1001];
    [UIView animateWithDuration:0.2 animations:^{
        
    } completion:^(BOOL finished) {
        [menu menuTapped];
    }];

}

-(JLDropMenu*)DropMenu
{
    if (!_DropMenu) {
        _DropMenu = [[JLDropMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:300];
        _DropMenu.transformView = _ChoiceButton.imageView;
        _DropMenu.tag = 1001;
        _DropMenu.dataSource = self;
        _DropMenu.delegate = self;
       
    }
    
    return _DropMenu;
}

#pragma mark - FSDropDown datasource & delegate

- (NSInteger)menu:(JLDropMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == menu.LeftTableView) {
        return _areaArray.count;
    }else{
        return _currentAreaArray.count;
    }
}
- (NSString *)menu:(JLDropMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == menu.LeftTableView) {
        
        return _areaArray[indexPath.row];
        
    
        
    }else{
        return _currentAreaArray[indexPath.row];
    }
}


- (void)menu:(JLDropMenu*)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == menu.LeftTableView){
        _currentAreaArray = _categoryArray[indexPath.row];
        
        _AreaStr = _areaArray[indexPath.row];
        
        [menu.RightTableView reloadData];
    }else{
        
        _TypeStr = _currentAreaArray[indexPath.row];
        
        NSString * Condition = [NSString stringWithFormat:@"%@,%@",_AreaStr,_TypeStr];
        
        [self resetItemSizeBy:Condition];
        
        self.IsScreen = YES;
        
         [_CollectionView.header beginRefreshing];
   
    
    }
    
}





-(void)resetItemSizeBy:(NSString*)str{
    
    UIButton *btn = (UIButton*)[self.view viewWithTag:1000];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    NSDictionary *dict = @{NSFontAttributeName:btn.titleLabel.font};
    CGSize size = [str boundingRectWithSize:CGSizeMake(150, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;

   [btn setImage:[UIImage imageNamed:@"redscreen"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(11, size.width+105, 11, 0);
    
    
}

//添加更新控件
-(void)addRefresh
{
    
    [_CollectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [_CollectionView.header setTitle:@"下拉可以刷新了" forState:MJRefreshHeaderStateIdle];
    [_CollectionView.header setTitle:@"松开马上刷新" forState:MJRefreshHeaderStatePulling];
    [_CollectionView.header setTitle:@"正在刷新 ..." forState:MJRefreshHeaderStateRefreshing];
     [_CollectionView.header setTextColor:[UIColor whiteColor]];
    
}
//请求数据
-(void)headerRereshing
{
   _page = @"1";
    
    if (_IsScreen==NO) {
        [self requestDataWithPage:1 ];
    }else if(_IsScreen==YES)
        
    {
        [self ScreenDataWithPage:1];
    }
    
}

//加载更多数据
-(void)loadMoreData
{
    int page = [_page intValue];
    page ++;
    _page = [NSString stringWithFormat:@"%d",page];
    if (_IsScreen==NO) {
        [self requestDataWithPage:2];
    }else if(_IsScreen==YES)
        
    {
        [self ScreenDataWithPage:2];
    }
}

-(UICollectionView*)CollectionView
{
    if (!_CollectionView) {
        //商城分类的集合视图1
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        _CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,104,kMainBoundsWidth,kMainBoundsHeight-104) collectionViewLayout:layout];
        _CollectionView.alwaysBounceVertical = YES;
        _CollectionView.backgroundColor = [UIColor clearColor];
        [_CollectionView registerClass:[StadiumCollectionViewCell class]
            forCellWithReuseIdentifier:@"StadiumCollectionViewCell"];
        _CollectionView.dataSource = self;
        _CollectionView.delegate = self;
        _CollectionView.scrollEnabled = YES;
        _CollectionView.tag = 10001;
        [self addRefresh];

    }
    return _CollectionView;
}
# pragma Collection Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [_VenueListArray count]>0?[_VenueListArray count]:0;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    StadiumCollectionModel * venueModel = [_VenueListArray objectAtIndex:indexPath.item];
    
    StadiumCollectionViewCell * cell = (StadiumCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"StadiumCollectionViewCell" forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
   
    cell.stadiumCollectionModel = venueModel;

    
   
    _VenueImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90*Proportion, 90*Proportion)];
    NSString * venueImageUrl = venueModel.clubImg;
    UIImage * tianchongImage = [UIImage imageNamed:@"venuetianchong"];
    [_VenueImageView sd_setImageWithURL:[NSURL URLWithString:venueImageUrl] placeholderImage:tianchongImage];
    
  
    _VenueTitleLabel = [[UILabel alloc]init];
    _VenueTitleLabel.frame = CGRectMake(0, 90*Proportion, 90*Proportion, 20*Proportion);
    _VenueTitleLabel.textColor = [UIColor whiteColor];
    _VenueTitleLabel.font = [UIFont systemFontOfSize:14.0];
    _VenueTitleLabel.textAlignment = NSTextAlignmentCenter;
    _VenueTitleLabel.text = venueModel.clubName;
    
  
    [cell.contentView addSubview:self.VenueImageView];
    [cell.contentView addSubview:self.VenueTitleLabel];

    
    NSLog(@"%@",venueModel.clubImgs);
    
    return cell;
    
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(90*Proportion,110*Proportion);
    
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,10,5,10);
}
#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.item);
    StadiumCollectionModel * venueModel = [_VenueListArray objectAtIndex:indexPath.item];
    JLVenueDetailViewController * VenueDetailVC = [JLVenueDetailViewController viewController];
    VenueDetailVC.VenueModel = venueModel;
    [self.navigationController pushViewController:VenueDetailVC animated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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

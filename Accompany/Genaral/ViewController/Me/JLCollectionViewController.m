//
//  JLCollectionViewController.m
//  Accompany
//
//  Created by GongXin on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLCollectionViewController.h"
#import "StadiumCollectionViewCell.h"
#import "JLVenueDetailViewController.h"
@interface JLCollectionViewController ()

@end

@implementation JLCollectionViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"collectStateChange" object:nil];
    
    self.update = YES;
    [self setupViews];
    [self setNavTitle:@"我的收藏"];
    [self showBackButton:YES];
    
}
//请求数据
-(void)headerRereshing
{
    _page = @"1";
    [self requestDataWithPage:1];
}

//加载更多数据
-(void)loadMoreData
{
    int page = [_page intValue];
    page ++;
    _page = [NSString stringWithFormat:@"%d",page];
    [self requestDataWithPage:2];
}
-(void)setupViews
{
   
    [self.view addSubview:self.CollectionView];
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


//请求数据的方法
-(void)requestDataWithPage:(int)Type
{
    
    NSString * token = [UserInfo sharedUserInfo].token;
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page",token,@"token", nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_collectClubList pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        NSLog(@"%@",obj);
        
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


-(UICollectionView*)CollectionView
{
    if (!_CollectionView) {
        //商城分类的集合视图1
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        _CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64,kMainBoundsWidth,kMainBoundsHeight-64) collectionViewLayout:layout];
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
    [_VenueImageView sd_setImageWithURL:[NSURL URLWithString:venueImageUrl]];
    
    
    _VenueTitleLabel = [[UILabel alloc]init];
    _VenueTitleLabel.frame = CGRectMake(0, 90*Proportion, 90*Proportion, 20*Proportion);
    _VenueTitleLabel.textColor = [UIColor whiteColor];
    _VenueTitleLabel.font = [UIFont systemFontOfSize:14.0];
    _VenueTitleLabel.textAlignment = NSTextAlignmentCenter;
    _VenueTitleLabel.text = venueModel.clubName;
    
    
    [cell.contentView addSubview:self.VenueImageView];
    [cell.contentView addSubview:self.VenueTitleLabel];
    
    
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

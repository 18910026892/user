//
//  JLVideoCollectViewController.m
//  Accompany
//
//  Created by 王园园 on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLVideoCollectViewController.h"
#import "JLVideoCollectCell.h"
#import "JLVideoItemModel.h"
#import "JLVideoPlayerViewController.h"
@interface JLVideoCollectViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,JLVideoCollectCellDelegate>

@property(nonatomic,strong)UICollectionView * CollectionView;
@property(nonatomic,strong)NSArray *DataList;
@property(nonatomic,strong)NSMutableArray *selectDataList;
@property(nonatomic,strong)NSMutableDictionary *selectDataDict;
@end

@implementation JLVideoCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:_videoModel.name];
    [self setupViews];
    [_CollectionView.header beginRefreshing];
    [self showBackButton:YES];
}

-(void)setupViews
{
    [self.view addSubview:self.CollectionView];
    if(_isHandelOrder){
        
        _selectDataDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"HANDELSUBJECT"] ];
        _selectDataList = [NSMutableArray arrayWithArray:[_selectDataDict valueForKey:_categoryName]];
        [self.RightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.RightBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setupDatas
{
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:_videoModel.catId,@"catId", nil];
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_VideoList pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSLog(@"--%@",response);
        _DataList = [JLVideoItemModel mj_objectArrayWithKeyValuesArray:response];
        [_CollectionView reloadData];
        [_CollectionView.header endRefreshing];
        if(_DataList.count==0){
            [_CollectionView.footer noticeNoData];
        }
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
        [_CollectionView.header endRefreshing];
    } Failure:^(id error) {
        [_CollectionView.header endRefreshing];
        [HDHud showNetWorkErrorInView:self.view];
    }];

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
//更新数据
-(void)headerRereshing
{
    [self setupDatas];
}
-(UICollectionView*)CollectionView
{
    if (!_CollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        _CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64,kMainBoundsWidth,kMainBoundsHeight-64) collectionViewLayout:layout];
        _CollectionView.alwaysBounceVertical = YES;
        _CollectionView.backgroundColor = [UIColor clearColor];
        [_CollectionView registerNib:[UINib nibWithNibName:@"JLVideoCollectCell" bundle:nil]
            forCellWithReuseIdentifier:@"JLVideoCollectCell"];
        _CollectionView.dataSource = self;
        _CollectionView.delegate = self;
        _CollectionView.scrollEnabled = YES;
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
    return [_DataList count];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    JLVideoCollectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLVideoCollectCell" forIndexPath:indexPath];
    if(_isHandelOrder){
        cell.delegate = self;
        cell.isHandel = YES;
        cell.selectItem = _selectDataList;
    }
    [cell fillCellWithObject:_DataList[indexPath.item]];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(145*Proportion,100*Proportion);
    
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8,10,8,10);
}
#pragma mark --UICollectionViewDelegate

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.item);
    JLVideoPlayerViewController *playerVC = [[JLVideoPlayerViewController alloc]initWithNibName:@"JLVideoPlayerViewController" bundle:nil];
    playerVC.videosList = _DataList;
    playerVC.currentIndex = indexPath.item;
    playerVC.movieModel = _DataList[indexPath.item];
    [self presentViewController:playerVC animated:YES completion:nil];
}

#pragma mark- JLVideoCollectCellDelegate
-(void)videoCell:(JLVideoCollectCell *)cell selectVideoModel:(JLVideoItemModel *)model;
{
    NSArray *selectData = [NSArray arrayWithArray:_selectDataList];
    __block NSInteger found = 0;
    [selectData enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([model.videoId isEqualToString:obj[@"id"]]){
            found = 1;
            [_selectDataList removeObjectAtIndex:idx];
        }
    }];
    if (found==0){
        [_selectDataList addObject:[model mj_keyValues]];
    }
}

-(void)sureBtnClick:(id)sender
{
    if(_selectDataList.count>0){
        [_selectDataDict setObject:_selectDataList forKey:_categoryName];
    }else{
        [_selectDataDict removeObjectForKey:_categoryName];
    }
    [[NSUserDefaults standardUserDefaults]setObject:_selectDataDict forKey:@"HANDELSUBJECT"];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

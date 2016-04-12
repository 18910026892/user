//
//  JLSearchVenueResultViewController.h
//  Accompany
//
//  Created by GongXin on 16/2/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "StadiumCollectionModel.h"
@interface JLSearchVenueResultViewController : BaseViewController
<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)UICollectionView * CollectionView;

@property (nonatomic,strong)UIImageView * VenueImageView;

@property (nonatomic,strong)UILabel * VenueTitleLabel;


//场馆列表数组
@property(nonatomic,strong)NSMutableArray * venueArray;
@property(nonatomic,strong)NSMutableArray * venueModelArray;
@property(nonatomic,strong)NSMutableArray * VenueListArray;

//是否刷新的标志
@property(nonatomic,assign)BOOL update;

//页面参数
@property (nonatomic,copy)NSString * page;
@property (nonatomic,copy)NSString * keyword;



@end

//
//  JLCollectionViewController.h
//  Accompany
//
//  Created by GongXin on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"

@interface JLCollectionViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>

{
    UserInfo * userInfo;
}
@property(nonatomic,strong)UICollectionView * CollectionView;

//是否刷新的标志
@property(nonatomic,assign)BOOL update;

//页面参数
@property (nonatomic,copy)NSString * page;

@property (nonatomic,strong)UIImageView * VenueImageView;

@property (nonatomic,strong)UILabel * VenueTitleLabel;

//场馆列表数组

@property(nonatomic,strong)NSMutableArray * venueArray;
@property(nonatomic,strong)NSMutableArray * venueModelArray;
@property(nonatomic,strong)NSMutableArray * VenueListArray;



@end

//
//  JLRecommendVenueViewController.h
//  Accompany
//
//  Created by GongXin on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "JLDropMenu.h"
#import "Config.h"
#import "StadiumCollectionModel.h"
@interface JLRecommendVenueViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,JLDropDownMenuDataSource,JLDropDownMenuDelegate>
{
    UserInfo * userInfo;
}
//搜索按钮
@property (nonatomic,strong)UIButton * SearchBarButton;

@property(nonatomic,strong)UICollectionView * CollectionView;


@property (nonatomic,strong)UIImageView * VenueImageView;

@property (nonatomic,strong)UILabel * VenueTitleLabel;


@property(nonatomic,strong)UIButton * ChoiceButton;
@property(nonatomic,strong)JLDropMenu * DropMenu;

@property(nonatomic,strong) NSArray *areaArray;
@property(nonatomic,strong) NSArray * categoryArray;
@property(nonatomic,strong) NSArray *currentAreaArray;

@property(nonatomic,copy)NSString * AreaStr;
@property(nonatomic,copy)NSString * TypeStr;

//场馆列表数组

@property(nonatomic,strong)NSMutableArray * venueArray;
@property(nonatomic,strong)NSMutableArray * venueModelArray;
@property(nonatomic,strong)NSMutableArray * VenueListArray;


//是否刷新的标志
@property(nonatomic,assign)BOOL update;

//页面参数
@property (nonatomic,copy)NSString * page;

//是否筛选
@property BOOL IsScreen;



@end

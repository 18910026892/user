//
//  JLStadiumViewController.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "CCAdsPlayView.h"
#import "PickerButton.h"
#import "StadiumAdModel.h"
#import <UIImageView+WebCache.h>
#import "Config.h"
@interface JLStadiumViewController : BaseViewController<PickerButtonDelegate,UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService * _locService;
    
    BMKGeoCodeSearch * _geocodesearch;
    
    bool isGeoSearch;
   
    UserInfo * userInfo;
}
//城市列表数组
@property(nonatomic,strong)NSArray * CityArray;

//广告数组的元素
@property (nonatomic,strong)StadiumAdModel * StadiumAdModel;

@property (nonatomic,strong)PickerButton * pickerButton;

@property (nonatomic,strong)UITableView * TableView;

@property (nonatomic,strong)CCAdsPlayView * BannerView;

@property (nonatomic,strong)UIImageView * cellImage1;
@property (nonatomic,strong)UIImageView * cellImage2;
@property (nonatomic,strong)UIImageView * cellImage3;

//data

@property (nonatomic,copy)NSString * cityName;

//是否刷新的标志
@property(nonatomic,assign)BOOL update;


//广告数组
@property (nonatomic,strong)NSMutableArray * BannerArray;

@property (nonatomic,strong)NSMutableArray * BannerImageArray;

@property (nonatomic,strong)NSArray * bannerModelArray;



@property (nonatomic,strong)NSMutableDictionary * clubDict;
@property (nonatomic,strong)NSMutableDictionary * coachDict;
@property (nonatomic,strong)NSMutableDictionary * matchDict;

@property(nonatomic,copy)NSString * clubImage;
@property(nonatomic,copy)NSString * coachImage;
@property(nonatomic,copy)NSString * matchImage;

@property (nonatomic,copy)NSMutableDictionary * UserDict;



@end

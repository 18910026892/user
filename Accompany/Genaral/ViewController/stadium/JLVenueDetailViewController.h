//
//  JLVenueDetailViewController.h
//  Accompany
//
//  Created by GongXin on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StadiumCollectionModel.h"
#import <DZNSegmentedControl.h>
#import <UIScrollView+VGParallaxHeader.h>
#import "CoachListTableViewCell.h"
#import "CocahModel.h"
@interface JLVenueDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,DZNSegmentedControlDelegate,UIAlertViewDelegate>
{
    UserInfo * userInfo;
}
@property (strong,nonatomic)StadiumCollectionModel * VenueModel;

@property (nonatomic,strong)NSString * ISCollection;

@property (nonatomic,strong)UITableView * TableView;

@property (nonatomic,strong)UIImageView * HeaderImageView;

@property(nonatomic,strong)UIButton * BackButton;

@property (nonatomic,strong)UIButton * CollectionButton;

@property (nonatomic,strong)UILabel * VenueNameLabel;

@property (nonatomic,strong)UILabel * cellTitle;

@property (nonatomic,strong)UILabel * cellContent;

@property (nonatomic,strong)UIImageView * cellImageView;

@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, strong) NSArray *menuItems;
@property(nonatomic,strong)UILabel * lineLabel;
@property (nonatomic)NSInteger selectIndex;




//场馆图片数组
@property (nonatomic,strong)NSMutableArray * PhotoArray;

//场馆教练
@property (nonatomic,strong)NSString * coachName;
@property (nonatomic,strong)NSString * coachDesc;

@property (nonatomic,copy)NSString * page;
@property (nonatomic,strong)NSMutableArray * coachArray;
@property (nonatomic,strong)NSMutableArray * coachModelArray;
@property (nonatomic,strong)NSMutableArray * coachListArray;


@end

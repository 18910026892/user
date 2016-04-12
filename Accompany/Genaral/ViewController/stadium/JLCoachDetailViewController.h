//
//  JLCoachDetailViewController.h
//  Accompany
//
//  Created by 巩鑫 on 16/2/6.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "CoachDetailHeader.h"
#import "DJQRateView.h"
#import <DZNSegmentedControl.h>
#import <UIScrollView+VGParallaxHeader.h>
#import "CocahModel.h"
#import <UMSocial.h>
#import <UMSocialQQHandler.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialSinaSSOHandler.h>
#import "JLPostListModel.h"

@class JLCoachDetailViewController;
@class JLPostListModel;

@protocol CoachDetailVCDelegate <NSObject>

//评论
-(void)starLeverVCcommentBtn:(UIButton *)commentBtn clickedWithData:(JLPostListModel *)celldata;
@end

@interface JLCoachDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CoachDetailHeaderDelegate,DZNSegmentedControlDelegate,UMSocialDataDelegate,UMSocialUIDelegate>

{
    UserInfo * userInfo;
}

@property(nonatomic,strong) id<CoachDetailVCDelegate>delegate;



@property (nonatomic,strong)CocahModel * coachModel;

@property(nonatomic,strong)UILabel * lineLabel;
@property (nonatomic, strong) DZNSegmentedControl *control;

@property (nonatomic)NSInteger selectIndex;

@property (nonatomic,strong)UITableView * TableView;

@property (nonatomic,strong)CoachDetailHeader * Header;

@property (nonatomic,strong)UIImageView * PhotoImageView;

@property (nonatomic,strong)UIButton * BuyClassButtonButton;


@property (nonatomic,strong)UILabel * NickNameLabel;

@property (nonatomic,strong)UILabel * InfoLabel;

@property (nonatomic,strong)DJQRateView * starView;

@property (nonatomic,strong)UILabel * cellTitle;

@property (nonatomic,strong)UILabel * cellContent;

@property(nonatomic,strong)UILabel * DowncellLine;

@property (nonatomic,strong)UILabel * sectionTitle;

@property (nonatomic,strong)UIView * FooterView;

@property (nonatomic,strong)UIButton * ShareButton;

@property (nonatomic,strong)UIButton * ChatButton;

@property (nonatomic,strong)UIButton * BlackListButton;



//DATA
@property (nonatomic, strong) NSArray *menuItems;

@property(nonatomic,strong)NSMutableArray *tableArray;

@property (nonatomic,strong)NSMutableArray * dynamicArray;

@property (nonatomic,strong)NSMutableArray * commentArray;

@property (nonatomic,copy)NSString * shareUrl;

@property (nonatomic,assign) BOOL privateChat;

@end

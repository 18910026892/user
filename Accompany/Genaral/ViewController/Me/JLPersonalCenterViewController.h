//
//  JLPersonalCenterViewController.h
//  Accompany
//
//  Created by GongXin on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "JLPersonalCenterHeader.h"
#import "DJQRateView.h"
#import "JLPostUserInfoModel.h"
#import <UIScrollView+VGParallaxHeader.h>
#import <UMSocial.h>
#import <UMSocialQQHandler.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialSinaSSOHandler.h>
#import "JLPostListModel.h"

@class JLPersonalCenterViewController;
@class JLPostListModel;

@protocol PersonalCenterVCDelegate <NSObject>


//评论
-(void)starLeverVCcommentBtn:(UIButton *)commentBtn clickedWithData:(JLPostListModel *)celldata;
@end


@interface JLPersonalCenterViewController : BaseViewController<PersonalCenterHeadeViewDelegate,UITableViewDataSource,UITableViewDelegate,UMSocialDataDelegate,UMSocialUIDelegate>

{
    UserInfo * userInfo;
}
@property(nonatomic,strong) id<PersonalCenterVCDelegate>delegate;

@property (nonatomic,strong)JLPostUserInfoModel * userModel;

@property (nonatomic,strong)UITableView * TableView;

@property (nonatomic,strong)JLPersonalCenterHeader * Header;

@property (nonatomic,strong)UIImageView * PhotoImageView;

@property (nonatomic,strong)UIButton * AttentionButton;

@property (nonatomic,strong)UIButton * FansButton;

@property (nonatomic,strong)UILabel * NickNameLabel;

@property (nonatomic,strong)UILabel * InfoLabel;



@property (nonatomic,strong)DJQRateView * starView;

@property (nonatomic,strong)UILabel * cellTitle;

@property (nonatomic,strong)UILabel * cellContent;

@property(nonatomic,strong)UILabel * DowncellLine;

@property (nonatomic,strong)UIView * FooterView;

@property (nonatomic,strong)UIButton * ShareButton;

@property (nonatomic,strong)UIButton * ChatButton;

@property (nonatomic,strong)UIButton * BlackListButton;


//DATA
@property (nonatomic,strong)NSMutableArray * dynamicArray;

@property (nonatomic,copy)NSString * shareUrl;

@property (nonatomic,assign) BOOL privateChat;


@property (nonatomic,copy) NSString * attentionTitle;


@property (nonatomic,copy)NSString * pushFlag;

@end

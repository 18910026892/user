//
//  JLMeViewController.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginHeaderView.h"
#import <UIScrollView+VGParallaxHeader.h>
@interface JLMeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,LoginHeaderViewDelegate>
{
    UserInfo * userInfo;
}
@property(nonatomic,strong)UITableView * TableView;

@property(nonatomic,strong)LoginHeaderView * LoginHeaderView;

@property (nonatomic,strong)UIImageView * cellImageView;

@property (nonatomic,strong)UILabel * cellTitle;


@property(nonatomic,strong)UILabel * UPcellLine;

@property(nonatomic,strong)UILabel * DowncellLine;


//DATA

@property (nonatomic,copy)NSString * attentionCount;

@property (nonatomic,copy)NSString * fansCount;



@end

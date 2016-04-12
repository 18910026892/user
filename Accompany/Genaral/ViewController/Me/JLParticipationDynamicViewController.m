//
//  JLParticipationDynamicViewController.m
//  Accompany
//
//  Created by GongXin on 16/3/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLParticipationDynamicViewController.h"
#import "JLPostDetailViewController.h"
#import "JLCommunityInfoViewController.h"
#import "JLPostListModel.h"
#import "JLStarLevelViewController.h"

@interface JLParticipationDynamicViewController ()<StarLevelVCDelegate>

@property(nonatomic,strong)JLStarLevelViewController *postVC;


@end
@implementation JLParticipationDynamicViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"我参与的动态"];
    [self setTabBarHide:YES];
    [self showBackButton:YES];
    //[self setupDatas];
    [self setupViews];
}

-(void)setupViews
{
    _postVC = [[JLStarLevelViewController alloc]init];
    _postVC.type = InvolvementPosts;
    _postVC.view.frame = CGRectMake(0,64, kMainBoundsWidth, kMainBoundsHeight);
    _postVC.delegate = self;
    [self.view addSubview:_postVC.view];
}



#pragma mark - StarLevelVCDelegate
-(void)starLevelViewController:(JLStarLevelViewController *)commVC didSelectData:(id)communityData;
{
    JLPostDetailViewController *postDetailVC = [[JLPostDetailViewController alloc]init];
    postDetailVC.postInfoModel = (JLPostListModel *)communityData;
    [self.navigationController pushViewController:postDetailVC animated:YES];
}

//评论
-(void)starLeverVCcommentBtn:(UIButton *)commentBtn clickedWithData:(JLPostListModel *)celldata;
{
    JLPostDetailViewController *detail = [[JLPostDetailViewController alloc]init];
    detail.postInfoModel = celldata;
    detail.isCommentSate = YES;
    [self.navigationController pushViewController:detail animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

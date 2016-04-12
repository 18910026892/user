//
//  JLPostListViewController.m
//  Accompany
//
//  Created by 王园园 on 16/2/19.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLPostListViewController.h"
#import "JLPublicViewController.h"
#import "JLPostDetailViewController.h"
#import "JLCommunityInfoViewController.h"
#import "JLPostListModel.h"
#import "JLStarLevelViewController.h"
#import "JLPersonalCenterViewController.h"
@interface JLPostListViewController ()<StarLevelVCDelegate>


@property(nonatomic,strong)JLStarLevelViewController *postVC;

@end

@implementation JLPostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setNavTitle:@"建外社区"];
    
    [self setTabBarHide:YES];
    [self showBackButton:YES];
    //[self setupDatas];
    [self setupViews];
}

-(void)setupViews
{
    [self setNavTitle:_communityName];
    [self.RightBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [self.RightBtn addTarget:self action:@selector(AddBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.RightBtn setTitleColor:kTabBarItemSelectColor forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleViewClick:)];
    self.titleLabel.userInteractionEnabled = YES;
    [self.titleLabel addGestureRecognizer:tap];
    
    UILabel *arowLable = [UILabel labelWithFrame:CGRectMake(kMainBoundsWidth/2+40, 34, 30, 20) text:@"▼" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13.0] backgroundColor:[UIColor clearColor]];
    arowLable.left = kMainBoundsWidth/2+_communityName.length*10;
    if(_communityName.length>=7){
        arowLable.left = self.titleLabel.right;
    }
    [self.view addSubview:arowLable];
    
    _postVC = [[JLStarLevelViewController alloc]init];
    _postVC.type = PostCommunity;
    _postVC.communityId = _communityId;
    _postVC.view.frame = CGRectMake(0,64, kMainBoundsWidth, kMainBoundsHeight);
    _postVC.delegate = self;
    [self.view addSubview:_postVC.view];
}

-(void)AddBtnClick
{
    JLPublicViewController *publicVC = [JLPublicViewController viewController];
    publicVC.communityId = _communityId;
    [self.navigationController pushViewController:publicVC animated:YES];
}


-(void)titleViewClick:(UIGestureRecognizer *)gesture
{
    JLCommunityInfoViewController *infoVC = [JLCommunityInfoViewController viewController];
    infoVC.comId = _communityId;
    [self.navigationController pushViewController:infoVC animated:YES];
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

-(void)starPostCell:(JLPostListCell *)cell userImageTapWithData:(id)celldata;
{
    JLPostListModel *model = (JLPostListModel *)celldata;
    JLPersonalCenterViewController *vc = [JLPersonalCenterViewController viewController];
    vc.userModel = model.grssUser;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

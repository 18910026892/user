//
//  JLCommunityViewContrller.m
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLCommunityViewContrller.h"
#import "JLSegmentView.h"
#import "JLComDetailViewController.h"
#import "JLStarLevelViewController.h"
#import "JLCreateViewController.h"
#import "JLMyCommunitysViewController.h"
#import "JLAddCommunityViewController.h"
#import "JLPublicViewController.h"
#import "JLPostListViewController.h"
#import "JLPostDetailViewController.h"
#import "JLMyCommunityModel.h"
#import "JLPersonalCenterViewController.h"
const static CGFloat headerHeight = 44.0f;
static NSString *segOneTitle = @"社区";
static NSString *segTwoTitle = @"星级";
static NSString *segThreeTitle = @"关注";
@interface JLCommunityViewContrller ()<UIScrollViewDelegate,ComDetailVCDelegate,StarLevelVCDelegate>

@property(nonatomic,strong)JLComDetailViewController *commuVC;
@property(nonatomic,strong)JLStarLevelViewController *starVC;
@property(nonatomic,strong)JLStarLevelViewController *attentVC;
@property(nonatomic,strong)UIView *menuView;
/**
 *  顶部SegView
 */
@property (nonatomic, strong) JLSegmentView *headerSegView;
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation JLCommunityViewContrller

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarHide:NO];
    [self setupViews];
    [self setupDatas];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self setMenuViewShow:NO];
}
-(void)setupViews
{
    [self.view addSubview:self.headerSegView];
    [self.view addSubview:self.scrollView];
    [self.RightBtn setImage:[UIImage imageNamed:@"post_more"] forState:UIControlStateNormal];
    [self.RightBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (JLSegmentView *)headerSegView
{
    if(!_headerSegView){
        float margin = 60;
        _headerSegView = [[JLSegmentView alloc]initWithFrame:CGRectMake(margin,20, kMainBoundsWidth-margin*2, headerHeight)];
        _headerSegView.backgroundColor = [UIColor clearColor];
        [_headerSegView setTitleArr:@[segOneTitle,segTwoTitle,segThreeTitle] OneItemWidth:(kMainBoundsWidth-margin*2)/3 TitleFont:[UIFont boldSystemFontOfSize:15.]];
        _headerSegView.sliderWidth = 50;
        //点击切换
        __weak JLCommunityViewContrller *vc = self;
        _headerSegView.SegmentSelectedItemIndex = ^(NSInteger index){
            _headerIndex = index;
            [vc.scrollView setContentOffset:CGPointMake(vc.scrollView.width*index,0) animated:YES];
            [vc.headerSegView SegmentChangeWithScrollView:vc.scrollView contentOffset:vc.scrollView.contentOffset.x];
        };
    }
    return _headerSegView;
}


- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsWidth, kMainScreenHeight-64)];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kMainBoundsWidth*3, _scrollView.height);
        [self setChildViewController];
    }
    return _scrollView;
}


-(void)setChildViewController
{
    _commuVC = [[JLComDetailViewController alloc]init];
    _commuVC.view.frame = CGRectMake(0,0, kMainBoundsWidth, kMainBoundsHeight-64-49);
    _commuVC.delegate = self;
    [_scrollView addSubview:_commuVC.view];
    
    _starVC = [[JLStarLevelViewController alloc]init];
    _starVC.type = StarCommunity;
    _starVC.view.frame = CGRectMake(kMainBoundsWidth,0, kMainBoundsWidth, kMainBoundsHeight-64-49);
    _starVC.delegate = self;
    [_scrollView addSubview:_starVC.view];
    
    _attentVC = [[JLStarLevelViewController alloc]init];
    _attentVC.type = AttentionCommunity;
    _attentVC.view.frame = CGRectMake(kMainBoundsWidth*2,0, kMainBoundsWidth, kMainBoundsHeight-64-49);
    _attentVC.delegate = self;
    [_scrollView addSubview:_attentVC.view];
    
}

-(void)setHeaderIndex:(NSInteger)headerIndex
{
    [_headerSegView itemSelectIndex:headerIndex];
    [_headerSegView SegmentChangeWithScrollView:_scrollView contentOffset:_scrollView.contentOffset.x];
}


#pragma mark - delegate & response
/**
 *  scrollview滚动
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    float page = _scrollView.contentOffset.x/_scrollView.width;
    if(page-(int)page==0){
        _headerIndex= (int)page;
        [_headerSegView itemSelectIndex:page];
    }else{
        [_headerSegView SegmentChangeWithScrollView:scrollView contentOffset:_scrollView.contentOffset.x];
    }
}


-(void)setMenuViewShow:(BOOL)state
{
    [self setUpMenuView];
    [UIView animateWithDuration:0.2 animations:^{
        if(state==YES){
            _menuView.frame = CGRectMake(kMainBoundsWidth-130-10, 58, 130, 90);
            _menuView.alpha = 1.0;
        }else{
            _menuView.frame = CGRectMake(kMainBoundsWidth-140, 58, 110,0);
            _menuView.alpha = 0;
        }
    }];
}

-(void)setUpMenuView
{
    if(!_menuView){
        _menuView = [[UIView alloc]initWithFrame:CGRectMake(kMainBoundsWidth-130-10, 58,130,90)];
        _menuView.userInteractionEnabled = YES;
        _menuView.clipsToBounds = YES;
        _menuView.backgroundColor = [UIColor clearColor];
        _menuView.alpha = 0;
        [self.view addSubview:_menuView];
        
        UIImageView *backImage = [[UIImageView alloc]initWithFrame:_menuView.bounds];
        UIImage* img=[UIImage imageNamed:@"arowmenu"];
        UIEdgeInsets edge=UIEdgeInsetsMake(40, 0,40,0);
        img= [img resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
        backImage.image = img;
        [_menuView addSubview:backImage];
        
        NSArray *btnTitleArr = @[@"发布动态",@"搜索社区"];
        NSArray *imgArr = @[@"publicCom",@"searchCom"];
        float b_whith = _menuView.width;
        for(int i=0;i<2;i++){
            UIButton *btn = [UIButton buttonWithFrame:CGRectMake(0,42*i+6, b_whith, 42) title:btnTitleArr[i] titleColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:13.0] backgroundColor:[UIColor clearColor]];
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(8, 15, 8, 75)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,15, 0,0)];
            [btn addTarget:self action:@selector(MenuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_menuView addSubview:btn];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 48, _menuView.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_menuView addSubview:line];
    }
}

-(void)moreBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self setMenuViewShow:btn.selected];
}
-(void)MenuBtnClick:(UIButton *)btn
{
    self.RightBtn.selected = !self.RightBtn.selected;
    [self setMenuViewShow:self.RightBtn.selected];
    NSLog(@"menuBtn%ld",(long)btn.tag);
    if(btn.tag==0){
        JLPublicViewController *publicVC = [[JLPublicViewController alloc]initWithNibName:@"JLPublicViewController" bundle:nil];
        [self.navigationController pushViewController:publicVC animated:YES];
    }else{
        [self.navigationController pushViewController:[JLAddCommunityViewController viewController] animated:YES];
    }
}

#pragma mark -
#pragma mark - ComDetailVCDelegate
-(void)comDetailViewController:(JLComDetailViewController *)commVC clickTopBtnTag:(NSInteger)btnTag;
{
    NSLog(@"%ld",(long)btnTag);
    if(btnTag==0){
        JLMyCommunitysViewController *mycomVC = [JLMyCommunitysViewController viewController];
        mycomVC.type = MyCommunity;
        [self.navigationController pushViewController:mycomVC animated:YES];
    }else if (btnTag==1){
        JLCreateViewController *creatVC = [[JLCreateViewController alloc]initWithNibName:@"JLCreateViewController" bundle:nil];
        [self.navigationController pushViewController:creatVC animated:YES];
    }
}
-(void)comDetailViewControllerMoreRecommentClick;
{
    JLMyCommunitysViewController *recmentVC = [[JLMyCommunitysViewController alloc]init];
    recmentVC.type = RecommendCommunity;
    [self.navigationController pushViewController:recmentVC animated:YES];
}

-(void)comDetailViewController:(JLComDetailViewController *)commVC recommendtionSelectData:(id)communityData;
{
    JLMyCommunityModel *model = (JLMyCommunityModel *)communityData;
    //推荐社区进入
    JLPostListViewController *listVC = [[JLPostListViewController alloc]init];
    listVC.communityId = model.communityId;
    listVC.communityName = model.name;
    [self.navigationController pushViewController:listVC animated:YES];
}
-(void)comDetailViewController:(JLComDetailViewController *)commVC didSelectData:(id)communityData;
{
    JLPostDetailViewController *postDetailVC = [[JLPostDetailViewController alloc]init];
    postDetailVC.postInfoModel = (JLPostListModel *)communityData;
    [self.navigationController pushViewController:postDetailVC animated:YES];
}
//评论
-(void)comDetailVCcommentBtn:(UIButton *)commentBtn clickedWithData:(JLPostListModel *)celldata;
{
    JLPostDetailViewController *detail = [[JLPostDetailViewController alloc]init];
    detail.postInfoModel = celldata;
    detail.isCommentSate = YES;
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)comPostCell:(JLPostListCell *)cell userImageTapWithData:(id)celldata;
{
    JLPostListModel *model = (JLPostListModel *)celldata;
    JLPersonalCenterViewController *vc = [JLPersonalCenterViewController viewController];
    vc.userModel = model.grssUser;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - StarLevelVCDelegate
//星级/关注StarLevelVCDelegate
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

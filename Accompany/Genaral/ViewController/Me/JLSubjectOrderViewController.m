//
//  JLSubjectOrderViewController.m
//  Accompany
//
//  Created by 王园园 on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLSubjectOrderViewController.h"
#import "JLSegmentView.h"
#import "JLSubjectListCell.h"
#import "JLSubjectDetailViewController.h"
#import "JLWaitHandleViewController.h"
const static CGFloat headerHeight = 45.0f;

static NSString *segOneTitle = @"待处理";
static NSString *segTwoTitle = @"已处理";
@interface JLSubjectOrderViewController ()<UIScrollViewDelegate,SubjectDetailVCDelegate>

/**
 *  顶部SegView
 */
@property (nonatomic, strong) JLSegmentView *headerSegView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JLSubjectDetailViewController *waitVC;
@property (nonatomic, strong) JLSubjectDetailViewController *handelVC;
@end

@implementation JLSubjectOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setTabBarHide:YES];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"课程订单"];
    [self setTabBarHide:YES];
    [self showBackButton:YES];
    [self setupViews];
    [self setupDatas];
}

-(void)setupViews
{
    [self.view addSubview:self.headerSegView];
    [self.view addSubview:self.scrollView];
    
}

-(void)setupDatas
{

}


#pragma mark -

#pragma mark - getter & setter

- (JLSegmentView *)headerSegView
{
    if(!_headerSegView){
        _headerSegView = [[JLSegmentView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsWidth, headerHeight)];
        _headerSegView.backgroundColor = [UIColor blackColor];
        [_headerSegView setTitleArr:@[segOneTitle,segTwoTitle] OneItemWidth:kMainBoundsWidth/2 TitleFont:[UIFont systemFontOfSize:14.]];
        _headerSegView.sliderWidth = 80;
        //点击切换
        __weak JLSubjectOrderViewController *vc = self;
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
        CGFloat height =  (kMainBoundsHeight - 64.0f - headerHeight);
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, headerHeight+64, kMainBoundsWidth, height)];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kMainBoundsWidth*2, _scrollView.height);
        [self addChildViews];
    }
    return _scrollView;
}

-(void)addChildViews
{
    _waitVC = [[JLSubjectDetailViewController alloc]init];
    _waitVC.isHandelType = NO;
    _waitVC.view.frame = CGRectMake(0,-35, kMainBoundsWidth, kMainBoundsHeight-64);
    _waitVC.delegate = self;
    [_scrollView addSubview:_waitVC.view];
    
    _handelVC = [[JLSubjectDetailViewController alloc]init];
    _handelVC.isHandelType = YES;
    _handelVC.view.frame = CGRectMake(kMainBoundsWidth,-35, kMainBoundsWidth, kMainBoundsHeight-64);
    _handelVC.delegate = self;
    [_scrollView addSubview:_handelVC.view];
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

#pragma SubjectDetailVCDelegate

-(void)subjectDetailVC:(JLSubjectDetailViewController *)viewcontroller CellData:(JLOrderModel *)model;
{
    JLWaitHandleViewController *waitVC = [[JLWaitHandleViewController alloc]initWithNibName:@"JLWaitHandleViewController" bundle:nil];
    waitVC.infoModel = model;
    [self.navigationController pushViewController:waitVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

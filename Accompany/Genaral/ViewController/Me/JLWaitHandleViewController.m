//
//  JLWaitHandleViewController.m
//  Accompany
//
//  Created by 王园园 on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLWaitHandleViewController.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "JLVideoViewController.h"

@interface JLWaitHandleViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *backScroll;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *sexlable;
@property (weak, nonatomic) IBOutlet UILabel *healthResultLable;

@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UILabel *beizhuLable;
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;

@property(nonatomic,strong)UIView *detailInfoView;

@property(nonatomic,strong)NSArray *imgUrlArr;

@property(nonatomic,strong)NSArray *titlesArr;
@property(nonatomic,strong)NSArray *urlNamesArr;

- (IBAction)handleOrderClick:(id)sender;

@end

@implementation JLWaitHandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTabBarHide:YES];
    [self showBackButton:YES];
    // Do any additional setup after loading the view.
    [self setupViews];
    _titlesArr = @[@"年龄",@"性别",@"身高",@"体重",@"体质量指数",@"腰围",@"臀围",@"腰臀比例",@"身体脂肪",@"基础代谢率",@"静态心率",@"血压收缩压"];
    [self setupDatas];
}


-(void)setupViews
{
    if(_infoModel.state.integerValue==1){
        [self setNavTitle:@"待处理"];
        _handleBtn.clipsToBounds = YES;
        _handleBtn.layer.cornerRadius = 20.;
    }else{
        [self setNavTitle:@"已处理"];
        _handleBtn.hidden = YES;
    }
    _userImgView.layer.cornerRadius = _userImgView.height/2;
    _userImgView.layer.borderWidth = 0.8;
    _userImgView.layer.borderColor = [UIColor grayColor].CGColor;
    _userImgView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_imgView1 addGestureRecognizer:tap1];
    [_imgView2 addGestureRecognizer:tap2];
    [_imgView3 addGestureRecognizer:tap3];
    
    _backScroll.contentSize = CGSizeMake(0, _handleBtn.bottom+30);
}

-(void)setupDatas
{
    [_userImgView sd_setImageWithURL:[NSURL URLWithString:_infoModel.grssUser.userPhoto] placeholderImage:[UIImage imageNamed:@"morentou-"]];
   _sexlable.text = [_infoModel.orderDate  substringToIndex:10];
    //_sexlable.text = _infoModel.grssUser.userSex;
    _healthResultLable.text = [Helper isBlankString: _infoModel.userComment]?@"暂无":_infoModel.userComment;
    
    [_imgView1 sd_setImageWithURL:[NSURL URLWithString:_infoModel.userEx.frontImageUrl] placeholderImage:[UIImage imageNamed:@"changguan-"]];
    _imgView1.tag = 0;
    [_imgView2 sd_setImageWithURL:[NSURL URLWithString:_infoModel.userEx.sideImageUrl] placeholderImage:[UIImage imageNamed:@"changguan-"]];
    _imgView2.tag = 1;
    [_imgView3 sd_setImageWithURL:[NSURL URLWithString:_infoModel.userEx.rearImageUrl] placeholderImage:[UIImage imageNamed:@"changguan-"]];
    _imgView3.tag = 2;
    _imgUrlArr = @[_infoModel.userEx.frontImageUrl,_infoModel.userEx.sideImageUrl,_infoModel.userEx.rearImageUrl];
    
    _beizhuLable.text = [Helper isBlankString: _infoModel.coachComment]?@"暂无":_infoModel.coachComment;
    [_backScroll addSubview:self.detailInfoView];
    _backScroll.contentSize = CGSizeMake(0, _handleBtn.bottom+30);
    
}


-(UIView *)detailInfoView
{
    _urlNamesArr = @[_infoModel.userEx.age,_infoModel.userEx.sex,_infoModel.userEx.height,_infoModel.userEx.weight,_infoModel.userEx.habitusExp,_infoModel.userEx.waist,_infoModel.userEx.hipline,_infoModel.userEx.hiplineRatio,_infoModel.userEx.bodyFat,_infoModel.userEx.metabolismRatio,_infoModel.userEx.stillHeartbeat,_infoModel.userEx.bloodPressure];
    
    if(!_detailInfoView){
        _detailInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, _userImgView.bottom+45, kMainBoundsWidth, 240)];
        _detailInfoView.backgroundColor = [UIColor clearColor];
        float m_height = 80;
        float m_width = kMainBoundsWidth/4+1;
        int index = 0;
        for (int i=0; i<3; i++) {
            for (int j=0; j<4; j++) {
                UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(m_width*j-1, m_height*i, m_width, m_height)];
                subView.layer.borderColor = kSeparatorLineColor.CGColor;
                subView.layer.borderWidth = 0.3;
                [_detailInfoView addSubview:subView];
                
                UILabel *titleLable = [UILabel labelWithFrame:CGRectMake(0, 10, subView.width, 20) text:_titlesArr[index] textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13.0]];
                titleLable.textAlignment = NSTextAlignmentCenter;
                [subView addSubview:titleLable];
                
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(subView.width/2-25, 60, 50, 0.5)];
                line.backgroundColor = [kSeparatorLineColor colorWithAlphaComponent:0.5];
                [subView addSubview:line];
                
                UILabel *contentLable =[UILabel labelWithFrame:CGRectMake(0, 40, subView.width, 20) text:_urlNamesArr[index] textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13.0]];
                contentLable.textAlignment = NSTextAlignmentCenter;
                [subView addSubview:contentLable];
                index++;
            }
        }
    }
    return _detailInfoView;
}


-(void)tapClick:(UIGestureRecognizer *)tap
{
    UIImageView *imgView = (UIImageView *)tap.view;
    [self browseImages:_imgUrlArr index:tap.view.tag touchImageView:imgView];
}

#pragma mark - image browser
- (void)browseImages:(NSArray *)imageArr index:(NSInteger)index touchImageView:(UIImageView *)touchImageView{
    NSInteger count = imageArr.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = imageArr[i];
        photo.srcImageView = touchImageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)handleOrderClick:(id)sender {
    NSLog(@"处理订单");
    JLVideoViewController *videoVC = [JLVideoViewController viewController];
    videoVC.isHandelOrder = YES;
    videoVC.isFirstEnter = YES;
    videoVC.oderId = _infoModel.orderId;
    [self.navigationController pushViewController:videoVC animated:YES];
}
@end

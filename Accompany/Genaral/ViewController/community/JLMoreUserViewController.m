//
//  JLMoreUserViewController.m
//  Accompany
//
//  Created by 王园园 on 16/3/26.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLMoreUserViewController.h"
#import "JLPostUserInfoModel.h"
#import "UIButton+WebCache.h"
#import "JLPersonalCenterViewController.h"
@interface JLMoreUserViewController ()
{
    UIScrollView *scroll;

}

@property(nonatomic,strong)NSArray *usersList;
@property (nonatomic,strong)NSMutableArray *removeList;
@property (nonatomic,strong)NSMutableArray *removeButtonsList;
@property BOOL removeState;
@end

@implementation JLMoreUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"社区信息"];
    [self showBackButton:YES];
    [self setTabBarHide:YES];
    [self setupViews];
    [self setupDatas];
}

-(void)setupViews
{
    if([_infoModel.grssUser.userId isEqualToString:[UserInfo sharedUserInfo].userId]){
        [self.RightBtn setTitle:@"踢人" forState:UIControlStateNormal];
        [self.RightBtn setTitleColor:kTabBarItemSelectColor forState:UIControlStateNormal];
        [self.RightBtn addTarget:self action:@selector(removeUserBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.RightBtn.hidden = YES;
    }
}

-(void)setupDatas
{
    [self initViewState];
    //社区居民
    [HDHud showHUDInView:self.view title:@"加载中"];
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:_infoModel.communityId,@"communityId",nil];
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_GetCommunityUsers pragma:pragma];
    [request getResultWithSuccess:^(id response) {
        NSLog(@"--%@",response);
        _usersList = [JLPostUserInfoModel mj_objectArrayWithKeyValuesArray:response];
        [self setLayOut];
        [HDHud hideHUDInView:self.view];
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}


-(void)setLayOut
{
    
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsWidth, kMainScreenHeight-64)];
    [self.view addSubview:scroll];
    for (UIView *vw in scroll.subviews) {
        [vw removeFromSuperview];
    }
    NSInteger row = (_usersList.count%6)?(_usersList.count/6+1):(_usersList.count/6);
    int index = 0;
    
    float width = 44;
    float margin = (kMainBoundsWidth-26-width*6)/5;
    for(int i = 0; i< row; i++){
        for(int j = 0; j<6; j++){
            JLPostUserInfoModel *model = _usersList[index];
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((width+margin)*j+13, (width+20)*i+15, width, width)];
            [img sd_setImageWithURL:[NSURL URLWithString:model.userPhoto] placeholderImage:[UIImage imageNamed:@"morentou-"]];
            img.layer.cornerRadius = img.height/2;
            img.clipsToBounds = YES;
            img.layer.borderColor = [UIColor grayColor].CGColor;
            img.layer.borderWidth = 0.5;
            img.userInteractionEnabled = YES;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = img.bounds;
            btn.tag = index;
            [btn addTarget:self action:@selector(userBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [img addSubview:btn];
            [scroll addSubview:img];
            
            index++;
            if(index==_usersList.count)
                return;
        }
    }
}

-(void)initViewState
{
    _removeList = [NSMutableArray array];
    _removeButtonsList = [NSMutableArray array];
    [self.RightBtn setTitle:@"踢人" forState:UIControlStateNormal];
    _removeState = NO;
}

-(void)removeUserBtnClick:(UIButton *)btn
{
    if(!_removeState){
        _removeList = [NSMutableArray array];
        _removeButtonsList = [NSMutableArray array];
        [self.RightBtn setTitle:@"确定" forState:UIControlStateNormal];
        _removeState = YES;
    }else{
        if(_removeList.count==0){
            [self initViewState];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定将选中用户移出社区?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        _removeList = [NSMutableArray array];
        _removeState = NO;
        [self.RightBtn setTitle:@"踢人" forState:UIControlStateNormal];
        [self setFreshView];
    }else{
        [self removeUserMethod];
    }
}

-(void)setFreshView
{
    [_removeButtonsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        [btn setBackgroundColor:[UIColor clearColor]];
    }];
    [_removeButtonsList removeAllObjects];
}

-(void)userBtnClick:(UIButton *)btn
{
    JLPostUserInfoModel *model = (JLPostUserInfoModel *)[_usersList objectAtIndex:btn.tag];
    if(_removeState){
        if ([_removeButtonsList containsObject:btn]) {
            [_removeButtonsList removeObject:btn];
            [_removeList removeObject:model];
            [btn setBackgroundColor:[UIColor clearColor]];
        }else{
            [_removeButtonsList addObject:btn];
            [_removeList addObject:model];
            [btn setBackgroundColor:RGBACOLOR(93., 41., 49, 0.7)];
        }
    }else{
        JLPostUserInfoModel *model = (JLPostUserInfoModel *)[_usersList objectAtIndex:btn.tag];
        JLPersonalCenterViewController *vc = [JLPersonalCenterViewController viewController];
        vc.userModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)removeUserMethod
{

    
    
    
    
    [self setupDatas];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

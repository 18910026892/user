//
//  JLVenueDetailViewController.m
//  Accompany
//
//  Created by GongXin on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLVenueDetailViewController.h"
#import "LoginViewController.h"
#import "JLVenueMapViewController.h"
@interface JLVenueDetailViewController ()

@end

@implementation JLVenueDetailViewController

-(UIButton*)CollectionButton
{
    if (!_CollectionButton) {
        _CollectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_CollectionButton setFrame:CGRectMake(kMainBoundsWidth - 70, 10*Proportion, 64, 44)];
        _CollectionButton.titleLabel.font = [UIFont fontWithName:KTitleFont size:16.0];
      
        _CollectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

        
        if ([_ISCollection isEqualToString:@"0"]) {
            
             [_CollectionButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
        }else if ([_ISCollection isEqualToString:@"1"])
        {
            
            [_CollectionButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        }
        

        [_CollectionButton addTarget:self action:@selector(CollectionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _CollectionButton;
}
-(void)CollectionClick:(UIButton*)sender

{
    NSLog(@"collection is %@",self.ISCollection);
    
    userInfo = [UserInfo sharedUserInfo];
    if (!userInfo.isLog) {
        LoginViewController *loginViewController = [LoginViewController viewController];

        UINavigationController *userNav = [[UINavigationController alloc]
                                           initWithRootViewController:loginViewController];
        
        [self presentModalViewController:userNav animated:YES];
        

    }else if(userInfo.isLog)
        
    {
        
        _CollectionButton.enabled = NO;
        
        NSString * requestUrl;
        
        if ([_ISCollection isEqualToString:@"0"]) {
            requestUrl = URL_collectClub;
        }else if ([_ISCollection isEqualToString:@"1"])
        {
            requestUrl = URL_cancelCollect;
        }
        
        NSString * token = userInfo.token;
        NSString * clubID = self.VenueModel.clubId;
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",clubID, @"clubId",nil];
        
        HttpRequest * request = [[HttpRequest alloc]init];
        [request RequestDataWithUrl:requestUrl pragma:postDict];
    
        request.successBlock = ^(id obj){
        
            if ([_ISCollection isEqualToString:@"1"]) {
                
                _ISCollection = @"0";
                [_CollectionButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
                
             
            }else if ([_ISCollection isEqualToString:@"0"])
            {
                _ISCollection = @"1";
                [_CollectionButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"collectStateChange" object:nil];
            
            NSLog(@"123");
             _CollectionButton.enabled = YES;

        };
        request.failureDataBlock = ^(id error)
        {
            [HDHud hideHUDInView:self.view];
            NSString * message = (NSString *)error;
            [HDHud showMessageInView:self.view title:message];
             _CollectionButton.enabled = YES;
        };
        
        request.failureBlock = ^(id obj){
            
            [HDHud showNetWorkErrorInView:self.view];
             _CollectionButton.enabled = YES;
        };
        
    }
   
    
}

-(UIButton*)BackButton
{
    if (!_BackButton) {
        _BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _BackButton.frame = CGRectMake(10,20, 64*Proportion, 44);
        _BackButton.imageEdgeInsets = UIEdgeInsetsMake(0,-20, 0, 25);
        [_BackButton setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
        [_BackButton setImage:[UIImage imageNamed:@"BackButtonHighlighted"] forState:UIControlStateHighlighted];
        [_BackButton addTarget:self action:@selector(BackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _BackButton;
}
-(void)BackButtonClick:(UIButton*)Button;
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UILabel*)VenueNameLabel
{
    if (!_VenueNameLabel) {
        _VenueNameLabel = [[UILabel alloc]init];
        _VenueNameLabel.frame = CGRectMake(20, 200*Proportion-40, kMainBoundsWidth-40, 40);
        _VenueNameLabel.text = self.VenueModel.clubName;
        _VenueNameLabel.textAlignment = NSTextAlignmentLeft;
        _VenueNameLabel.font = [UIFont systemFontOfSize:16];
        _VenueNameLabel.textColor = [UIColor whiteColor];
        _VenueNameLabel.backgroundColor = [UIColor clearColor];
    }
    return _VenueNameLabel;
}

-(UIImageView*)HeaderImageView
{
    if (!_HeaderImageView) {
        
        NSString * HeaderImage = self.VenueModel.clubImg;
        
        NSURL * ImageUrl = [NSURL URLWithString:HeaderImage];
        
        _HeaderImageView = [[UIImageView alloc]init];
        _HeaderImageView.frame = CGRectMake(0, 0, kMainBoundsWidth, 200*Proportion);
        _HeaderImageView.backgroundColor = [UIColor clearColor];
        _HeaderImageView.userInteractionEnabled = YES;
        [_HeaderImageView sd_setImageWithURL:ImageUrl];
        
        [_HeaderImageView addSubview:self.BackButton];
        [_HeaderImageView addSubview:self.CollectionButton];
        
    }
    return _HeaderImageView;
}


- (UITableView *)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight-40) style:UITableViewStyleGrouped];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
//        _TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        _TableView.separatorColor = [UIColor whiteColor];
     
        [_TableView setParallaxHeaderView:self.HeaderImageView
                                mode:VGParallaxHeaderModeFill
                              height:200*Proportion];
        
        
        [_TableView addSubview:self.VenueNameLabel];
    }
    return _TableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_TableView shouldPositionParallaxHeader];
    
}
#pragma TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{

    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
 
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_selectIndex==0) {
        if(indexPath.section==2)
        {
            UITableViewCell *cell =(UITableViewCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
            UILabel *lable = (UILabel *)[cell viewWithTag:1002];
            return CGRectGetHeight(lable.frame)+44;
        }else if(indexPath.section==3)
        {
            return [_PhotoArray count]*(115*Proportion+20)+44;
        }else
            return 44;
    }else
        return 100;
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
 
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    if(_selectIndex==0)
    {
        return 4;
    }else
        return [_coachListArray count]>0?[_coachListArray count]:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    
    
    UITableViewCell * cell ;
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 40, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor whiteColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
    
        [cell.contentView addSubview:_cellTitle];
        
        _cellContent = [[UILabel alloc]initWithFrame:CGRectMake(70, 12, kMainBoundsWidth-100, 20)];
        _cellContent.backgroundColor = [UIColor clearColor];

        _cellContent.textColor = [UIColor whiteColor];
        _cellContent.textAlignment = NSTextAlignmentLeft;
        _cellContent.font = [UIFont systemFontOfSize:12];
        _cellContent.tag = indexPath.section+1000;
        [cell.contentView addSubview:_cellContent];

        
    }

    if (_selectIndex==0) {
        switch (indexPath.section) {
            case 0:
            {
                _cellTitle.text =@"电话";
                _cellContent.text = self.VenueModel.clubTel;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 1:
            {
                _cellTitle.text =@"地址";
                _cellContent.text = self.VenueModel.clubAddress;
                  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 2:
            {
                
                _cellTitle.text = @"简介";
                _cellContent.text = self.VenueModel.clubDesc;
                _cellContent.numberOfLines = 0 ;
                [_cellContent sizeToFit];
            }
                break;
            case 3:
            {
                _cellTitle.text = @"图片";
                
                
                for (int i= 0; i<[_PhotoArray count]; i++) {
                    _cellImageView = [[UIImageView alloc]init];
                    _cellImageView.frame = CGRectMake(20, 44+(115*Proportion+20)*i, kMainBoundsWidth-40, 115*Proportion);
                    
                    NSString * imageulr = [_PhotoArray objectAtIndex:i];
                    NSURL * imageUrl = [NSURL URLWithString:imageulr];
                    
                    _cellImageView.backgroundColor = [UIColor clearColor];
                    
                    [_cellImageView sd_setImageWithURL:imageUrl];
                    
                    [cell.contentView addSubview:_cellImageView];
                }
                
                
            }
                break;
            default:
                break;
        }
    }else if(_selectIndex==1)
    {
        CocahModel * coachModel = _coachListArray[indexPath.section];
        
        static NSString * cellID = @"cellID";
        CoachListTableViewCell * CoachListCell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!CoachListCell) {
            
            CoachListCell = [[CoachListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            CoachListCell.backgroundColor = [UIColor clearColor];
            CoachListCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }else{
            
            while ([CoachListCell.contentView.subviews lastObject] != nil) {
                [(UIView*)[CoachListCell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        CoachListCell.cocahModel = coachModel;
        
        
        return CoachListCell;

    }

    
   
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_selectIndex==0) {
        switch (indexPath.section) {
            case 0:
            {
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否联系该商家" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                
                
            }
                break;
            case 1:
                
            {
                JLVenueMapViewController * venueMapVc = [JLVenueMapViewController viewController];
                venueMapVc.VenueModel = self.VenueModel;
                [self.navigationController pushViewController:venueMapVc animated:YES];
            }
                break;
            default:
                break;
        }
    }
   

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0);
{
    
    if(buttonIndex==1)
    {
        NSString * telNumber = [NSString stringWithFormat:@"tel://%@",self.VenueModel.clubTel];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    self.automaticallyAdjustsScrollViewInsets=NO;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
     _ISCollection = self.VenueModel.isCollection;
    [self setNavigationBarHide:YES];
    [self setupDatas];
    [self setupViews];
    
}

-(void)setupDatas
{
    _PhotoArray = [NSMutableArray array];
    [_PhotoArray addObjectsFromArray:self.VenueModel.clubImgs];
    
    NSLog(@"图片视图的数组是%@",self.VenueModel.clubImgs);
    self.menuItems = @[@"场馆",@"教练"];
    _selectIndex = 0;
    
 
    //获取第二页教练信息
    [self getcoachInfo];

}

-(void)getcoachInfo

{
    NSString * num = @"50";
    NSString * venueId = self.VenueModel.clubId;
    NSString * type = @"newest";
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:venueId, @"clubId",type,@"type",num, @"num", nil];
    
    NSLog(@"**%@",postDict);
    HttpRequest * request = [[HttpRequest alloc]init];
    
    [request RequestDataWithUrl: URL_listCoachByClub pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        

        NSLog(@">>>>>>>>>>%@",obj);
        
        _coachArray = obj;
        _coachModelArray = [CocahModel mj_objectArrayWithKeyValuesArray:_coachArray];

        _coachListArray = [NSMutableArray arrayWithArray:_coachModelArray];
        [_TableView.header endRefreshing];
        [_TableView reloadData];

         _control.enabled = YES;
        
    };
    request.failureDataBlock = ^(id error)
    {
        NSString * message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    };
    
    request.failureBlock = ^(id obj){
        
        [HDHud showNetWorkErrorInView:self.view];
    };
}

-(void)setupViews
{

    [self.view addSubview:self.TableView];
    [self.view addSubview:self.control];
    [self.view addSubview:self.lineLabel];
}
-(UILabel*)lineLabel
{
    if (!_lineLabel) {
        _lineLabel= [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
        _lineLabel.frame = CGRectMake(kMainBoundsWidth/2, kMainBoundsHeight-27, 1, 10);
    }
    return _lineLabel;
}


- (DZNSegmentedControl *)control
{
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:self.menuItems];
        _control.delegate = self;
        _control.selectedSegmentIndex = 0;
        _control.bouncySelectionIndicator = NO;
        _control.height = 40.0f;
        _control.frame = CGRectMake(20, kMainBoundsHeight-40, kMainBoundsWidth-40, 40);
        _control.showsGroupingSeparators = NO;
        _control.backgroundColor =kDefaultBackgroundColor;
        _control.tintColor = [UIColor redColor];
        _control.showsCount = NO;
        _control.selectionIndicatorHeight = 0;
        [_control addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
        _control.enabled = NO;
    }
    return _control;
}
- (void)didChangeSegment:(DZNSegmentedControl *)control
{
    
    _selectIndex = control.selectedSegmentIndex;
    NSLog(@"*****%ld",(long)_selectIndex);
    
    
    [self.TableView reloadData];
}


#pragma mark - DZNSegmentedControlDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionAny;
}

- (UIBarPosition)positionForSelectionIndicator:(id<UIBarPositioning>)bar
{
    return UIBarPositionAny;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

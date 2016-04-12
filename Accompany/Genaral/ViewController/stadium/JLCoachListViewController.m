//
//  JLCoachListViewController.m
//  Accompany
//
//  Created by 巩鑫 on 16/2/6.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLCoachListViewController.h"
#import "JLCoachDetailViewController.h"
#import "JLSearchViewController.h"
@implementation JLCoachListViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    
    if (self.update == YES) {
        [_TableView.header beginRefreshing];
        self.update = NO;
    }
    [self setTabBarHide:YES];
}

//添加更新控件
-(void)addRefresh
{
    
    [_TableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [_TableView.header setTitle:@"下拉可以刷新了" forState:MJRefreshHeaderStateIdle];
    [_TableView.header setTitle:@"松开马上刷新" forState:MJRefreshHeaderStatePulling];
    [_TableView.header setTitle:@"正在刷新 ..." forState:MJRefreshHeaderStateRefreshing];
    
     [_TableView.header setTextColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    _coachType = @"hot";
    [self setupDatas];
    [self setupViews];
    [self setNavTitle:@"教练"];
    [self showBackButton:YES];
    self.update = YES;
    self.isHidden = YES;
    self.IsScreen = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    
}
-(void)setupDatas
{
    self.menuItems = @[@"最热",@"最新",@"榜单"];
    
    self.areaArray = @[@"朝阳区",@"海淀区",@"西城区",@"东城区",@"丰台区",@"石景山区"];
    self.sexArray = @[@"男",@"女"];
}
//请求数据
-(void)headerRereshing
{
    _page = @"1";
    if (_IsScreen==NO) {
        [self requestDataWithPage:1];
    }else if(_IsScreen==YES)
        
    {
        [self ScreenDataWithPage:1];
    }
    
}

//加载更多数据
-(void)loadMoreData
{
    int page = [_page intValue];
    page ++;
    _page = [NSString stringWithFormat:@"%d",page];
    if (_IsScreen==NO) {
        [self requestDataWithPage:2];
    }else if(_IsScreen==YES)
    {
        [self ScreenDataWithPage:2];
    }
}
//请求数据的方法
-(void)requestDataWithPage:(int)Type
{
    

//    参数:cludId(场馆ID)，type（类别类型 必填
   //最热，最新，榜单	hot,newest,top;）
 
    NSString * token = [UserInfo sharedUserInfo].token;
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page",_coachType,@"type",token,@"token", nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_listCoachByClub pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        NSLog(@"***%@",obj);
        
        _coachArray = obj;
        _coachModelArray = [CocahModel mj_objectArrayWithKeyValuesArray:_coachArray];
        
        if (Type == 1) {
            _coachListArray = [NSMutableArray arrayWithArray:_coachModelArray];
            [_TableView.header endRefreshing];
            [_TableView reloadData];
            
        }else if(Type == 2){
            
            NSMutableArray * Array = [[NSMutableArray alloc] init];
            [Array addObjectsFromArray:_coachListArray];
            [Array addObjectsFromArray:_coachModelArray];
            _coachListArray = Array;
            [_TableView.footer endRefreshing];
            [_TableView reloadData];
        }
        
        if ([_coachListArray count]==0) {
            [HDHud showMessageInView:self.view title:@"暂无数据"];
        }else if([_coachListArray count]>9)
        {
            [_TableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            [_TableView reloadData];
            
        }
        
        
        
        
        
    };
    request.failureBlock = ^(id obj){
        
        [HDHud showNetWorkErrorInView:self.view];
    };
    
    
}
-(void)ScreenDataWithPage:(int)Type
{

    //    参数: userSex，area,type（类别类型 必填
    //最热，最新，榜单	hot,newest,top;  ）
    
    NSString * sex ;
    if ([_userSex isEqualToString:@"男"]) {
        sex = @"1";
    }else if ([_userSex isEqualToString:@"女"])
    {
        sex= @"2";
    }
     NSString * token = [UserInfo sharedUserInfo].token;
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page",_coachType,@"type",sex,@"userSex",_area ,@"area",token,@"token", nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_listCoachByClub pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
      
        _coachArray = obj;
        _coachModelArray = [CocahModel mj_objectArrayWithKeyValuesArray:_coachArray];
        
        if (Type == 1) {
            _coachListArray = [NSMutableArray arrayWithArray:_coachModelArray];
            [_TableView.header endRefreshing];
            [_TableView reloadData];
            
        }else if(Type == 2){
            
            NSMutableArray * Array = [[NSMutableArray alloc] init];
            [Array addObjectsFromArray:_coachListArray];
            [Array addObjectsFromArray:_coachModelArray];
            _coachListArray = Array;
            [_TableView.footer endRefreshing];
            [_TableView reloadData];
        }
        
        if ([_coachListArray count]==0) {
            [HDHud showMessageInView:self.view title:@"暂无数据"];
        }else if([_coachListArray count]>9)
        {
            [_TableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            [_TableView reloadData];
            
        }
        
        
        
        
        
    };
    request.failureBlock = ^(id obj){
        
        [HDHud showNetWorkErrorInView:self.view];
    };
    
}



-(UILabel*)lineLabel1
{
    if (!_lineLabel1) {
        _lineLabel1= [[UILabel alloc]init];
        _lineLabel1.backgroundColor = [UIColor lightGrayColor];
        _lineLabel1.frame = CGRectMake(kMainBoundsWidth/3, 79, 1, 10);
    }
    return _lineLabel1;
}
-(UILabel*)lineLabel2
{
    if (!_lineLabel2) {
        _lineLabel2= [[UILabel alloc]init];
        _lineLabel2.backgroundColor = [UIColor lightGrayColor];
        _lineLabel2.frame = CGRectMake(kMainBoundsWidth*2/3, 79, 1, 10);
    }
    return _lineLabel2;
}


-(void)setupViews
{
    
  
    [self.Customview addSubview:self.SearchBarButton];
    [self.Customview addSubview:self.MenuButton];
    [self.view addSubview:self.control];
    [self.view addSubview:self.lineLabel1];
    [self.view addSubview:self.lineLabel2];
    [self.view addSubview:self.TableView];
    [self.view addSubview:self.screenView];
    
}
-(UIButton*)SearchBarButton
{
    if (!_SearchBarButton) {
        _SearchBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _SearchBarButton.frame = CGRectMake(kMainBoundsWidth-98, 20*Proportion, 64, 44);
        _SearchBarButton.backgroundColor = [UIColor clearColor];
          [_SearchBarButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_SearchBarButton addTarget:self action:@selector(searchBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _SearchBarButton;
}

-(void)searchBarButtonClick:(UIButton*)sender

{
    
    JLSearchViewController * SearchVC = [JLSearchViewController viewController];
    SearchVC.searchType = @"1";
    [self.navigationController pushViewController:SearchVC animated:YES];
    
}

-(UIButton*)MenuButton
{
    
    if (!_MenuButton) {
        _MenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _MenuButton.frame = CGRectMake(kMainBoundsWidth - 64, 20*Proportion, 64, 44);
        [_MenuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
        [_MenuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _MenuButton;
}

-(void)menuButtonClick:(UIButton*)sender
{
  
    if (_isHidden) {
        [self showPicker];
    }else if(!_isHidden)
    {
        [self hidePicker];
}
    

}
#pragma mark - Picker Trigger
- (void)hidePicker {
    if (!_isHidden) {
        [UIView animateWithDuration:0.3 animations:^(void) {
            _screenView.frame = CGRectMake(0, kMainBoundsHeight, kMainBoundsWidth, 220);
        }];
        self.isHidden = YES;
    }
}

- (void)showPicker {
    if (_isHidden) {
        [UIView animateWithDuration:0.3 animations:^(void) {
            _screenView.frame = CGRectMake(0, kMainBoundsHeight-220, kMainBoundsWidth, 220);
        }];
        self.isHidden = NO;
    }
}
-(UIView*)screenView
{
    if (!_screenView) {
        _screenView = [[UIView alloc]initWithFrame:CGRectMake(0, kMainBoundsHeight, kMainBoundsWidth, 220)];
        _screenView.backgroundColor = [UIColor whiteColor];
        [_screenView addSubview:self.aboveViewToolBar];
        [_screenView addSubview:self.pickerView];
    }
    return _screenView;
}


- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, 40, kMainBoundsWidth, 180);
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
        [_pickerView selectRow:2 inComponent:0 animated:YES];
        
    }
    return _pickerView;
}
#pragma pickerView Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return [_areaArray count];
    }else
    return [_sexArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(component==0)
    {
      return [_areaArray objectAtIndex:row] ;
    }else
    return [_sexArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if (component==0) {
        NSLog(@"%@",[_areaArray objectAtIndex:row]);
        
        _area = [_areaArray objectAtIndex:row];
        
    }else if (component==1)
    {
        _userSex = [_sexArray objectAtIndex:row];
    }
}

- (UIToolbar *)aboveViewToolBar
{
    if (!_aboveViewToolBar)
    {
        _aboveViewToolBar = [[UIToolbar alloc] init];
        _aboveViewToolBar.frame = CGRectMake(0, 0, kMainBoundsWidth, 40);
        _aboveViewToolBar.barStyle = UIBarStyleDefault;
        _aboveViewToolBar.translucent = YES;
        _aboveViewToolBar.tintColor = [UIColor redColor];
        [_aboveViewToolBar sizeToFit];
        
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                     target:nil
                                     action:nil];
        
        
        
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"取消"
                                         style:UIBarButtonItemStyleBordered
                                         target:self
                                         action:@selector(cancelClicked:)];
        
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"完成"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(doneClicked:)];
        
        [_aboveViewToolBar setItems:[NSArray arrayWithObjects:
                                     cancelButton,
                                     flexItem,
                                     doneButton, nil]];
    }
    
    return _aboveViewToolBar;
}

- (void)cancelClicked:(id)sender
{
    [self hidePicker];
}

- (void)doneClicked:(id)sender
{
  
    if ([_area isEqualToString:@""]) {
        _area = [_areaArray objectAtIndex:2];
    }
    
    if ([_userSex isEqualToString:@""]) {
        _userSex = [_sexArray objectAtIndex:0];
        
    }
    
    [self hidePicker];
    self.IsScreen = YES;
     [_TableView.header beginRefreshing];
    
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
        _control.frame = CGRectMake(0, 64, kMainBoundsWidth, 40);
        _control.showsGroupingSeparators = YES;
        _control.backgroundColor =kDefaultBackgroundColor;
        _control.tintColor = [UIColor redColor];
        _control.showsCount = NO;
        _control.selectionIndicatorHeight = 0;
        [_control setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_control addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}

- (void)didChangeSegment:(DZNSegmentedControl *)control
{
    
    NSInteger selectIndex = control.selectedSegmentIndex;
     //最热，最新，榜单	hot,newest,top;）
    switch (selectIndex) {
        case 0:
        {
            _coachType = @"hot";
        }
            break;
            case 1:
        {
            _coachType = @"newest";
        }
            break;
            case 2:
        {
            _coachType = @"top";
        }
            break;
        default:
            break;
    }
    
     [_TableView.header beginRefreshing];
 
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

-(UITableView*)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 103.9, kMainBoundsWidth,kMainBoundsHeight-103.9) style:UITableViewStylePlain];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
        _TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _TableView.separatorColor = [UIColor lightGrayColor];
         [self addRefresh];
    }
    
    return _TableView;
}
#pragma TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section==0) {
        return 0;
    }else
        return .1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

{
    return .1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
   return [_coachListArray count]>0?[_coachListArray count]:0;;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    
    CocahModel * coachModel = _coachListArray[indexPath.row];
    
    static NSString * cellID = @"cellID";
    CoachListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[CoachListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }else{
        
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    }
    
    cell.cocahModel = coachModel;
    
 
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CocahModel * coachModel = _coachListArray[indexPath.row];
    JLCoachDetailViewController * coachDetailVC = [JLCoachDetailViewController viewController];
    coachDetailVC.coachModel = coachModel;
    [self.navigationController pushViewController:coachDetailVC animated:YES];
}

@end

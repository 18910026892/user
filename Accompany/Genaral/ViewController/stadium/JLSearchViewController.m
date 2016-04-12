//
//  JLSearchViewController.m
//  Accompany
//
//  Created by 巩鑫 on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLSearchViewController.h"
#import "JLSearchVenueResultViewController.h"
#import "JLSearchCoachResultViewController.h"
@implementation JLSearchViewController

-(id)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTypeChanged) name:@"SearchTypeChange" object:nil];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTabBarHide:YES];
    

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
}
-(void)setupViews
{

    [self.view addSubview:self.SearchBarView];
    [self.view addSubview:self.CancleButton];
}


//初始化相关控件
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _CanAddRecord = YES;
    [self setNavigationBarHide:YES];
    [self setupDatas];
    [self setupViews];
}
-(void)setupDatas
{
    
    if([_searchType isEqualToString:@"0"])
    {
        _VenueSearchArray = [UserDefaultsUtils valueWithKey:@"venueSearchRecord"];
        _searchRecordArray = [NSMutableArray arrayWithArray:_VenueSearchArray];
        
        
    }else if([_searchType isEqualToString:@"1"])
    {
        _CoachSearchArray = [UserDefaultsUtils valueWithKey:@"coachSearchRecord"];
        _searchRecordArray = [NSMutableArray arrayWithArray:_CoachSearchArray];
        
    }
    
    if ([_searchRecordArray count]>0) {
        
        [self.view addSubview:self.TableView];
    }

}
- (void)searchTypeChanged
{
    NSString * number = [Config currentConfig].searchType;
    
    if (number.intValue == 0)
    {
        [self.SearchTypeButton setTitle:@"场馆" forState:UIControlStateNormal];
        _VenueSearchArray = [UserDefaultsUtils valueWithKey:@"venueSearchRecord"];
        _searchRecordArray = [NSMutableArray arrayWithArray:_VenueSearchArray];
        
        
    }
    else if (number.intValue == 1)
    {
        [self.SearchTypeButton setTitle:@"教练" forState:UIControlStateNormal];
        _CoachSearchArray = [UserDefaultsUtils valueWithKey:@"coachSearchRecord"];
        _searchRecordArray = [NSMutableArray arrayWithArray:_CoachSearchArray];
        
        
        
    }
    
    [self.TableView reloadData];
    
    _searchType = [NSString stringWithFormat:@"%@",number];
    
    [self.SearchTypeButton setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    
    
}
//搜索类型的实现
- (void)searchTypeBtnTapped:(id)sender
{
    
    [ChooseSearchTypeView showOnWindow];
    [_SearchTypeButton setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];
}
//取消搜索
-(void)cancleSearch:(UIButton *)sender
{
    NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:index-1] animated:NO];
}

-(UIButton*)SearchTypeButton
{
    if (!_SearchTypeButton)
    {
        _SearchTypeButton = [[UIButton alloc] init];
        _SearchTypeButton.frame = CGRectMake(0, 0, 60, 28);
        
        if (IOS7)
        {
            _SearchTypeButton.backgroundColor = [UIColor clearColor];
            [_SearchTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_SearchTypeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        }
        else
        {
            
            _SearchTypeButton.backgroundColor = [UIColor clearColor];
            [_SearchTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_SearchTypeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            
        }
        
        if ([_searchType isEqualToString:@"0"]) {
            
            [_SearchTypeButton setTitle:@"场馆" forState:UIControlStateNormal];
        }else  if ([_searchType isEqualToString:@"1"])
        {
             [_SearchTypeButton setTitle:@"教练" forState:UIControlStateNormal];
        }
        
        
        [_SearchTypeButton setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
        _SearchTypeButton.imageEdgeInsets = UIEdgeInsetsMake(0,45, 0, 0);
        _SearchTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        _SearchTypeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _SearchTypeButton.hidden = NO;
        [_SearchTypeButton addTarget:self action:@selector(searchTypeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _SearchTypeButton;

}
-(SearchTextField*)SearchBar
{
    if (!_SearchBar) {
        _SearchBar = [[SearchTextField alloc]initWithFrame:CGRectMake(65,0, 260*Proportion-66, 28)];
        _SearchBar.placeholder = @"搜索场馆，教练";
        _SearchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
        _SearchBar.returnKeyType = UIReturnKeySearch;
        _SearchBar.font = [UIFont boldSystemFontOfSize:14.0];
        _SearchBar.textColor = [UIColor whiteColor];
        _SearchBar.delegate = self;
        _SearchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _SearchBar.tintColor = [UIColor redColor];
        [_SearchBar becomeFirstResponder];
        
    }

    return _SearchBar;
}

-(UIButton*)CancleButton
{
    if (!_CancleButton) {
        _CancleButton = [[UIButton alloc] init];
        _CancleButton.frame = CGRectMake(kMainBoundsWidth-50, 28, 50, 28);
        _CancleButton.backgroundColor = [UIColor clearColor];
        [_CancleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_CancleButton setTitle:@"取消" forState:UIControlStateNormal];
        _CancleButton.titleEdgeInsets = UIEdgeInsetsMake(1, 1, 0, 0);
        _CancleButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _CancleButton.hidden = NO;
        [_CancleButton addTarget:self action:@selector(cancleSearch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _CancleButton;

}

-(UIView*)SearchBarView
{
    if (!_SearchBarView) {
        _SearchBarView = [[UIView alloc]initWithFrame:CGRectMake(9, 28, 260*Proportion, 28)];
        _SearchBarView.layer.cornerRadius = 5;
        _SearchBarView.layer.borderWidth = 0.4;
        _SearchBarView.layer.borderColor = [UIColor grayColor].CGColor;
        _SearchBarView.backgroundColor = RGBACOLOR(45, 50, 54, 1);
        [_SearchBarView addSubview:self.SearchTypeButton];
        [_SearchBarView addSubview:self.SearchBar];
        
    }
    return _SearchBarView;

}

-(UIButton*)cleanRecordButton
{
    if (!_cleanRecordButton) {
        _cleanRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cleanRecordButton.frame = CGRectMake(40, 25,kMainScreenWidth-80, 40);
        _cleanRecordButton.backgroundColor = [UIColor clearColor];
        [_cleanRecordButton setTitle:@"清除历史搜索" forState:UIControlStateNormal];
        [_cleanRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cleanRecordButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _cleanRecordButton.layer.borderWidth = 1;
        _cleanRecordButton.layer.cornerRadius = 5;
        _cleanRecordButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cleanRecordButton addTarget:self action:@selector(cleanRecordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cleanRecordButton;
}

-(UITableView*)TableView
{
    if (!_TableView) {
        
        _TableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64,kMainBoundsWidth,kMainBoundsHeight-64) style:UITableViewStyleGrouped];
        _TableView.delegate = self;
        _TableView.dataSource = self;
        _TableView.backgroundColor = [UIColor clearColor];
        _TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _TableView.separatorColor = [UIColor lightGrayColor];
        [_TableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _TableView.tableFooterView = self.FooterView;
     
        
    }
    return _TableView;
}
-(UIView*)FooterView
{
    if (!_FooterView) {
        _FooterView = [[UIView alloc]init];
        _FooterView.frame = CGRectMake(0, 0,kMainScreenWidth, 90);
        _FooterView.backgroundColor = [UIColor clearColor];
        [_FooterView addSubview:self.cleanRecordButton];
    }
    return _FooterView;

}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 5, kMainScreenWidth-20, 20);
    label.font= [UIFont boldSystemFontOfSize:15];
    label.text = @"最近搜索";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentLeft;
    
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kMainScreenWidth,30)] ;
    [sectionView setBackgroundColor:RGBACOLOR(45, 50, 54, 1)];
    [sectionView addSubview:label];
    return sectionView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return .1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return  [_searchRecordArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    
    static NSString * cellID = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = RGBACOLOR(45, 50, 54, 1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            
        }
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.text = [[_searchRecordArray objectAtIndex:indexPath.row]valueForKey:@"title"];

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString * keyword = [[_searchRecordArray objectAtIndex:indexPath.row]valueForKey:@"title"];
    
    if ([_searchType isEqualToString:@"0"]) {
        
        JLSearchVenueResultViewController * venueSearchVC = [JLSearchVenueResultViewController viewController];
        venueSearchVC.keyword = keyword;
        [self.navigationController pushViewController:venueSearchVC animated:YES];
        
    } else if([_searchType isEqualToString:@"1"])
    {
       
        JLSearchCoachResultViewController * coachSearchVC = [JLSearchCoachResultViewController viewController];
        coachSearchVC.keyword = _SearchBar.text;
        [self.navigationController pushViewController:coachSearchVC animated:YES];
    }
   
    
}



-(void)cleanRecordButtonClick:(UIButton*)sender
{
    

    if ([_searchType isEqualToString:@"0"]) {
        
        _searchRecordArray = [NSMutableArray array];
        [_searchRecordArray addObjectsFromArray:[UserDefaultsUtils valueWithKey:@"venueSearchRecord"]];
        [_searchRecordArray removeAllObjects];
        
    }else if([_searchType isEqualToString:@"1"])
    {
        _searchRecordArray = [NSMutableArray array];
        [_searchRecordArray addObjectsFromArray:[UserDefaultsUtils valueWithKey:@"coachSearchRecord"]];
        [_searchRecordArray removeAllObjects];
        
    }
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"venueSearchRecord"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"coachSearchRecord"];
 
    [self.TableView removeFromSuperview];

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [_SearchBar resignFirstResponder];
    
    if ([_SearchBar.text isEmpty]) {
        [HDHud showMessageInView:self.view title:@"请先输入关键词"];
    }else
    {
        [self addRecord:_SearchBar.text];
        
        if ([_searchType isEqualToString:@"0"]) {
            
        
            JLSearchVenueResultViewController * venueSearchVC = [JLSearchVenueResultViewController viewController];
            venueSearchVC.keyword = _SearchBar.text;
            [self.navigationController pushViewController:venueSearchVC animated:YES];
            
        } else if([_searchType isEqualToString:@"1"])
        {
       
            JLSearchCoachResultViewController * coachSearchVC = [JLSearchCoachResultViewController viewController];
            coachSearchVC.keyword = _SearchBar.text;
            [self.navigationController pushViewController:coachSearchVC animated:YES];
        }
       
        
    }
    
    return YES;
    
}

-(void)addRecord:(NSString*)title;
{
    

    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", nil];
    
    
    if ([_searchType isEqualToString:@"0"])
    {
        if (![UserDefaultsUtils valueWithKey:@"venueSearchRecord"]) {
            _VenueSearchArray = [NSMutableArray arrayWithObjects:postDict, nil];
            [UserDefaultsUtils saveValue:_VenueSearchArray forKey:@"venueSearchRecord"];
        }else
        {
            NSMutableArray * array1 =  [UserDefaultsUtils valueWithKey:@"venueSearchRecord"];
            NSMutableArray * array2 = [NSMutableArray array];
            [array2 addObjectsFromArray:array1];
            for (NSDictionary * dict in array1) {
                NSString * oldTitle  = [dict valueForKey:@"title"];
                if ([oldTitle isEqualToString:title]) {
                    _CanAddRecord = NO;
                }
            }
            if (_CanAddRecord) {
                [array2 addObject:postDict];
                [UserDefaultsUtils saveValue:array2 forKey:@"venueSearchRecord"];
            }else
            {
                NSLog(@"该商品之前已经记录过了");
            }
            
            
        }
        
        
        
    }else if ([_searchType isEqualToString:@"1"])
    {
        if (![UserDefaultsUtils valueWithKey:@"coachSearchRecord"]) {
            _CoachSearchArray = [NSMutableArray arrayWithObjects:postDict, nil];
            [UserDefaultsUtils saveValue:_CoachSearchArray forKey:@"coachSearchRecord"];
        }else
        {
            NSMutableArray * array1 =  [UserDefaultsUtils valueWithKey:@"coachSearchRecord"];
            NSMutableArray * array2 = [NSMutableArray array];
            [array2 addObjectsFromArray:array1];
            for (NSDictionary * dict in array1) {
                NSString * oldTitle  = [dict valueForKey:@"title"];
                if ([oldTitle isEqualToString:title]) {
                    _CanAddRecord = NO;
                }
            }
            if (_CanAddRecord) {
                [array2 addObject:postDict];
                [UserDefaultsUtils saveValue:array2 forKey:@"coachSearchRecord"];
            }else
            {
                NSLog(@"该店铺之前已经记录过了");
            }
            
            
        }
        
        
        
    }
    
}


@end

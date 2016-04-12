//
//  ChooseSearchTypeView.m
//  syb
//
//  Created by GX on 15/10/21.
//  Copyright © 2015年 GX. All rights reserved.
//

#import "ChooseSearchTypeView.h"

@implementation ChooseSearchTypeView

+ (ChooseSearchTypeView *)sharedInstance
{
    static ChooseSearchTypeView *v = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        v = [[ChooseSearchTypeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    
    return v;
}

+ (void)showOnWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    [window addSubview:[ChooseSearchTypeView sharedInstance]];
    [window bringSubviewToFront:[ChooseSearchTypeView sharedInstance]];
}

+ (void)hide
{
    [[ChooseSearchTypeView sharedInstance] disappear];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self InitTriangleView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(disappear)];
        ges.delegate = self;
        [self addGestureRecognizer:ges];
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint pt = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(self.tableView.frame, pt))
        return NO;
    return YES;
}

- (void)disappear
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchTypeChange" object:nil];
}

-(void)InitTriangleView;
{
    if (!_triangleView) {
        _triangleView = [[UIImageView alloc]init];
        _triangleView.frame = CGRectMake(27, 53, 22, 11);
        _triangleView.image = [UIImage imageNamed:@"triangle"];
        _triangleView.alpha = 1;
        
        [self addSubview:_triangleView];
    }

}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 64, 140, 80) style:UITableViewStylePlain];
        _tableView.layer.cornerRadius = 3;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = RGBACOLOR(55, 55,55, .8);
        [self addSubview:_tableView];
    }
    
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCellIndi = @"typeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCellIndi];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellIndi];
        
        UIView *vSepline = [[UIView alloc] initWithFrame:CGRectMake(0, 40.5, 140, 0.5)];
         vSepline.backgroundColor = RGBACOLOR(185,185,185, 1);
        [cell.contentView addSubview:vSepline];

        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(23, 13, 14, 14)];
        logo.tag = 100;
        [cell.contentView addSubview:logo];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 13, 80, 14)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.tag = 101;
        label.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
        
        

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = RGBACOLOR(55, 55,55, .8);
    }
    
    UIImageView *logo = (UIImageView *)[cell viewWithTag:100];
    UILabel *label = (UILabel *)[cell viewWithTag:101];

    if (indexPath.row == 0)
    {
      
        label.text = @"场馆";
        logo.image = [UIImage imageNamed:@"SearchProduct"];
        
    }
    else if (indexPath.row == 1)
    {
    
        label.text = @"教练";
        logo.image = [UIImage imageNamed:@"SearchShop"];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
        case 0:
        {
            [Config currentConfig].searchType = @"0";
            
            [UserDefaultsUtils saveValue:@"0" forKey:@"searchType"];
            
            
            break;
        }
        case 1:
        {
            [Config currentConfig].searchType = @"1";
            [UserDefaultsUtils saveValue:@"1" forKey:@"searchType"];
            
            
            
            break;
        }
       
        default:
            break;
    }
  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchTypeChange" object:nil];
    [self disappear];
}

@end

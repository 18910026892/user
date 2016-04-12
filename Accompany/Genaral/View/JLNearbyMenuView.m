//
//  JLNearbyMenuView.m
//  Accompany
//
//  Created by GongXin on 16/3/7.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLNearbyMenuView.h"

@implementation JLNearbyMenuView
+ (JLNearbyMenuView *)sharedInstance
{
    static JLNearbyMenuView*v = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        v = [[JLNearbyMenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    
    return v;
}

+ (void)showOnWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:[JLNearbyMenuView sharedInstance]];
    [window bringSubviewToFront:[JLNearbyMenuView sharedInstance]];
}

+ (void)hide
{
    [[JLNearbyMenuView sharedInstance] disappear];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatMenuClick" object:nil];
}

-(void)InitTriangleView;
{
    if (!_triangleView) {
        _triangleView = [[UIImageView alloc]init];
        _triangleView.frame = CGRectMake(kMainBoundsWidth-40, 56, 17, 8);
        _triangleView.image = [UIImage imageNamed:@"triangle"];
        _triangleView.alpha = 1;
        [self addSubview:_triangleView];
    }
    
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(kMainBoundsWidth-150, 64, 140, 160) style:UITableViewStylePlain];
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCellIndi = @"menuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCellIndi];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellIndi];
        
        cell.backgroundColor = RGBACOLOR(55, 55,55, .8);
        
        UIView *vSepline = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 140, 0.5)];
        vSepline.backgroundColor = RGBACOLOR(185,185,185, 1);
        [cell.contentView addSubview:vSepline];
        
 
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 140, 14)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 101;
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    UILabel *label = (UILabel *)[cell viewWithTag:101];
    
    if (indexPath.row == 0)
    {
        
        label.text = @"只看男生";
      
        
    }
    else if (indexPath.row == 1)
    {
        
        label.text = @"只看女生";
    
        
    }else if(indexPath.row == 2)
    {
        label.text = @"查看全部";
    
    }else if(indexPath.row==3)
    {
        label.text = @"清除位置并退出";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString * row = [NSString stringWithFormat:@"%ld",indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NearbyMenuClick" object:row];
    
    [self disappear];
}

@end

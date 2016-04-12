//
//  JLChatMenuView.m
//  Accompany
//
//  Created by GongXin on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLChatMenuView.h"

@implementation JLChatMenuView
+ (JLChatMenuView *)sharedInstance
{
    static JLChatMenuView*v = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        v = [[JLChatMenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    
    return v;
}

+ (void)showOnWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:[JLChatMenuView sharedInstance]];
    [window bringSubviewToFront:[JLChatMenuView sharedInstance]];
}

+ (void)hide
{
    [[JLChatMenuView sharedInstance] disappear];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(kMainBoundsWidth-150, 64, 140, 120) style:UITableViewStylePlain];
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
    return 3;
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
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(23, 13, 18, 18)];
        logo.tag = 100;
        [cell.contentView addSubview:logo];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 13, 80, 14)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.tag = 101;
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIImageView *logo = (UIImageView *)[cell viewWithTag:100];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    
    if (indexPath.row == 0)
    {
        
        label.text = @"加好友";
        logo.image = [UIImage imageNamed:@"menu1"];
        
    }
    else if (indexPath.row == 1)
    {
        
        label.text = @"附近的人";
         logo.frame = CGRectMake(25, 13, 13, 18);
        logo.image = [UIImage imageNamed:@"menu2"];
        
    }else if(indexPath.row == 2)
    {
        label.text = @"扫一扫";
        logo.frame = CGRectMake(23, 13, 18, 18);
       logo.image = [UIImage imageNamed:@"menu3"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"用户点击了第%ld行",(long)indexPath.row);
    
    NSString * row = [NSString stringWithFormat:@"%ld",indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatMenuClick" object:row];
    
    [self disappear];
}

@end

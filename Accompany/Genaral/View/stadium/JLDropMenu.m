//
//  JLDropMenu.m
//  Accompany
//
//  Created by GongXin on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLDropMenu.h"
@interface JLDropMenu()

@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *backGroundView;

@end

#define ScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
@implementation JLDropMenu

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, 0)];
    if (self) {
        _origin = origin;
        _show = NO;
        _height = height;
        
  
        
        
        _LeftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, ScreenWidth*0.3, 0) style:UITableViewStylePlain];
        _LeftTableView.rowHeight = 38;
        _LeftTableView.dataSource = self;
        _LeftTableView.delegate = self;
        _LeftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _LeftTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.f];
        
        //tableView init
        _RightTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x+ScreenWidth*0.3, self.frame.origin.y + self.frame.size.height, ScreenWidth*0.7, 0) style:UITableViewStylePlain];
        _RightTableView.rowHeight = 38;
        _RightTableView.dataSource = self;
        _RightTableView.delegate = self;
        _RightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //self tapped
        self.backgroundColor = [UIColor whiteColor];
        
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        
        //add bottom shadow
        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
        bottomShadow.backgroundColor = [UIColor clearColor];
        [self addSubview:bottomShadow];
    }
    return self;
}



#pragma mark - gesture handle

- (void)menuTapped{
    if (!_show) {
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.LeftTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    [self animateBackGroundView:self.backGroundView show:!_show complete:^{
        [self animateTableViewShow:!_show complete:^{
            [self tableView:self.LeftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            _show = !_show;
        }];
    }];
    
}

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    [self animateBackGroundView:_backGroundView show:NO complete:^{
        [self animateTableViewShow:NO complete:^{
            _show = NO;
        }];
    }];
}

#pragma mark - animation method


- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateTableViewShow:(BOOL)show complete:(void(^)())complete {
    if (show) {
        

        _LeftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y, ScreenWidth*0.3, 0);
        [self.superview addSubview:_LeftTableView];
        
        
        _RightTableView.frame = CGRectMake(self.origin.x+ScreenWidth*0.3, self.frame.origin.y, ScreenWidth*0.7, 0);
        [self.superview addSubview:_RightTableView];
        
       
        _LeftTableView.alpha = 1.f;
         _RightTableView.alpha = 1.f;
        [UIView animateWithDuration:0.2 animations:^{
           
            _LeftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y, ScreenWidth*0.3, _height);
            
             _RightTableView.frame = CGRectMake(self.origin.x+ScreenWidth*0.3, self.frame.origin.y, ScreenWidth*0.7, _height);
            
            if (self.transformView) {
                self.transformView.transform = CGAffineTransformMakeRotation(M_PI);
            }
        } completion:^(BOOL finished) {
            
        }];
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
           
            _LeftTableView.alpha = 0.f;
             _RightTableView.alpha = 0.f;
            if (self.transformView) {
                self.transformView.transform = CGAffineTransformMakeRotation(0);
            }
        } completion:^(BOOL finished) {
        
            [_LeftTableView removeFromSuperview];
            [_RightTableView removeFromSuperview];
        }];
    }
    complete();
}


#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:numberOfRowsInSection:)]) {
        return [self.dataSource menu:self tableView:tableView
               numberOfRowsInSection:section];
    } else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DropDownMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.textLabel.highlightedTextColor = [UIColor redColor];
        NSIndexPath * first = [NSIndexPath indexPathForRow:0 inSection:0];
         [_LeftTableView selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        
        
    }
    NSAssert(self.dataSource != nil, @"menu's datasource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:titleForRowAtIndexPath:)]) {
        cell.textLabel.text = [self.dataSource menu:self tableView:tableView titleForRowAtIndexPath:indexPath];
    } else {
        NSAssert(0 == 1, @"dataSource method needs to be implemented");
    }
    if(tableView == _RightTableView){
        cell.backgroundColor = [UIColor whiteColor];
        cell.tag = indexPath.row;
        
//        _SelectImageView = [[UIImageView alloc]init];
//        _SelectImageView.frame = CGRectMake(kMainScreenWidth/2, 12, 20, 20);
//        _SelectImageView.layer.cornerRadius = 10;
//        _SelectImageView.layer.masksToBounds = YES;
//        _SelectImageView.backgroundColor = [UIColor redColor];
//        _SelectImageView.tag = 1000+indexPath.row;
//        _SelectImageView.hidden = NO;
//        [cell.contentView addSubview:_SelectImageView];
//        
        
    }else{
        UIView *sView = [[UIView alloc] init];
        sView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = sView;
        [cell setSelected:YES animated:NO];
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.f];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.separatorInset = UIEdgeInsetsZero;
    
    
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:tableView:didSelectRowAtIndexPath:)]) {
        if (tableView == self.RightTableView) {
        

            [self animateBackGroundView:_backGroundView show:NO complete:^{
                [self animateTableViewShow:NO complete:^{
                    _show = NO;
                }];
            }];
        }
        [self.delegate menu:self tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        //TODO: delegate is nil
    }
}

@end


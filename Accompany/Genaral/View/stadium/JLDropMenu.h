//
//  JLDropMenu.h
//  Accompany
//
//  Created by GongXin on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLDropMenu;

@protocol JLDropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(JLDropMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;
- (NSString *)menu:(JLDropMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - delegate
@protocol JLDropDownMenuDelegate <NSObject>
@optional
- (void)menu:(JLDropMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface JLDropMenu : UIView<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UITableView *LeftTableView;
@property (nonatomic, strong) UITableView *RightTableView;

@property (nonatomic,strong)UIImageView * SelectImageView;


@property (nonatomic, strong) UIView *transformView;

@property (nonatomic, weak) id <JLDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <JLDropDownMenuDelegate> delegate;

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;

-(void)menuTapped;

@end
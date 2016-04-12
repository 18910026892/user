//
//  JLNearbyMenuView.h
//  Accompany
//
//  Created by GongXin on 16/3/7.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLNearbyMenuView : UIView<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView * triangleView;
+ (void)showOnWindow;
+ (void)hide;

@end

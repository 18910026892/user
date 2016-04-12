//
//  JLChatMenuView.h
//  Accompany
//
//  Created by GongXin on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLChatMenuView : UIView<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView * triangleView;
+ (void)showOnWindow;
+ (void)hide;
@end
